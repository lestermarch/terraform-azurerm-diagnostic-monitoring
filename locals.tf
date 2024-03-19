locals {
  # Determine whether to use custom diagnostic categories or all diagnostic categories per resource
  resources = {
    for resource_key, resource in var.resources :
    resource_key => {
      resource_id       = resource.resource_id
      log_categories    = coalesce(resource.log_categories, data.azurerm_monitor_diagnostic_categories.monitoring[resource_key].log_category_types, [])
      metric_categories = coalesce(resource.metric_categories, data.azurerm_monitor_diagnostic_categories.monitoring[resource_key].metrics, [])
    }
  }
}
