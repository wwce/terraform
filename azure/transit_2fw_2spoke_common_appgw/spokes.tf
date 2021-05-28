#-----------------------------------------------------------------------------------------------------------------
# Create spoke1 resource group, spoke1 VNET, VNET peering, UDR, internal LB, (2) VMs 

resource "azurerm_resource_group" "spoke1_rg" {
  name     = "${var.global_prefix}${var.spoke1_prefix}-rg"
  location = var.location
}

module "spoke1_vnet" {
  source              = "./modules/vnet/"
  name                = "${var.spoke1_prefix}-vnet"
  resource_group_name = azurerm_resource_group.spoke1_rg.name
  location            = var.location
  vnet_cidr           = var.spoke1_vnet_cidr
  subnet_cidrs        = var.spoke1_subnet_cidrs
  route_table_ids     = [azurerm_route_table.transit.id]

}


resource "azurerm_virtual_network_peering" "spoke1_to_transit" {
  name                         = "${var.spoke1_prefix}-vnet-${var.transit_prefix}-vnet"
  resource_group_name          = azurerm_resource_group.spoke1_rg.name
  virtual_network_name         = module.spoke1_vnet.vnet_name
  remote_virtual_network_id    = module.transit_vnet.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true 
}

resource "azurerm_virtual_network_peering" "transit_to_spoke1" {
  name                           = "${var.transit_prefix}-vnet-${var.spoke1_prefix}-vnet"
  resource_group_name            = azurerm_resource_group.transit_rg.name
  virtual_network_name           = module.transit_vnet.vnet_name
  remote_virtual_network_id      = module.spoke1_vnet.vnet_id
    allow_virtual_network_access = true
  allow_forwarded_traffic        = true 
}


resource "azurerm_route" "spoke1_udr" {
  name                   = "${var.spoke1_prefix}-udr"
  resource_group_name    = azurerm_resource_group.transit_rg.name
  route_table_name       = azurerm_route_table.transit.name
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.2.100"
  address_prefix         = var.spoke1_vnet_cidr

}

data "template_file" "web_startup" {
  template = file("${path.module}/scripts/web_startup.yml.tpl")
}

module "spoke1_vm" {
  source              = "./modules/spoke_vm/"
  name                = "${var.spoke1_prefix}-vm"
  resource_group_name = azurerm_resource_group.spoke1_rg.name
  location            = var.location
  vm_count            = var.spoke1_vm_count
  subnet_id           = module.spoke1_vnet.subnet_ids[0]
  availability_set_id = ""
  backend_pool_id    =  [module.spoke1_lb.backend_pool_id]
  custom_data         = base64encode(data.template_file.web_startup.rendered)
  publisher           = "Canonical"
  offer               = "UbuntuServer"
  sku                 = "16.04-LTS"
  username            = var.spoke_username
  password            = var.spoke_password
  tags                = var.tags

}

module "spoke1_lb" {
  source              = "./modules/lb/"
  name                = "${var.spoke1_prefix}-lb"
  resource_group_name = azurerm_resource_group.spoke1_rg.name
  location            = var.location
  type                = "private"
  sku                 = "Standard"
  probe_ports         = [80]
  frontend_ports      = [80]
  backend_ports       = [80]
  protocol            = "Tcp"
  enable_floating_ip  = false
  subnet_id           = module.spoke1_vnet.subnet_ids[0]
  private_ip_address  = var.spoke1_internal_lb_ip
  network_interface_ids = module.spoke1_vm.nic0_id

  # depends_on = [
  #   module.spoke1_vm
  # ]
}

#-----------------------------------------------------------------------------------------------------------------
# Create spoke2 resource group, VNET, VNET peering, UDR, (1) VM

resource "azurerm_resource_group" "spoke2_rg" {
  name     = "${var.global_prefix}${var.spoke2_prefix}-rg"
  location = var.location
}


module "spoke2_vnet" {
  source              = "./modules/vnet/"
  name                = "${var.spoke2_prefix}-vnet"
  resource_group_name = azurerm_resource_group.spoke2_rg.name
  location            = var.location
  vnet_cidr           = var.spoke2_vnet_cidr
  subnet_cidrs        = var.spoke2_subnet_cidrs
  route_table_ids     = [azurerm_route_table.transit.id]

}

resource "azurerm_virtual_network_peering" "spoke2_to_transit" {
  name                           = "${var.spoke2_prefix}-vnet-${var.transit_prefix}-vnet"
  resource_group_name            = azurerm_resource_group.spoke2_rg.name
  virtual_network_name           = module.spoke2_vnet.vnet_name
  remote_virtual_network_id      = module.transit_vnet.vnet_id
    allow_virtual_network_access = true
  allow_forwarded_traffic        = true 
}

resource "azurerm_virtual_network_peering" "transit_to_spoke2" {
  name                           = "${var.transit_prefix}-vnet-${var.spoke2_prefix}-vnet"
  resource_group_name            = azurerm_resource_group.transit_rg.name
  virtual_network_name           = module.transit_vnet.vnet_name
  remote_virtual_network_id      = module.spoke2_vnet.vnet_id
    allow_virtual_network_access = true
  allow_forwarded_traffic        = true 
}

resource "azurerm_route" "spoke2_udr" {
  name                   = "${var.spoke2_prefix}-udr"
  resource_group_name    = azurerm_resource_group.transit_rg.name
  route_table_name       = azurerm_route_table.transit.name
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.2.100"
  address_prefix         = var.spoke2_vnet_cidr
}

module "spoke2_vm" {
  source              = "./modules/spoke_vm/"
  name                = "${var.spoke2_prefix}-vm"
  resource_group_name = azurerm_resource_group.spoke2_rg.name
  location            = var.location
  vm_count            = var.spoke2_vm_count
  subnet_id           = module.spoke2_vnet.subnet_ids[0]
  availability_set_id = ""
  publisher           = "Canonical"
  offer               = "UbuntuServer"
  sku                 = "16.04-LTS"
  username            = var.spoke_username
  password            = var.spoke_password
  tags                = var.tags
}
