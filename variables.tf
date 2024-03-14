variable "log_analytics_workspace_id" {
  description = "The ID of a log analytics workspace to forward network interface metrics to."
  type        = string
}

variable "resources" {
  description = <<-EOT
  A list of objects used to forward diagnostic logs and metrics to a log analytics workspace for one or more resources, in the format:
  ```
  [
    {
      resource_id = "/subscriptions/.../registries/crexample"
    }
    {
      resource_id = "/subscriptions/.../storageAccounts/stexample"
      storage_blob_log_categories = [
        "StorageDelete"
      ]
    },
    {
      resource_id = "/subscriptions/.../vaults/kv-example"
      metric_categories = [
        "Availability",
        "SaturationShoebox",
        "ServiceApiLatency"
      ]
    }
  ]
  ```
  Notes:
  - All log categories will be enabled unless `log_categories` is specified.
  - All metric categories will be enbled unless `metric_categories` is specified.
  - Storage account subresource (blob, file, queue, table) logs and metrics may be specified using the approprite attributes.
  EOT
  type = list(object({
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
}
