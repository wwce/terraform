variable "name" {
}

variable "health_check_port" {
  default = "22"
}

variable "backends" {
  description = "Map backend indices to list of backend maps."
  type = map(list(object({
    group    = string
    failover = bool
  })))
}

variable "subnetworks" {
  type = list(string)
}

variable "ip_address" {
  default = ""
}

variable "ip_protocol" {
  default = "TCP"
}
variable "all_ports" {
  type = bool
}
variable "ports" {
  type    = list(string)
  default = []
}
