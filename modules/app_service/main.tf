resource "azurerm_service_plan" "plan" {
  name                = var.plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "app" {
  name                = var.app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.plan.id
  identity {
    type = "SystemAssigned"
  }
  https_only                    = true
  public_network_access_enabled = false

  app_settings = var.app_settings

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
  tags = var.tags
}

output "default_hostname" { value = azurerm_linux_web_app.app.default_hostname }
output "id" { value = azurerm_linux_web_app.app.id }

