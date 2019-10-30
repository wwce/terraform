#-----------------------------------------------------------------------------------------------------------------
# Create Spoke1 with VNET peer
module "spoke1" {
  source                      = "./modules/spoke_vnet/"
  location                    = var.location
  resource_group_name         = var.spoke1_rg
  vnet_name                   = var.spoke1_vnet_name
  address_space               = var.spoke1_vnet_cidr
  subnet_prefixes             = var.spoke1_subnet_cidrs
  transit_vnet_name           = module.vnet.vnet_name
  transit_vnet_resource_group = azurerm_resource_group.main.name
  route_table_destinations    = var.spoke_udrs
  route_table_next_hop        = [var.internal_lb_address]
}

module "spoke1_vm" {
  source              = "./modules/spoke_vm/"
  vm_names            = var.spoke1_vms
  location            = var.location
  resource_group_name = module.spoke1.resource_group_name
  subnet_id           = module.spoke1.vnet_subnets[0]
  username            = var.spoke_user
  password            = var.spoke_password
  tags                = var.tags
}

#-----------------------------------------------------------------------------------------------------------------
# Create Spoke2 with VNET peer
module "spoke2" {
  source                      = "./modules/spoke_vnet/"
  location                    = var.location
  resource_group_name         = var.spoke2_rg
  vnet_name                   = var.spoke2_vnet_name
  address_space               = var.spoke2_vnet_cidr
  subnet_prefixes             = var.spoke2_subnet_cidrs
  transit_vnet_name           = module.vnet.vnet_name
  transit_vnet_resource_group = azurerm_resource_group.main.name
  route_table_destinations    = var.spoke_udrs
  route_table_next_hop        = [var.internal_lb_address]
}

module "spoke2_vm" {
  source              = "./modules/spoke_vm/"
  vm_names            = var.spoke2_vms
  location            = var.location
  resource_group_name = module.spoke2.resource_group_name
  subnet_id           = module.spoke2.vnet_subnets[0]
  username            = var.spoke_user
  password            = var.spoke_password
  tags                = var.tags
}
