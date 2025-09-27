variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tenant_id" {
  type    = string
  default = null
}

variable "sku_name" {
  type = string
}

variable "purge_protection" {
  type = bool
}

variable "soft_delete_retention_days" {
  type = number
}

variable "tags" {
  type    = map(string)
  default = {}
}
