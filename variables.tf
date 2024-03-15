variable "log_analytics_workspace_id" {
  description = "The ID of a log analytics workspace to forward network interface metrics to."
  type        = string
}

variable "resources" {
  description = <<-EOT
  A map of objects used to forward diagnostic logs and metrics to a log analytics workspace for one or more resources, in the format:
  ```
  {
    crexample = {
      resource_id = "/subscriptions/.../registries/crexample"
    }
    stexample = {
      resource_id = "/subscriptions/.../storageAccounts/stexample"
      storage_blob_log_categories = [
        "StorageDelete"
      ]
    },
    kv-example = {
      resource_id = "/subscriptions/.../vaults/kv-example"
      metric_categories = [
        "Availability",
        "SaturationShoebox",
        "ServiceApiLatency"
      ]
    }
  }
  ```
  Notes:
  - Each endpoint object must have a unique map key and must be statically defined. It is recommended to use the resource name for this, if known.
  - All log categories will be enabled unless `log_categories` is specified.
  - All metric categories will be enbled unless `metric_categories` is specified.
  - Storage account subresource (blob, file, queue, table) logs and metrics may be specified using the approprite attributes.
  EOT
  type = map(object({
    resource_id                     = string
    log_categories                  = optional(list(string))
    metric_categories               = optional(list(string))
    storage_blob_log_categories     = optional(list(string))
    storage_blob_metric_categories  = optional(list(string))
    storage_file_log_categories     = optional(list(string))
    storage_file_metric_categories  = optional(list(string))
    storage_queue_log_categories    = optional(list(string))
    storage_queue_metric_categories = optional(list(string))
    storage_table_log_categories    = optional(list(string))
    storage_table_metric_categories = optional(list(string))
  }))

  # Ensure only storage account resources can specifiy storage subresource diagnostic categories
  validation {
    condition = alltrue([
      for resource_key, resource in var.resources : (
        lower(element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 2)) == "storageaccounts" ||
        (
          lower(element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 2)) != "storageaccounts" &&
          resource.storage_blob_log_categories == null &&
          resource.storage_blob_metric_categories == null &&
          resource.storage_file_log_categories == null &&
          resource.storage_file_metric_categories == null &&
          resource.storage_queue_log_categories == null &&
          resource.storage_queue_metric_categories == null &&
          resource.storage_table_log_categories == null &&
          resource.storage_table_metric_categories == null
        )
      )
    ])
    error_message = "Only storage account resources may have storage log or metric attributes set."
  }
}
