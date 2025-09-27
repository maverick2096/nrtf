resource "azurerm_private_endpoint" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = coalesce(var.private_service_connection_name, "${var.name}-psc")
    private_connection_resource_id = var.private_connection_resource_id
    is_manual_connection           = false
    subresource_names              = var.subresource_names
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id == null ? [] : [var.private_dns_zone_id]
    content {
      name                 = coalesce(var.private_dns_zone_group_name, "default")
      private_dns_zone_ids = [private_dns_zone_group.value]
    }
  }
}

output "id" {
  value = azurerm_private_endpoint.this.id
}
