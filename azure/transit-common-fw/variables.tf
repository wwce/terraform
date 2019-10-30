#-----------------------------------------------------------------------------------------------------------------
# Azure environment variables
variable location {
  description = "Enter a location"
}

variable resource_group_name {
}

#-----------------------------------------------------------------------------------------------------------------
# Azure VNET variables for VM-Series
variable vnet_name {
}

variable vnet_cidr {
}

variable subnet_names {
  type = list(string)
}

variable subnet_cidrs {
  type = list(string)
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
}

variable internal_lb_name {
}

variable internal_lb_address {
}


variable tags {
  description = "The tags to associate with newly created resources"
  type        = map(string)

  default = {
    # tag1 = ""
    # tag2 = ""
    # trusted-resource = "yes"
    # allow-internet   = "yes"
  }
}

variable spoke1_rg {}
variable spoke1_vnet_name {}
variable spoke1_vnet_cidr {}
variable spoke1_subnet_cidrs {
  type = list(string)
}
variable spoke1_vms {
  type = list(string)
}

variable spoke2_rg {}
variable spoke2_vnet_name {}
variable spoke2_vnet_cidr {}
variable spoke2_subnet_cidrs {
  type = list(string)
}
variable spoke2_vms {
  type = list(string)
}

variable spoke_udrs {}
variable spoke_user {}
variable spoke_password {}
