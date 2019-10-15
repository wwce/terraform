variable "vpc" {
}

variable "subnets" {
  type = list(string)
}

variable "cidrs" {
  type = list(string)
}

variable "regions" {
  type = list(string)
}

variable "allowed_sources" {
  type    = list(string)
  default = []
}

variable "allowed_protocol" {
  default = "all"
}

variable "allowed_ports" {
  type    = list(string)
  default = []
}

variable "delete_default_route" {
  default = "false"
}

