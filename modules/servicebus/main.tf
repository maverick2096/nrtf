resource "azurerm_servicebus_namespace" "ns" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  tags                          = var.tags
  public_network_access_enabled = false
}

resource "azurerm_servicebus_queue" "q" {
  for_each             = toset(var.queues)
  name                 = each.key
  namespace_id         = azurerm_servicebus_namespace.ns.id
  partitioning_enabled = true
}

output "namespace_id" { value = azurerm_servicebus_namespace.ns.id }
