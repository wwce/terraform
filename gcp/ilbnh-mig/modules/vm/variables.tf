variable names {
  type = list(string)
}

variable machine_type {
}

variable zones {
  type = list(string)
}
variable ssh_key {
  default = ""
}
variable image {
}

variable subnetworks {
  type = list(string)
}

variable server_ips {
  type = list(string)
}

variable scopes {
  type = list(string)

  default = [
    "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
  ]
}

variable startup_script {
  default = ""
}

variable server_public_ip {
  type    = bool
  default = false
}

