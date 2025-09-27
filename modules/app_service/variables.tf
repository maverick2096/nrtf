variable "plan_name" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "app_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "app_settings" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
