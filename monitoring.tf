data "azurerm_monitor_diagnostic_categories" "monitoring" {
  for_each = var.resources

  resource_id = each.value.resource_id
}

resource "azurerm_monitor_diagnostic_setting" "monitoring" {
  for_each = local.all_resources

  name                       = each.key
  log_analytics_workspace_id = var.log_analytics_workspace_id
  target_resource_id         = each.value.resource_id

  dynamic "enabled_log" {
    for_each = toset(each.value.log_categories)

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = toset(each.value.metric_categories)

    content {
      category = metric.value
      enabled  = true
    }
  }
}
