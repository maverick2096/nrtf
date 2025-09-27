variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "frontend_ip_configuration_name" {
  type = string
}

variable "backend_pool_name" {
  type = string
}

variable "is_public" {
  type    = bool
  default = false
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "private_ip_address" {
  type    = string
  default = null
}

variable "public_ip_name" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
