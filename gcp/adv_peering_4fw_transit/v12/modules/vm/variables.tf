variable "names" {
  type = list(string)
}

variable "machine_type" {
}

variable "zones" {
  type = list(string)
}

variable "ssh_key" {
}

variable "image" {
}

variable "subnetworks" {
  type = list(string)
}

variable "scopes" {
  type = list(string)

  default = [
    "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
  ]
}

variable "internal_lb_create" {
  default = 0
}

variable "internal_lb_health_check" {
  default = "22"
}

variable "internal_lb_ports" {
  type    = list(string)
  default = ["80"]
}

variable "internal_lb_name" {
  default = "intlb"
}

variable "internal_lb_ip" {
  default = ""
}

variable "create_instance_group" {
  default = false
}

variable "startup_script" {
  default = ""
}

