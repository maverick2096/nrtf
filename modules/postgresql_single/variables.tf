variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "administrator_login" {
  type = string
}

variable "administrator_login_password" {
  type      = string
  sensitive = true
}

variable "sku_name" {
  type = string
}

variable "server_version" {
  type = string
}

variable "storage_mb" {
  type = number
}

variable "backup_retention_days" {
  type    = number
  default = 7
}

variable "tags" {
  type    = map(string)
  default = {}
}
