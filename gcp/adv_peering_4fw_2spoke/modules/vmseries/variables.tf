variable "subnetworks" {
  type = list(string)
}

variable "names" {
  type = list(string)
}

variable "machine_type" {
}

variable "zones" {
  type = list(string)
}

variable "cpu_platform" {
  default = "Intel Broadwell"
}
variable "disk_type" {
  default = "pd-ssd"
  #default = "pd-standard"
}
variable "bootstrap_bucket" {
  default = ""
}

variable "ssh_key" {
  default = ""
}

variable "public_lb_create" {
  default = false
}

variable "scopes" {
  type = list(string)

  default = [
    "https://www.googleapis.com/auth/compute.readonly",
    "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
  ]
}

variable "image" {
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "create_instance_group" {
  type    = bool
  default = false
}

variable "instance_group_names" {
  type    = list(string)
  default = ["vmseries-instance-group"]
}

variable "dependencies" {
  type    = list(string)
  default = []
}

variable "nic0_ip" {
  type    = list(string)
  default = [""]
}

variable "nic1_ip" {
  type    = list(string)
  default = [""]
}

variable "nic2_ip" {
  type    = list(string)
  default = [""]
}

variable "mgmt_interface_swap" {
  default = ""
}

variable "nic0_public_ip" {
  type    = bool
  default = false
}

variable "nic1_public_ip" {
  type    = bool
  default = false
}

variable "nic2_public_ip" {
  type    = bool
  default = false
}
