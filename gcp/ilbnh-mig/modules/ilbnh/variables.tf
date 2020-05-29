variable project_id {
}

variable region {
}

variable name {
}

variable health_checks {
  type    = list(string)
  default = []
}

variable group {
}

variable subnetwork {
}

variable ip_address {
  default = null
}

variable ip_protocol {
  default = "TCP"
}
variable all_ports {
  type = bool
}
variable ports {
  type    = list(string)
  default = []
}

variable network {
  default = null
}

variable network_uri {
}