locals {
  # Complete map of all monitored resources
  all_resources = merge(
    local.resources,
    local.storage_account_blob_resources,
    local.storage_account_file_resources,
    local.storage_account_queue_resources,
    local.storage_account_table_resources
  )

  # Determine whether to use custom diagnostic categories or all diagnostic categories per resource
  resources = {
    for resource_key, resource in var.resources :
    resource_key => {
      resource_id       = resource.resource_id
      log_categories    = coalesce(resource.log_categories, data.azurerm_monitor_diagnostic_categories.monitoring[resource_key].log_category_types, [])
      metric_categories = coalesce(resource.metric_categories, data.azurerm_monitor_diagnostic_categories.monitoring[resource_key].metrics, [])
    }
  }

  # Default storage account subresource (blob, file, queue, table) diagnostic categories
  storage_log_categories    = ["StorageDelete", "StorageRead", "StorageWrite"]
  storage_metric_categories = ["Transaction"]

  # Handle blob subresource diagnostics for storage accounts
  storage_account_blob_resources = {
    for resource_key, resource in var.resources :
    "${resource_key}_blob" => {
      resource_id       = "${resource.resource_id}/blobServices/default"
      log_categories    = coalesce(resource.storage_blob_log_categories, local.storage_log_categories)
      metric_categories = coalesce(resource.storage_blob_metric_categories, local.storage_metric_categories)
    } if lower(element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 2)) == "storageaccounts"
  }

  # Handle file subresource diagnostics for storage accounts
  storage_account_file_resources = {
    for resource_key, resource in var.resources :
    "${resource_key}_file" => {
      resource_id       = "${resource.resource_id}/fileServices/default"
      log_categories    = coalesce(resource.storage_file_log_categories, local.storage_log_categories)
      metric_categories = coalesce(resource.storage_file_metric_categories, local.storage_metric_categories)
    } if lower(element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 2)) == "storageaccounts"
  }

  # Handle queue subresource diagnostics for storage accounts
  storage_account_queue_resources = {
    for resource_key, resource in var.resources :
    "${resource_key}_queue" => {
      resource_id       = "${resource.resource_id}/queueServices/default"
      log_categories    = coalesce(resource.storage_queue_log_categories, local.storage_log_categories)
      metric_categories = coalesce(resource.storage_queue_metric_categories, local.storage_metric_categories)
    } if lower(element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 2)) == "storageaccounts"
  }

  # Handle table subresource diagnostics for storage accounts
  storage_account_table_resources = {
    for resource_key, resource in var.resources :
    "${resource_key}_table" => {
      resource_id       = "${resource.resource_id}/tableServices/default"
      log_categories    = coalesce(resource.storage_table_log_categories, local.storage_log_categories)
      metric_categories = coalesce(resource.storage_table_metric_categories, local.storage_metric_categories)
    } if lower(element(split("/", resource.resource_id), length(split("/", resource.resource_id)) - 2)) == "storageaccounts"
  }
}
