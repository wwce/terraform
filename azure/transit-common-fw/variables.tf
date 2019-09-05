#-----------------------------------------------------------------------------------------------------------------
# Azure environment variables
variable location {
  description = "Enter a location"
  default     = "eastus"
}

variable resource_group_name {
  default = "transit-rg"
}

#-----------------------------------------------------------------------------------------------------------------
# Azure VNET variables for VM-Series
variable vnet_name {
  default     = "vmseries-vnet"
}

variable vnet_cidr {
  default     = "10.0.0.0/16"
}

variable subnet_names {
  type        = "list"
  default     = ["mgmt", "untrust", "trust"]
}

variable subnet_cidrs {
  type        = "list"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

#-----------------------------------------------------------------------------------------------------------------
# VM-Series variables
variable "fw_names" {
  type        = "list"
  description = "Enter names for the firewalls. For every name entered, an additional instance is created"
  default     = ["vmseries-fw1", "vmseries-fw2"]
}
variable "fw_nsg_prefix" {
  description = "This address prefix will be able to access the firewall's mgmt interface over TCP/443 and TCP/22"
  default     = "0.0.0.0/0"
}

variable "fw_avset_name" {
  default = "vmseries-avset"
}

variable "fw_panos" {
  default = "latest"
}

variable "fw_license" {
 # default = "byol" 
 # default = "bundle1"
 # default = "bundle2"
}

variable "fw_username" {
  default = "paloalto"
}

variable "fw_password" {
  default = "PanPassword123!"
}

variable "fw_bootstrap_storage_account" {
  description = "Azure storage account to bootstrap firewalls"
//  default     = "my-bootstrap-storage-account"
}

variable "fw_bootstrap_access_key" {
  description = "Access key of the bootstrap storage account"
//  default     = "OgJsX1/dbZyN1928347981234hlisefjkhslkjhdfadNPj111wWrZzU3QVtJK4ybDqew=="
}

variable "fw_bootstrap_file_share" {
  description = "Storage account's file share name that contains the bootstrap directories"
//  default     = "my-bootstrap-file-share"
}

variable "fw_bootstrap_share_directory" {
  description = "Storage account's share directory name (useful if deploying multiple firewalls)"
  default     = "None"
}

variable "prefix" {
  description = "Prefix to prepend to newly created resources"
  default     = ""
}

#-----------------------------------------------------------------------------------------------------------------
# Azure load balancer variables
variable "public_lb_name" {
  default = "public-lb"
}

variable "public_lb_allowed_ports" {
  type    = "list"
  default = ["80", "443", "22"]
}

variable "internal_lb_name" {
  default = "internal-lb"
}

variable "internal_lb_address" {
  default = "10.0.2.100"
}
