resource "azurerm_postgresql_server" "this" {
  name                              = var.name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  administrator_login               = var.administrator_login
  administrator_login_password      = var.administrator_login_password
  sku_name                          = var.sku_name
  version                           = var.server_version
  storage_mb                        = var.storage_mb
  auto_grow_enabled                 = true
  backup_retention_days             = var.backup_retention_days
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  tags                              = var.tags
}
