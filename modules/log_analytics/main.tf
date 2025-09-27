resource "azurerm_log_analytics_workspace" "this" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku                        = var.sku
  retention_in_days          = var.retention_days
  internet_ingestion_enabled = false
  internet_query_enabled     = false
  tags                       = var.tags
}

output "id" { value = azurerm_log_analytics_workspace.this.id }
output "name" { value = azurerm_log_analytics_workspace.this.name }
