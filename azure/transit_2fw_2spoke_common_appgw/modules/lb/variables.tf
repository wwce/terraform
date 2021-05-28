variable location {
}

variable resource_group_name {
}

variable name {
}

variable private_ip_address {
  default = ""
}

variable sku {
  default = "Standard"
}

variable enable_floating_ip {
  default = true
}

variable subnet_id {
  default = ""
}

variable frontend_name {
  default = "LoadBalancerFrontEnd"
}

variable backend_name {
  default = "LoadBalancerBackendPool"
}

variable frontend_ports {
  type    = list(string)
  default = [0]
}

variable backend_ports {
  type    = list(string)
  default = [0]
}

variable protocol {
  default = "All"
}

variable probe_name {
  default = "HealthProbe"
}

variable probe_ports {
  type    = list(string)
  default = [22]
}

variable type {
  default = ""
}

variable rule_name {
  default = "HA-Ports"
}

variable network_interface_ids {
  type = list(string)
}

variable ip_configuration_name {
  type = list(string)
  default = ["ipconfig1"]
}