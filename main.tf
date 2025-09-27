############################
# Resource Group
############################
module "resource_group" {
  source = "./modules/resource_group"
  count  = local.enable_rg ? 1 : 0

  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

############################
# ACR
############################
module "acr" {
  source = "./modules/acr"
  count  = local.enable_acr ? 1 : 0

  name                = var.acr_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  tags                = var.tags
}

############################
# Key Vault
############################
module "key_vault" {
  source = "./modules/key_vault"
  count  = local.enable_kv ? 1 : 0

  name                       = var.kv_name
  location                   = var.location
  resource_group_name        = var.rg_name
  tenant_id                  = null # current tenant by default
  sku_name                   = var.kv_sku
  purge_protection           = var.kv_purge_protection
  soft_delete_retention_days = var.kv_soft_delete_retention_days
  tags                       = var.tags
}

############################
# Log Analytics
############################
module "log_analytics" {
  source = "./modules/log_analytics"
  count  = local.enable_law ? 1 : 0

  name                = var.log_analytics_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.log_analytics_sku
  retention_days      = var.log_analytics_retention_days
  tags                = var.tags
}

############################
# VM (Linux)
############################
module "vm" {
  source = "./modules/vm_linux"
  count  = local.enable_vm ? 1 : 0

  name                = var.vm_name
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.vm_subnet_id
  admin_username      = var.vm_admin_user
  ssh_public_key      = var.vm_ssh_public_key
  vm_size             = var.vm_size
  os_disk_size_gb     = var.vm_os_disk_size_gb
  image               = var.vm_image
  tags                = var.tags
}

############################
# Service Bus
############################
module "servicebus" {
  source = "./modules/servicebus"
  count  = local.enable_servicebus ? 1 : 0

  name                = var.sb_namespace_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.sb_sku
  queues              = var.sb_queues
  tags                = var.tags
}

############################
# App Service
############################
module "app_service" {
  source = "./modules/app_service"
  count  = local.enable_app_service ? 1 : 0

  plan_name           = var.app_service_plan_name
  sku_name            = var.app_service_sku
  app_name            = var.app_name
  location            = var.location
  resource_group_name = var.rg_name
  app_settings        = var.app_settings
  tags                = var.tags
}

############################
# Storage Account
############################
module "storage" {
  source = "./modules/storage_account"
  count  = local.enable_storage ? 1 : 0

  name                     = var.sa_name
  location                 = var.location
  resource_group_name      = var.rg_name
  account_tier             = var.sa_tier
  account_replication_type = var.sa_replication
  containers               = var.storage_containers
  tags                     = var.tags
}

############################
# Networking - Private DNS & Endpoints
############################

locals {
  effective_rg_name = local.enable_rg ? module.resource_group[0].name : var.rg_name
}

module "private_dns" {
  source = "./modules/private_dns"
  count  = local.enable_private_dns ? 1 : 0

  name                = var.private_dns_zone_name
  resource_group_name = local.effective_rg_name
  virtual_network_ids = var.private_dns_zone_vnet_ids
  link_name           = var.private_dns_zone_link_name
  tags                = var.tags
}

module "acr_private_endpoint" {
  source = "./modules/private_endpoint"
  count  = local.enable_private_ep && local.enable_acr ? 1 : 0

  name                            = "${var.acr_name}-pe"
  location                        = var.location
  resource_group_name             = local.effective_rg_name
  subnet_id                       = var.private_endpoint_subnet_id
  private_connection_resource_id  = module.acr[0].id
  subresource_names               = var.acr_private_endpoint_subresource_names
  private_dns_zone_id             = local.enable_private_dns ? try(module.private_dns[0].id, null) : null
  private_dns_zone_group_name     = "acr"
  private_service_connection_name = "${var.acr_name}-psc"
  tags                            = var.tags
}

module "kv_private_endpoint" {
  source = "./modules/private_endpoint"
  count  = local.enable_private_ep && local.enable_kv ? 1 : 0

  name                            = "${var.kv_name}-pe"
  location                        = var.location
  resource_group_name             = local.effective_rg_name
  subnet_id                       = var.private_endpoint_subnet_id
  private_connection_resource_id  = module.key_vault[0].id
  subresource_names               = var.kv_private_endpoint_subresource_names
  private_dns_zone_id             = local.enable_private_dns ? try(module.private_dns[0].id, null) : null
  private_dns_zone_group_name     = "kv"
  private_service_connection_name = "${var.kv_name}-psc"
  tags                            = var.tags
}

module "log_analytics_private_endpoint" {
  source = "./modules/private_endpoint"
  count  = local.enable_private_ep && local.enable_law ? 1 : 0

  name                            = "${var.log_analytics_name}-pe"
  location                        = var.location
  resource_group_name             = local.effective_rg_name
  subnet_id                       = var.private_endpoint_subnet_id
  private_connection_resource_id  = module.log_analytics[0].id
  subresource_names               = var.log_analytics_private_endpoint_subresource_names
  private_dns_zone_id             = local.enable_private_dns ? try(module.private_dns[0].id, null) : null
  private_dns_zone_group_name     = "law"
  private_service_connection_name = "${var.log_analytics_name}-psc"
  tags                            = var.tags
}

module "sb_private_endpoint" {
  source = "./modules/private_endpoint"
  count  = local.enable_private_ep && local.enable_servicebus ? 1 : 0

  name                            = "${var.sb_namespace_name}-pe"
  location                        = var.location
  resource_group_name             = local.effective_rg_name
  subnet_id                       = var.private_endpoint_subnet_id
  private_connection_resource_id  = module.servicebus[0].namespace_id
  subresource_names               = var.sb_private_endpoint_subresource_names
  private_dns_zone_id             = local.enable_private_dns ? try(module.private_dns[0].id, null) : null
  private_dns_zone_group_name     = "servicebus"
  private_service_connection_name = "${var.sb_namespace_name}-psc"
  tags                            = var.tags
}

module "app_private_endpoint" {
  source = "./modules/private_endpoint"
  count  = local.enable_private_ep && local.enable_app_service ? 1 : 0

