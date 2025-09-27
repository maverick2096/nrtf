#########################
# Global
#########################
variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}

#########################
# Build toggles (booleans)
#########################
variable "build_resource_group" {
  type    = bool
  default = true
}

variable "build_acr" {
  type    = bool
  default = true
}

variable "build_key_vault" {
  type    = bool
  default = true
}

variable "build_log_analytics" {
  type    = bool
  default = true
}

variable "build_vm" {
  type    = bool
  default = false
}

variable "build_servicebus" {
  type    = bool
  default = true
}

variable "build_app_service" {
  type    = bool
  default = true
}

variable "build_storage" {
  type    = bool
  default = true
}

variable "enable_private_endpoints" {
  description = "Enable creation of private endpoints for provisioned services"
  type        = bool
  default     = true
}

variable "build_private_dns_zone" {
  type    = bool
  default = true
}

variable "build_private_link_service" {
  type    = bool
  default = false
}

variable "build_recovery_vault" {
  type    = bool
  default = false
}

variable "build_postgres" {
  type    = bool
  default = false
}

variable "build_nsg" {
  type    = bool
  default = false
}

variable "build_load_balancer" {
  type    = bool
  default = false
}

variable "build_api_management" {
  type    = bool
  default = false
}

variable "build_frontdoor" {
  type    = bool
  default = false
}

locals {
  enable_rg             = var.build_resource_group
  enable_acr            = var.build_acr
  enable_kv             = var.build_key_vault
  enable_law            = var.build_log_analytics
  enable_vm             = var.build_vm
  enable_servicebus     = var.build_servicebus
  enable_app_service    = var.build_app_service
  enable_storage        = var.build_storage
  enable_private_ep     = var.enable_private_endpoints
  enable_private_dns    = var.build_private_dns_zone
  enable_pls            = var.build_private_link_service
  enable_recovery_vault = var.build_recovery_vault
  enable_postgres       = var.build_postgres
  enable_nsg            = var.build_nsg
  enable_load_balancer  = var.build_load_balancer
  enable_apim           = var.build_api_management
  enable_frontdoor      = var.build_frontdoor
}

#########################
# Networking inputs
#########################
variable "virtual_network_id" {
  description = "Existing virtual network to associate private DNS links with"
  type        = string
  default     = null
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID where private endpoints will be created"
  type        = string
  default     = null
}

variable "private_link_service_subnet_id" {
  description = "Subnet ID used by the private link service (if enabled)"
  type        = string
  default     = null
}

variable "private_dns_zone_name" {
  description = "Name of the general purpose private DNS zone"
  type        = string
  default     = null
}

variable "private_dns_zone_vnet_ids" {
  description = "List of virtual network IDs to link to the private DNS zone"
  type        = list(string)
  default     = []
}

#########################
# Resource-specific inputs (defaults prevent prompts)
#########################

# Resource Group
variable "rg_name" {
  type    = string
  default = null
  validation {
    condition     = (var.build_resource_group == false) || (var.rg_name != null && length(var.rg_name) > 0)
    error_message = "rg_name is required when build_resource_group = true."
  }
}

# ACR
variable "acr_name" {
  type    = string
  default = null
  validation {
    condition     = (var.build_acr == false) || (var.acr_name != null && can(regex("^[a-z0-9]{5,50}$", var.acr_name)))
    error_message = "acr_name (lowercase alphanumeric, 5-50) is required when build_acr = true."
  }
}

variable "acr_sku" {
  type    = string
  default = "Premium"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "acr_sku must be Basic | Standard | Premium."
  }
}

variable "acr_admin_enabled" {
  type    = bool
  default = false
}

variable "acr_private_endpoint_subresource_names" {
  description = "Subresource names used for the ACR private endpoint"
  type        = list(string)
  default     = ["registry"]
}

# Key Vault (infra)
variable "kv_name" {
  type    = string
  default = null
  validation {
    condition = (!var.build_key_vault) || (
      var.kv_name != null &&
      length(var.kv_name) >= 3 &&
      length(var.kv_name) <= 24 &&
      regex("^[a-z0-9](?:[-a-z0-9]*[a-z0-9])?$", var.kv_name) != null
    )
    error_message = "kv_name must be 3-24 characters, lowercase alphanumeric with optional single dashes (no leading/trailing dash)."
  }
}

variable "kv_sku" {
  type    = string
  default = "standard"
  validation {
    condition     = contains(["standard", "premium"], lower(var.kv_sku))
    error_message = "kv_sku must be 'standard' or 'premium'."
  }
}

