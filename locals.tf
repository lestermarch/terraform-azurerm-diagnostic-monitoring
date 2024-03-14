locals {
  # Determine whether to use custom diagnostic categories or all diagnostic categories per resource
  resources = {
    for resource_name, config in local.resources_iterable :
    resource_name => {
      resource_id       = config.resource_id
      log_categories    = coalesce(config.log_categories, data.azurerm_monitor_diagnostic_categories.monitoring[resource_name].log_category_types, [])
      metric_categories = coalesce(config.metric_categories, data.azurerm_monitor_diagnostic_categories.monitoring[resource_name].metrics, [])
    }
  }

  # Map of resource names to their diagnostic monitoring configuration
  resources_iterable = {
    for resource in var.resources :
    element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 1) => resource
  }
}
