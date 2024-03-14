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
  resources_iterable = merge(
    {
      for resource in var.resources :
      element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 1) => resource
    },
    {
      # Handle blob subresource for storage accounts
      for resource in var.resources :
      "${element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 1)}-blob" => {
        resource_id       = "${resource.resource_id}/blobServices/default"
        log_categories    = try(resource.storage_blob_log_categories, null)
        metric_categories = try(resource.storage_blob_metric_categories, null)
      } if lower(element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 2)) == "storageaccounts"
    },
    {
      # Handle file subresource for storage accounts
      for resource in var.resources :
      "${element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 1)}-file" => {
        resource_id       = "${resource.resource_id}/fileServices/default"
        log_categories    = try(resource.storage_file_log_categories, null)
        metric_categories = try(resource.storage_file_metric_categories, null)
      } if lower(element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 2)) == "storageaccounts"
    },
    {
      # Handle queue subresource for storage accounts
      for resource in var.resources :
      "${element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 1)}-queue" => {
        resource_id       = "${resource.resource_id}/queueServices/default"
        log_categories    = try(resource.storage_queue_log_categories, null)
        metric_categories = try(resource.storage_queue_metric_categories, null)
      } if lower(element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 2)) == "storageaccounts"
    },
    {
      # Handle table subresource for storage accounts
      for resource in var.resources :
      "${element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 1)}-table" => {
        resource_id       = "${resource.resource_id}/tableServices/default"
        log_categories    = try(resource.storage_table_log_categories, null)
        metric_categories = try(resource.storage_table_metric_categories, null)
      } if lower(element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 2)) == "storageaccounts"
    }
  )
}
