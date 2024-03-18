variable "name" {
  description = "Name of storage account. Unless var.exact_name is true any illegal characters (,-_ etc) will be truncated and 6 random characters will be appended to this value."
  type        = string
}

variable "exact_name" {
  description = "When true, var.name is used exactly as passed"
  type        = bool
  default     = false
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
}

variable "resource_group_create" {
  description = "Create resource group. Defaults to true"
  default     = true
  type        = bool
}

variable "location" {
  description = "Azure location where resources should be deployed."
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium. Changing this forces a new resource to be created."
  default     = "Standard"
}

variable "account_kind" {
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing this forces a new resource to be created. Defaults to StorageV2."
  default     = "StorageV2"
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "ZRS"
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage and StorageV2 accounts. Valid options are Hot and Cool."
  default     = "Hot"
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account. Possible values are TLS1_0, TLS1_1, and TLS1_2."
  default     = "TLS1_2"
}

variable "soft_delete_retention" {
  description = "Number of retention days for soft delete. If set to null it will disable soft delete all together."
  type        = number
  default     = 31
}

variable "cors_rule" {
  description = "CORS rules for storage account."
  type = list(object({
    allowed_origins    = list(string)
    allowed_methods    = list(string)
    allowed_headers    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  default = []
}

variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled."
  type        = bool
  default     = false
}

variable "network_rules" {
  description = "Network rules restricting access to the storage account."
  type = object({
    ip_rules   = list(string)
    subnet_ids = list(string)
    bypass     = list(string)
  })
  default = null
}

variable "containers" {
  description = "List of containers to create in the storage account."
  type = list(object({
    name        = string
    access_type = string
    role_assignments = optional(list(object({
      principal_id         = string
      role_definition_name = string
    })), [])
  }))
  default = []
}

variable "role_assignments" {
  description = "Role assignments for this storage account."
  type = list(object({
    principal_id         = string
    role_definition_name = string
  }))
  default = []
}

variable "events" {
  description = "List of event subscriptions. See documentation for format description."
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

variable "lifecycles" {
  description = "List of lifecycle delete"
  type = list(object({
    prefix_match      = set(string)
    delete_after_days = number
  }))
  default = []
}

variable "diagnostics" {
  description = "Diagnostic settings for those resources that support it. See README.md for details on configuration."
  type = object({
    destination   = string
    eventhub_name = string
    logs          = list(string)
    metrics       = list(string)
  })
  default = null
}
