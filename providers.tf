terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "8c99e5f0-49ec-4579-97f5-4d4b499a6901"

}

# Optional backend:
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "tfstate-rg"
#     storage_account_name = "tfstateacct001"
#     container_name       = "tfstate"
#     key                  = "core-explicit/dev.tfstate"
#   }
# }
