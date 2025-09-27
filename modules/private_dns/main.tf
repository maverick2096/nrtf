resource "azurerm_private_dns_zone" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = { for idx, vnet_id in var.virtual_network_ids : format("%s-%02d", coalesce(var.link_name, "pdns-link"), idx + 1) => vnet_id }

  name                  = each.key
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = each.value
  registration_enabled  = false
}
