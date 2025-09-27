output "lb_id" {
  value = azurerm_lb.this.id
}

output "frontend_ip_configuration_id" {
  value = azurerm_lb.this.frontend_ip_configuration[0].id
}

output "frontend_ip_configuration_ids" {
  value = [for cfg in azurerm_lb.this.frontend_ip_configuration : cfg.id]
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.this.id
}

output "public_ip_id" {
  value = try(azurerm_public_ip.this[0].id, null)
}
