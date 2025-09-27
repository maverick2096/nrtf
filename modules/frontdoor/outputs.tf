output "profile_id" {
  value = azurerm_cdn_frontdoor_profile.this.id
}

output "endpoint_id" {
  value = azurerm_cdn_frontdoor_endpoint.this.id
}

output "origin_group_id" {
  value = azurerm_cdn_frontdoor_origin_group.this.id
}

output "origin_id" {
  value = azurerm_cdn_frontdoor_origin.this.id
}

output "route_id" {
  value = azurerm_cdn_frontdoor_route.this.id
}
