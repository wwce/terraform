variable location {
}

variable resource_group_name {}
variable fw_subnet_mgmt {}
variable fw_subnet_untrust {}
variable fw_subnet_trust {}
variable "fw_avset_name" {}

variable "fw_panos" {}

variable "fw_license" {}

variable "fw_username" {}

variable "fw_password" {}

variable "prefix" {
  default = ""
}

variable "fw_nsg_prefix" {
  description = "Enter a valid address prefix.  This address prefix will be able to access the firewalls mgmt interface over TCP/443 and TCP/22"
  default     = "0.0.0.0/0"
}

variable "fw_names" {
  type = "list"
}

variable "fw_size" {
  default = "Standard_DS3_v2"
}

variable "sku" {
  default = "Standard"
}

variable "public_ip_address_allocation" {
  default = "Static"
}

variable "fw_bootstrap_storage_account" {
  default = ""
}

variable "fw_bootstrap_access_key" {
  default = ""
}

variable "fw_bootstrap_file_share" {
  default = ""
}

variable "fw_bootstrap_share_directory" {
  default = "None"
}


