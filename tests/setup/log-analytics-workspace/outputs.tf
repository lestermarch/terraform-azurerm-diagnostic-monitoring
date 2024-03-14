output "log_analytics_workspace_id" {
  description = "The ID of the log analytics workspace."
  value       = azurerm_log_analytics_workspace.monitoring.id
}
