#-----------------------------------------------------------------------------------------------------------------
# Azure environment variables
variable location {
  description = "Enter a location"
  default     = "eastus"
}

variable resource_group_name {
  default = "scaled-vmseries-rg"
}

#-----------------------------------------------------------------------------------------------------------------
# Azure VNET variables for VM-Series
variable vnet_name {
  default = "vmseries-vnet"
}

variable vnet_rg {
  default = "transit-rg"
}

variable mgmt_subnet {
  default = "mgmt"
}

variable untrust_subnet {
  default = "untrust"
}

variable trust_subnet {
  default = "trust"
}

#-----------------------------------------------------------------------------------------------------------------
# VM-Series variables
variable fw_names {
  type        = list(string)
  description = "Enter names for the firewalls. For every name entered, an additional instance is created"
}

variable fw_nsg_prefix {
  description = "This address prefix will be able to access the firewall's mgmt interface over TCP/443 and TCP/22"
}

variable fw_avset_name {
}

variable fw_panos {
}

variable fw_license {
  # default = "byol"   
  # default = "bundle1"  
  # default = "bundle2"
}

variable fw_username {
}

variable fw_password {
}

variable fw_bootstrap_storage_account {
  description = "Azure storage account to bootstrap firewalls"
}

variable fw_bootstrap_access_key {
  description = "Access key of the bootstrap storage account"
}

variable fw_bootstrap_file_share {
  description = "Storage account's file share name that contains the bootstrap directories"
}

variable fw_bootstrap_share_directory {
  description = "Storage account's share directory name (useful if deploying multiple firewalls)"
}

variable prefix {
  description = "Prefix to prepend to newly created resources"
}

#-----------------------------------------------------------------------------------------------------------------
# Azure load balancer variables
variable public_lb_name {
  description = "Existing public load balancer"
}

variable public_lb_pool {
  description = "Name of the existing public load balancer's backend pool"
}

variable internal_lb_name {
  description = "Existing internal load balancer"
}

variable internal_lb_pool {
  description = "Name of the existing internal load balancer's backend pool"
}

