data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "this" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = coalesce(var.tenant_id, data.azurerm_client_config.current.tenant_id)
  sku_name                      = var.sku_name
  purge_protection_enabled      = var.purge_protection
  soft_delete_retention_days    = var.soft_delete_retention_days
  rbac_authorization_enabled    = true
  public_network_access_enabled = false
  tags                          = var.tags
}

resource "azurerm_private_endpoint" "kv"{
  name                = "${var.name}-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pep.id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.name}-psc"
    private_connection_resource_id = azurerm_key_vault.kv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}
output "id" { value = azurerm_key_vault.this.id }
output "vault_uri" { value = azurerm_key_vault.this.vault_uri }
