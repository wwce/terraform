resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

#-----------------------------------------------------------------------------------------------------------------
# Create VNET
module "vnet" {
  source              = "./modules/vnet/"
  location            = var.location
  resource_group_name = var.resource_group_name
  vnet_name           = var.vnet_name
  address_space       = var.vnet_cidr
  subnet_names        = var.subnet_names
  subnet_prefixes     = var.subnet_cidrs
}

#-----------------------------------------------------------------------------------------------------------------
# Create VM-Series NGFW.  For every fw_name entered, an additional VM-Series instance will be deployed.
module "vmseries" {
  source                       = "./modules/vmseries/"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.main.name
  fw_names                     = var.fw_names
  fw_username                  = var.fw_username
  fw_password                  = var.fw_password
  fw_panos                     = var.fw_panos
  fw_license                   = var.fw_license
  fw_nsg_prefix                = var.fw_nsg_prefix
  fw_avset_name                = var.fw_avset_name
  fw_subnet_mgmt               = module.vnet.vnet_subnets[0]
  fw_subnet_untrust            = module.vnet.vnet_subnets[1]
  fw_subnet_trust              = module.vnet.vnet_subnets[2]
  fw_bootstrap_storage_account = var.fw_bootstrap_storage_account
  fw_bootstrap_access_key      = var.fw_bootstrap_access_key
  fw_bootstrap_file_share      = var.fw_bootstrap_file_share
  fw_bootstrap_share_directory = var.fw_bootstrap_share_directory
  prefix                       = var.prefix
}

#-----------------------------------------------------------------------------------------------------------------
# Create public load balancer.  Load balancer uses firewall's untrust interfaces as its backend pool.
module "public_lb" {
  source                  = "./modules/lb/"
  location                = var.location
  resource_group_name     = azurerm_resource_group.main.name
  type                    = "public"
  name                    = var.public_lb_name
  probe_ports             = [22]
  frontend_ports          = [80, 22, 443]
  backend_ports           = [80, 22, 443]
  protocol                = "Tcp"
  backend_pool_count      = length(var.fw_names)
  backend_pool_interfaces = module.vmseries.nic1_id
}

#-----------------------------------------------------------------------------------------------------------------
# Create internal load balancer. Load balancer uses firewall's trust interfaces as its backend pool
module "internal_lb" {
  source              = "./modules/lb/"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  type                = "private"
  name                = var.internal_lb_name

  probe_ports             = [22]
  frontend_ports          = [0]
  backend_ports           = [0]
  protocol                = "All"
  backend_pool_count      = length(var.fw_names)
  backend_pool_interfaces = module.vmseries.nic2_id
  subnet_id               = module.vnet.vnet_subnets[2]
  private_ip_address      = var.internal_lb_address
}


