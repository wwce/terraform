variable "location" {
  description = "Location of the resource group to place App Gateway in."
}

variable "resource_group_name" {
  description = "Name of the resource group to place App Gateway in."
}

variable "subnet_appgw" {
  description = "AppGW Subnet"
}

variable "fw_private_ips" {
  description = "list of private IP addresses from the deployed FW"
  type = list(string)
  default = null
}