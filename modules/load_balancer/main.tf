resource "azurerm_public_ip" "this" {
  count               = var.is_public ? 1 : 0
  name                = coalesce(var.public_ip_name, "${var.name}-pip")
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_lb" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                          = var.frontend_ip_configuration_name
    subnet_id                     = var.is_public ? null : var.subnet_id
    private_ip_address            = var.is_public ? null : var.private_ip_address
    private_ip_address_allocation = var.is_public || var.private_ip_address == null ? "Dynamic" : "Static"
    public_ip_address_id          = var.is_public ? azurerm_public_ip.this[0].id : null
  }
}

resource "azurerm_lb_backend_address_pool" "this" {
  loadbalancer_id = azurerm_lb.this.id
  name            = var.backend_pool_name
}
