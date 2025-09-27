variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "virtual_network_ids" {
  type    = list(string)
  default = []
}

variable "link_name" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
