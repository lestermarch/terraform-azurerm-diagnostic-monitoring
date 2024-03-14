variable "log_analytics_workspace_id" {
  description = "The ID of a log analytics workspace to forward network interface metrics to."
  type        = string
}

variable "resources" {
  description = <<-EOT
  A list of objects used to forward diagnostic logs and metrics to a log analytics workspace for one or more resources, in the format:
  ```hcl
  [
    {
      resource_id = "/subscriptions/.../storageAccounts/stexample"
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
  - All log categories will be enabled unless `log_categories`
  EOT
  type = list(object({
    resource_id       = string
    log_categories    = optional(list(string))
    metric_categories = optional(list(string))
  }))
}
