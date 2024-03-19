variable "log_analytics_workspace_id" {
  description = "The ID of a log analytics workspace to forward network interface metrics to."
  type        = string
}

variable "resources" {
  description = <<-EOT
  A map of objects used to forward diagnostic logs and metrics to a log analytics workspace for one or more resources, in the format:
  ```
  {
    stexample = {
      resource_id = "/subscriptions/.../storageAccounts/stexample"
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
  EOT
  type = map(object({
    resource_id       = string
    log_categories    = optional(list(string))
    metric_categories = optional(list(string))
  }))
}
