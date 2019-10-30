variable lb_name {
}

variable lb_backend_pool_name {
  default = "LoadBalancerBackendPool"
}

variable lb_backend_pool_count {
  default = 1
}

variable lb_backend_pool_interfaces {
  type = list(string)
}

variable resource_group_name {
}

variable location {
}

