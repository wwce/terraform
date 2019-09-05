variable location {}

variable resource_group_name {}

variable lb_name {}

variable lb_sku {
  default = "Standard"
}

variable lb_frontend_name {
  default = "LoadBalancerFrontEnd"
}

variable lb_backend_name {
  default = "LoadBalancerBackendPool"
}

variable lb_health_probe_name {
  default = "HealthProbe"
}

variable lb_health_probe_port {
  default = "22"
}

variable lb_rule_name {
  default = "HA-Ports"
}

variable lb_allowed_tcp_ports {
  type    = "list"
  default = ["80", "443"]
}

variable lb_backend_pool_interfaces {
  type = "list"
}

variable lb_backend_pool_count {
  default = "0"
}
