provider "azurerm" {
  version = "=1.28.0"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

#-----------------------------------------------------------------------------------------------------------------
# Create VNET
module "vnet" {
  source              = "Azure/network/azurerm"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  vnet_name           = "${var.vnet_name}"
  address_space       = "${var.vnet_cidr}"
  subnet_names        = ["${var.subnet_names}"]
  subnet_prefixes     = ["${var.subnet_cidrs}"]
}

#-----------------------------------------------------------------------------------------------------------------
# Create VM-Series NGFW.  For every fw_name entered, an additional VM-Series instance will be deployed.
module "vmseries" {
  source                       = "./modules/vmseries/"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  fw_names                     = ["${var.fw_names}"]
  fw_username                  = "${var.fw_username}"
  fw_password                  = "${var.fw_password}"
  fw_panos                     = "${var.fw_panos}"
  fw_license                   = "${var.fw_license}"
  fw_nsg_prefix                = "${var.fw_nsg_prefix}"
  fw_avset_name                = "${var.fw_avset_name}"
  fw_subnet_mgmt               = "${module.vnet.vnet_subnets[0]}"
  fw_subnet_untrust            = "${module.vnet.vnet_subnets[1]}"
  fw_subnet_trust              = "${module.vnet.vnet_subnets[2]}"
  fw_bootstrap_storage_account = "${var.fw_bootstrap_storage_account}"
  fw_bootstrap_access_key      = "${var.fw_bootstrap_access_key}"
  fw_bootstrap_file_share      = "${var.fw_bootstrap_file_share}"
  fw_bootstrap_share_directory = "${var.fw_bootstrap_share_directory}"
  prefix                       = "${var.prefix}"
}

#-----------------------------------------------------------------------------------------------------------------
# Create public load balancer.  Load balancer uses firewall's untrust interfaces as its backend pool.
module "public_lb" {
  source                     = "./modules/public_lb/"
  location                   = "${var.location}"
  resource_group_name        = "${azurerm_resource_group.rg.name}"
  lb_name                    = "${var.public_lb_name}"
  lb_health_probe_port       = "22"
  lb_backend_pool_count      = "${length(var.fw_names)}"
  lb_backend_pool_interfaces = "${module.vmseries.nic1_id}"
  lb_allowed_tcp_ports       = ["${var.public_lb_allowed_ports}"]
}

#-----------------------------------------------------------------------------------------------------------------
# Create internal load balancer. Load balancer uses firewall's trust interfaces as its backend pool
module "internal_lb" {
  source                     = "./modules/internal_lb/"
  location                   = "${var.location}"
  resource_group_name        = "${azurerm_resource_group.rg.name}"
  lb_name                    = "${var.internal_lb_name}"
  lb_health_probe_port       = "22"
  lb_backend_pool_count      = "${length(var.fw_names)}"
  lb_backend_pool_interfaces = "${module.vmseries.nic2_id}"
  lb_subnet                  = "${module.vnet.vnet_subnets[2]}"
  lb_address                 = "${var.internal_lb_address}"
}

#-----------------------------------------------------------------------------------------------------------------
# Create 2 spoke VNETs & peer them to the transit VNET. A route table added to route traffic to ILB of VM-Series.
module "spoke1" {
  source                      = "./modules/spoke_vnet/"
  location                    = "${var.location}"
  resource_group_name         = "spoke1-rg"
  vnet_name                   = "spoke1-vnet"
  address_space               = "10.1.0.0/16"
  subnet_names                = ["subnet1", "subnet2"]
  subnet_prefixes             = ["10.1.0.0/24", "10.1.1.0/24"]
  transit_vnet_name           = "${module.vnet.vnet_name}"
  transit_vnet_resource_group = "${azurerm_resource_group.rg.name}"
  route_table_destinations    = ["0.0.0.0/0", "10.2.0.0/16"]
  route_table_next_hop        = ["${var.internal_lb_address}"]
}

module "spoke2" {
  source                      = "./modules/spoke_vnet/"
  location                    = "${var.location}"
  resource_group_name         = "spoke2-rg"
  vnet_name                   = "spoke2-vnet"
  address_space               = "10.2.0.0/16"
  subnet_names                = ["subnet1", "subnet2"]
  subnet_prefixes             = ["10.2.0.0/24", "10.2.1.0/24"]
  transit_vnet_name           = "${module.vnet.vnet_name}"
  transit_vnet_resource_group = "${azurerm_resource_group.rg.name}"
  route_table_destinations    = ["0.0.0.0/0", "10.1.0.0/16"]
  route_table_next_hop        = ["${var.internal_lb_address}"]
}
