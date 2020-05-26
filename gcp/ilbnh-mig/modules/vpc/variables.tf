variable vpc {
}

variable subnet {
}

variable cidr {
}

variable region {
}

variable allowed_sources {
  type    = list(string)
  default = []
}

variable allowed_protocol {
  default = "all"
}

variable allowed_ports {
  type    = list(string)
  default = []
}

variable delete_default_route {
  default = "false"
}