terraform {
  required_version = ">= 0.12.6"
}

provider azurerm {
  version = "~> 2.12.0"
  features {}
}

provider random {
  version = "~> 2.2"
}

locals {
  default_event_rule = {
    event_delivery_schema = null
    topic_name            = null
    labels                = null
    filters               = null
    eventhub_id           = null
    service_bus_topic_id  = null
    service_bus_queue_id  = null
    included_event_types  = null
  }

  merged_events = [for event in var.events : merge(local.default_event_rule, event)]
}

resource "azurerm_resource_group" "storage" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage" {
  name                      = format("%s%ssa", lower(replace(var.name, "/[[:^alnum:]]/", "")), random_string.unique.result)
  resource_group_name       = azurerm_resource_group.storage.name
  location                  = azurerm_resource_group.storage.location
  account_kind              = "StorageV2"
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.access_tier
  enable_https_traffic_only = true

  blob_properties {
    delete_retention_policy {
      days = var.soft_delete_retention
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules != null ? ["true"] : []
    content {
      default_action             = "Deny"
      ip_rules                   = var.network_rules.ip_rules
      virtual_network_subnet_ids = var.network_rules.subnet_ids
      bypass                     = var.network_rules.bypass
    }
  }

  tags = var.tags
}

resource "azurerm_advanced_threat_protection" "threat_protection" {
  target_resource_id = azurerm_storage_account.storage.id
  enabled            = var.enable_advanced_threat_protection
}

resource "azurerm_storage_container" "storage" {
  count                 = length(var.containers)
  name                  = var.containers[count.index].name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = var.containers[count.index].access_type
}

resource "azurerm_eventgrid_event_subscription" "storage" {
  count = length(local.merged_events)
  name  = local.merged_events[count.index].name
  scope = azurerm_storage_account.storage.id

  event_delivery_schema         = local.merged_events[count.index].event_delivery_schema
  topic_name                    = local.merged_events[count.index].topic_name
  labels                        = local.merged_events[count.index].labels
  included_event_types          = local.merged_events[count.index].included_event_types
  eventhub_endpoint_id          = local.merged_events[count.index].eventhub_id
  service_bus_topic_endpoint_id = local.merged_events[count.index].service_bus_topic_id
  service_bus_queue_endpoint_id = local.merged_events[count.index].service_bus_queue_id

  dynamic "subject_filter" {
    for_each = local.merged_events[count.index].filters == null ? [] : [true]
    content {
      subject_begins_with = lookup(local.merged_events[count.index].filters, "subject_begins_with", null) == null ? null : var.events[count.index].filters.subject_begins_with
      subject_ends_with   = lookup(local.merged_events[count.index].filters, "subject_ends_with", null) == null ? null : var.events[count.index].filters.subject_ends_with
    }
  }
}

resource "azurerm_storage_management_policy" "storage" {
  count = length(var.lifecycles) == 0 ? 0 : 1

  storage_account_id = azurerm_storage_account.storage.id

  dynamic "rule" {
    for_each = var.lifecycles
    iterator = rule
    content {
      name    = "rule${rule.key}"
      enabled = true
      filters {
        prefix_match = rule.value.prefix_match
        blob_types   = ["blockBlob"]
      }
      actions {
        base_blob {
          delete_after_days_since_modification_greater_than = rule.value.delete_after_days
        }
      }
    }
  }
}