  name                            = "${var.app_name}-pe"
  location                        = var.location
  resource_group_name             = local.effective_rg_name
  subnet_id                       = var.private_endpoint_subnet_id
  private_connection_resource_id  = module.app_service[0].id
  subresource_names               = var.app_private_endpoint_subresource_names
  private_dns_zone_id             = local.enable_private_dns ? try(module.private_dns[0].id, null) : null
  private_dns_zone_group_name     = "appservice"
  private_service_connection_name = "${var.app_name}-psc"
  tags                            = var.tags
}

module "storage_private_endpoint" {
  source = "./modules/private_endpoint"
  count  = local.enable_private_ep && local.enable_storage ? 1 : 0

  name                            = "${var.sa_name}-pe"
  location                        = var.location
  resource_group_name             = local.effective_rg_name
  subnet_id                       = var.private_endpoint_subnet_id
  private_connection_resource_id  = module.storage[0].id
  subresource_names               = var.storage_private_endpoint_subresource_names
  private_dns_zone_id             = local.enable_private_dns ? try(module.private_dns[0].id, null) : null
  private_dns_zone_group_name     = "storage"
  private_service_connection_name = "${var.sa_name}-psc"
  tags                            = var.tags
}

############################
# Additional Platform Services
############################

module "recovery_vault" {
  source = "./modules/recovery_vault"
  count  = local.enable_recovery_vault ? 1 : 0

  name                = var.rsv_name
  location            = var.location
  resource_group_name = local.effective_rg_name
  sku                 = var.rsv_sku
  tags                = var.tags
}

module "postgres" {
  source = "./modules/postgresql_single"
  count  = local.enable_postgres ? 1 : 0

  name                         = var.postgres_server_name
  location                     = var.location
  resource_group_name          = local.effective_rg_name
  administrator_login          = var.postgres_administrator_login
  administrator_login_password = var.postgres_administrator_password
  sku_name                     = var.postgres_sku_name
  server_version               = var.postgres_version
  storage_mb                   = var.postgres_storage_mb
  tags                         = var.tags
}

module "network_security_group" {
  source = "./modules/network_security_group"
  count  = local.enable_nsg ? 1 : 0

  name                = var.nsg_name
  location            = var.location
  resource_group_name = local.effective_rg_name
  security_rules      = var.nsg_security_rules
  tags                = var.tags
}

module "load_balancer" {
  source = "./modules/load_balancer"
  count  = local.enable_load_balancer ? 1 : 0

  name                           = var.lb_name
  location                       = var.location
  resource_group_name            = local.effective_rg_name
  frontend_ip_configuration_name = var.lb_frontend_ip_configuration_name
  backend_pool_name              = var.lb_backend_pool_name
  is_public                      = var.lb_is_public
  subnet_id                      = var.lb_is_public ? null : var.private_link_service_subnet_id
  private_ip_address             = var.lb_private_ip_address
  tags                           = var.tags
}

module "private_link_service" {
  source = "./modules/private_link_service"
  count  = local.enable_pls && local.enable_load_balancer ? 1 : 0

  name                                        = var.private_link_service_name
  location                                    = var.location
  resource_group_name                         = local.effective_rg_name
  load_balancer_frontend_ip_configuration_ids = local.enable_load_balancer ? try(module.load_balancer[0].frontend_ip_configuration_ids, []) : []
  nat_subnet_id                               = var.private_link_service_subnet_id
  nat_ip_configuration_name                   = var.private_link_service_lb_frontend_ip_configuration_name
  auto_approval_subscription_ids              = []
  visibility_subscription_ids                 = []
  tags                                        = var.tags
}

module "api_management" {
  source = "./modules/api_management"
  count  = local.enable_apim ? 1 : 0

  name                = var.apim_name
  location            = var.location
  resource_group_name = local.effective_rg_name
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = var.apim_sku_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags
}

module "frontdoor" {
  source = "./modules/frontdoor"
  count  = local.enable_frontdoor ? 1 : 0

  profile_name                        = var.frontdoor_name
  sku_name                            = var.frontdoor_sku_name
  resource_group_name                 = local.effective_rg_name
  endpoint_name                       = var.frontdoor_endpoint_name
  origin_host_name                    = var.frontdoor_origin_host_name
  origin_host_header                  = var.frontdoor_origin_host_header
  origin_private_link_target_id       = var.frontdoor_origin_private_link_target
  origin_private_link_location        = var.frontdoor_origin_private_link_location
  origin_private_link_request_message = var.frontdoor_origin_private_link_request_message
  tags                                = var.tags
}
############################
# Outputs
############################
output "resource_group_name" {
  value = local.enable_rg ? module.resource_group[0].name : var.rg_name
}
output "acr_login_server" {
  value = local.enable_acr ? module.acr[0].login_server : null
}
output "kv_uri" {
  value = local.enable_kv ? module.key_vault[0].vault_uri : null
}
output "log_analytics_id" {
  value = local.enable_law ? module.log_analytics[0].id : null
}
output "vm_id" {
  value = local.enable_vm ? module.vm[0].vm_id : null
}
output "servicebus_namespace_id" {
  value = local.enable_servicebus ? module.servicebus[0].namespace_id : null
}
output "app_service_hostname" {
  value = local.enable_app_service ? module.app_service[0].default_hostname : null
}
output "storage_account_id" {
  value = local.enable_storage ? module.storage[0].id : null
}






