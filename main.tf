terraform {
  required_version = ">= 0.12.0"
  backend "azurerm" {}
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
  name                     = format("%s%ssa", lower(replace(var.name, "/[[:^alnum:]]/", "")), random_string.unique.result)
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = azurerm_resource_group.storage.location
  account_kind             = "StorageV2"
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier

  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = true

  dynamic "network_rules" {
    for_each = length(concat(var.network_rules_ip_rules, var.network_rules_subnet_ids)) > 0 ? ["true"] : []
    content {
      ip_rules                   = var.network_rules_ip_rules
      virtual_network_subnet_ids = var.network_rules_subnet_ids
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "storage" {
  count                 = length(var.containers)
  name                  = var.containers[count.index].name
  resource_group_name   = azurerm_resource_group.storage.name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = var.containers[count.index].access_type
}

resource "azurerm_eventgrid_event_subscription" "storage" {
  count = length(var.events)
  name  = var.events[count.index].name
  scope = azurerm_storage_account.storage.id

  event_delivery_schema = lookup(var.events[count.index], "event_delivery_schema", null) == null ? null : var.events[count.index].event_delivery_schema
  topic_name            = lookup(var.events[count.index], "topic_name", null) == null ? null : var.events[count.index].topic_name
  labels                = lookup(var.events[count.index], "labels", null) == null ? null : var.events[count.index].labels

  dynamic "eventhub_endpoint" {
    for_each = var.events[count.index].eventhub_id == null ? [] : [var.events[count.index].eventhub_id]
    content {
      eventhub_id = var.events[count.index].eventhub_id
    }
  }

  dynamic "subject_filter" {
    for_each = lookup(var.events[count.index], "filters", null) == null ? [] : [var.events[count.index].filters]
    content {
      subject_begins_with = lookup(var.events[count.index].filters, "subject_begins_with", null) == null ? null : var.events[count.index].filters.subject_begins_with
      subject_ends_with   = lookup(var.events[count.index].filters, "subject_ends_with", null) == null ? null : var.events[count.index].filters.subject_ends_with
    }
  }
}