variable "kv_purge_protection" {
  type    = bool
  default = true
}

variable "kv_soft_delete_retention_days" {
  type    = number
  default = 7
}

variable "kv_private_endpoint_subresource_names" {
  description = "Subresource names used for the Key Vault private endpoint"
  type        = list(string)
  default     = ["vault"]
}

# Log Analytics
variable "log_analytics_name" {
  type    = string
  default = null
  validation {
    condition     = (var.build_log_analytics == false) || (var.log_analytics_name != null && length(var.log_analytics_name) > 0)
    error_message = "log_analytics_name is required when build_log_analytics = true."
  }
}

variable "log_analytics_sku" {
  type    = string
  default = "PerGB2018"
}

variable "log_analytics_retention_days" {
  type    = number
  default = 30
}

variable "log_analytics_private_endpoint_subresource_names" {
  description = "Subresource names for the Log Analytics private endpoint"
  type        = list(string)
  default     = ["workspace"]
}

# VM (Linux)
variable "vm_name" {
  type    = string
  default = null
}

variable "vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "vm_admin_user" {
  type    = string
  default = "azureuser"
}

variable "vm_ssh_public_key" {
  type    = string
  default = null
}

variable "vm_os_disk_size_gb" {
  type    = number
  default = 64
}

variable "vm_subnet_id" {
  type    = string
  default = null
}

