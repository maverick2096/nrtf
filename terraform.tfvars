# ======== terraform.tfvars (example) ========
# Global
location = "eastus"
tags = {
  env        = "dev"
  owner      = "platform-team"
  costcenter = "core"
}

# Toggles (booleans)
build_resource_group       = true
build_acr                  = true
build_key_vault            = true
build_log_analytics        = true
build_vm                   = false # set true only if vm inputs provided
enable_private_endpoints   = true
build_servicebus           = true
build_app_service          = true
build_storage              = true
build_private_dns_zone     = true
build_private_link_service = true
build_recovery_vault       = true
build_postgres             = true
build_nsg                  = true
build_load_balancer        = true
build_api_management       = true
build_frontdoor            = false

# Networking
virtual_network_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-core"
private_endpoint_subnet_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-core/subnets/snet-privateEndpoints"
private_link_service_subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-core/subnets/snet-private-link"
private_dns_zone_name          = "privatelink.internal"
private_dns_zone_vnet_ids = [
  "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-core"
]
private_dns_zone_link_name = "pdns-link-vnet-core"

# Resource Group
rg_name = "rg-az-eastus-project-application"

# ACR
acr_name                               = "acrprojectapp001"
acr_sku                                = "Premium"
acr_admin_enabled                      = false
acr_private_endpoint_subresource_names = ["registry"]

# Key Vault
kv_name                       = "kv-az-eastus-projapp"
kv_sku                                = "premium"
kv_purge_protection                   = true
kv_soft_delete_retention_days         = 7
kv_private_endpoint_subresource_names = ["vault"]

# Log Analytics
log_analytics_name                               = "law-az-eastus-project-application"
log_analytics_sku                                = "PerGB2018"
log_analytics_retention_days                     = 30
log_analytics_private_endpoint_subresource_names = ["workspace"]

# VM (Linux) - provide details when build_vm = true
vm_name            = "vm-az-eastus-project-application"
vm_admin_user      = "azureuser"
vm_ssh_public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCexampleplaceholder user@host"
vm_size            = "Standard_DS2_v2"
vm_os_disk_size_gb = 64
vm_subnet_id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-core/subnets/snet-app"

# Service Bus
sb_namespace_name                     = "sb-az-eastus-project-application"
sb_sku                                = "Premium"
sb_queues                             = ["ingress", "egress"]
sb_private_endpoint_subresource_names = ["namespace"]

# App Service
app_service_plan_name = "asp-az-eastus-project-application"
app_service_sku       = "P1v3"
app_name              = "app-az-eastus-project-application"
app_settings = {
  "WEBSITE_RUN_FROM_PACKAGE" = "1"
}
app_private_endpoint_subresource_names = ["sites"]

# Storage Account
sa_name                                    = "saprojapp001"
sa_tier                                    = "Standard"
sa_replication                             = "GRS"
storage_containers                         = ["content", "logs"]
storage_private_endpoint_subresource_names = ["blob"]

# Private Link Service
private_link_service_name                              = "pls-az-eastus-project-application"
private_link_service_lb_frontend_ip_configuration_name = "pls-frontend"

# Recovery Services Vault
rsv_name = "rsv-az-eastus-project-application"
rsv_sku  = "Standard"

# PostgreSQL Single Server
postgres_server_name            = "pg-az-eastus-project-application"
postgres_sku_name               = "GP_Gen5_4"
postgres_version                = "11"
postgres_administrator_login    = "pgadmin"
postgres_administrator_password = "ChangeM3Now!"
postgres_storage_mb             = 51200

# Network Security Group
nsg_name = "nsg-az-eastus-project-application"
nsg_security_rules = [
  {
    name                       = "Allow-HTTPS-Out"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

# Load Balancer
lb_name                           = "lb-az-eastus-project-application"
lb_frontend_ip_configuration_name = "lb-frontend"
lb_backend_pool_name              = "lb-backend"
lb_is_public                      = false
lb_private_ip_address             = "10.10.1.10"

# API Management
apim_name            = "apim-az-eastus-project-application"
apim_publisher_email = "apim-admin@example.com"
apim_publisher_name  = "Contoso Platform"
apim_sku_name        = "Premium_1"

# Front Door
frontdoor_name                                = "fd-az-eastus-project-application"
frontdoor_sku_name                            = "Premium_AzureFrontDoor"
frontdoor_endpoint_name                       = "fde-az-eastus-project-application"
frontdoor_origin_host_name                    = "app-az-eastus-project-application.azurewebsites.net"
frontdoor_origin_host_header                  = "app-az-eastus-project-application.azurewebsites.net"
frontdoor_origin_private_link_target          = null
frontdoor_origin_private_link_location        = null
frontdoor_origin_private_link_request_message = "Requesting approval for Front Door private link"