variable "vm_image" {
  description = "Image reference"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

variable "vm_requirements_ok" {
  description = "Internal validation guard for VM inputs"
  type        = bool
  default     = true
  validation {
    condition = (!var.vm_requirements_ok) || (
      var.build_vm == false ||
      (var.vm_name != null && var.vm_subnet_id != null && var.vm_ssh_public_key != null)
    )
    error_message = "When build_vm = true, set vm_name, vm_subnet_id and vm_ssh_public_key."
  }
}

# Service Bus
variable "sb_namespace_name" {
  type    = string
  default = null
}

variable "sb_sku" {
  type    = string
  default = "Standard"
}

variable "sb_queues" {
  type    = list(string)
  default = []
}

variable "sb_requirements_ok" {
  type    = bool
  default = true
  validation {
    condition     = (!var.sb_requirements_ok) || (var.build_servicebus == false) || (var.sb_namespace_name != null)
    error_message = "sb_namespace_name is required when build_servicebus = true."
  }
}

variable "sb_private_endpoint_subresource_names" {
  description = "Subresource names for the Service Bus private endpoint"
  type        = list(string)
  default     = ["namespace"]
}

# App Service (Linux)
variable "app_service_plan_name" {
  type    = string
  default = null
}

variable "app_service_sku" {
  type    = string
  default = "P1v3"
}

variable "app_name" {
  type    = string
  default = null
}

variable "app_settings" {
  type    = map(string)
  default = {}
}

variable "app_requirements_ok" {
  type    = bool
  default = true
  validation {
    condition     = (!var.app_requirements_ok) || (var.build_app_service == false) || (var.app_service_plan_name != null && var.app_name != null)
    error_message = "app_service_plan_name and app_name are required when build_app_service = true."
  }
}

variable "app_private_endpoint_subresource_names" {
  description = "Subresource names for the App Service private endpoint"
  type        = list(string)
  default     = ["sites"]
}

# Storage Account
variable "sa_name" {
  type    = string
  default = null
  validation {
    condition     = (var.build_storage == false) || (var.sa_name != null && can(regex("^[a-z0-9]{3,24}$", var.sa_name)))
    error_message = "sa_name (3-24 lowercase alphanumeric) is required when build_storage = true."
  }
}

variable "sa_tier" {
  type    = string
  default = "Standard"
}

variable "sa_replication" {
  type    = string
  default = "GRS"
}

variable "storage_containers" {
  type    = list(string)
  default = []
}

variable "storage_private_endpoint_subresource_names" {
  description = "Subresource names for the Storage account private endpoint"
  type        = list(string)
  default     = ["blob"]
}

#########################
# Private DNS Zone
#########################
variable "private_dns_zone_link_name" {
  description = "Name for the private DNS zone virtual network link"
  type        = string
  default     = null
}

#########################
# Private Link Service
#########################
variable "private_link_service_name" {
  type    = string
  default = null
}

variable "private_link_service_lb_frontend_ip_configuration_name" {
  description = "Name of the load balancer frontend IP configuration associated with the private link service"
  type        = string
  default     = null
}

#########################
# Recovery Services Vault
#########################
variable "rsv_name" {
  type    = string
  default = null
}

variable "rsv_sku" {
  type    = string
  default = "Standard"
}

#########################
# PostgreSQL Single Server
#########################
variable "postgres_server_name" {
  type    = string
  default = null
}

variable "postgres_sku_name" {
  type    = string
  default = "GP_Gen5_4"
}

variable "postgres_version" {
  type    = string
  default = "11"
}

variable "postgres_administrator_login" {
  type    = string
  default = null
}

variable "postgres_administrator_password" {
  type    = string
  default = null
}

variable "postgres_storage_mb" {
  type    = number
  default = 51200
}

#########################
# Network Security Group
#########################
variable "nsg_name" {
  type    = string
  default = null
}

variable "nsg_security_rules" {
  description = "List of NSG security rules"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

#########################
# Load Balancer
#########################
variable "lb_name" {
  type    = string
  default = null
}

variable "lb_frontend_ip_configuration_name" {
  type    = string
  default = null
}

variable "lb_backend_pool_name" {
  type    = string
  default = null
}

variable "lb_is_public" {
  description = "Use a public load balancer if true, otherwise internal"
  type        = bool
  default     = false
}

variable "lb_private_ip_address" {
  type    = string
  default = null
}

#########################
# API Management
#########################
variable "apim_name" {
  type    = string
  default = null
}

variable "apim_publisher_email" {
  type    = string
  default = null
}

variable "apim_publisher_name" {
  type    = string
  default = null
}

variable "apim_sku_name" {
  type    = string
  default = "Premium" # Developer | Basic | Standard | Premium
}

#########################
# Front Door (Standard/Premium)
#########################
variable "frontdoor_name" {
  type    = string
  default = null
}

variable "frontdoor_sku_name" {
  type    = string
  default = "Premium_AzureFrontDoor"
}

variable "frontdoor_endpoint_name" {
  type    = string
  default = null
}

variable "frontdoor_origin_host_name" {
  description = "Origin host name (e.g. app service default hostname)"
  type        = string
  default     = null
}

variable "frontdoor_origin_host_header" {
  type    = string
  default = null
}

variable "frontdoor_origin_private_link_target" {
  description = "Resource ID for Front Door private link origin (if using private endpoints)"
  type        = string
  default     = null
}

variable "frontdoor_origin_private_link_location" {
  type    = string
  default = null
}

variable "frontdoor_origin_private_link_request_message" {
  type    = string
  default = "Requesting approval for Front Door private link"
}

#########################
# Validations for new features
#########################
variable "network_requirements_ok" {
  type    = bool
  default = true
  validation {
    condition = (!var.network_requirements_ok) || (
      (var.enable_private_endpoints == false) || (var.private_endpoint_subnet_id != null)
    )
    error_message = "private_endpoint_subnet_id must be provided when enable_private_endpoints = true."
  }
}

variable "private_dns_requirements_ok" {
  type    = bool
  default = true
  validation {
    condition = (!var.private_dns_requirements_ok) || (
      (var.build_private_dns_zone == false) || (var.private_dns_zone_name != null && length(var.private_dns_zone_name) > 0)
    )
    error_message = "private_dns_zone_name is required when build_private_dns_zone = true."
  }
}

variable "postgres_requirements_ok" {
  type    = bool
  default = true
  validation {
    condition = (!var.postgres_requirements_ok) || (
      (var.build_postgres == false) || (
        var.postgres_server_name != null &&
        var.postgres_administrator_login != null &&
        var.postgres_administrator_password != null
      )
    )
    error_message = "PostgreSQL server name, admin login, and password are required when build_postgres = true."
  }
}

variable "apim_requirements_ok" {
  type    = bool
  default = true
  validation {
    condition = (!var.apim_requirements_ok) || (
      (var.build_api_management == false) || (
        var.apim_name != null &&
        var.apim_publisher_email != null &&
        var.apim_publisher_name != null
      )
    )
    error_message = "API Management name, publisher email, and publisher name are required when build_api_management = true."
  }
}

variable "frontdoor_requirements_ok" {
  type    = bool
  default = true
  validation {
    condition = (!var.frontdoor_requirements_ok) || (
      (var.build_frontdoor == false) || (
        var.frontdoor_name != null &&
        var.frontdoor_endpoint_name != null &&
        var.frontdoor_origin_host_name != null
      )
    )
    error_message = "Front Door name, endpoint name, and origin host name are required when build_frontdoor = true."
  }
}

