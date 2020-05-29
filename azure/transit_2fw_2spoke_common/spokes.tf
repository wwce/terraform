#-----------------------------------------------------------------------------------------------------------------
# Create spoke1 resource group, spoke1 VNET, spoke1 internal LB, (2) spoke1 VMs 

resource "azurerm_resource_group" "spoke1_rg" {
  name     = "${var.global_prefix}${var.spoke1_prefix}-rg"
  location = var.location
}

module "spoke1_vnet" {
  source                      = "./modules/spoke_vnet/"
  name                        = "${var.spoke1_prefix}-vnet"
  address_space               = var.spoke1_vnet_cidr
  subnet_prefixes             = var.spoke1_subnet_cidrs
  remote_vnet_rg              = azurerm_resource_group.transit.name
  remote_vnet_name            = module.vnet.vnet_name
  remote_vnet_id              = module.vnet.vnet_id
  route_table_destinations    = var.spoke_udrs
  route_table_next_hop        = [var.fw_internal_lb_ip]
  location                    = var.location
  resource_group_name         = azurerm_resource_group.spoke1_rg.name
}

data "template_file" "web_startup" {
  template = "${file("${path.module}/scripts/web_startup.yml.tpl")}"
}

module "spoke1_vm" { 
  source              = "./modules/spoke_vm/"
  name                = "${var.spoke1_prefix}-vm"
  vm_count            = var.spoke1_vm_count
  subnet_id           = module.spoke1_vnet.vnet_subnets[0]
  availability_set_id = ""
  backend_pool_ids    = [module.spoke1_lb.backend_pool_id]
  custom_data         = base64encode(data.template_file.web_startup.rendered)
  publisher           = "Canonical"
  offer               = "UbuntuServer"
  sku                 = "16.04-LTS"
  username            = var.spoke_username
  password            = var.spoke_password
  tags                = var.tags
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke1_rg.name
}

module "spoke1_lb" {
  source                  = "./modules/lb/"
  name                    = "${var.spoke1_prefix}-lb"
  type                    = "private"
  sku                     = "Standard"
  probe_ports             = [80]
  frontend_ports          = [80]
  backend_ports           = [80]
  protocol                = "Tcp"
  enable_floating_ip      = false
  subnet_id               = module.spoke1_vnet.vnet_subnets[0]
  private_ip_address      = var.spoke1_internal_lb_ip
  location                = var.location
  resource_group_name     = azurerm_resource_group.spoke1_rg.name
}

#-----------------------------------------------------------------------------------------------------------------
# Create spoke2 resource group, spoke2 VNET, spoke2 VM 

resource "azurerm_resource_group" "spoke2_rg" {
  name     = "${var.global_prefix}${var.spoke2_prefix}-rg"
  location = var.location
}

module "spoke2_vnet" {
  source                      = "./modules/spoke_vnet/"
  name                   = "${var.spoke2_prefix}-vnet"
  address_space               = var.spoke2_vnet_cidr
  subnet_prefixes             = var.spoke2_subnet_cidrs
  remote_vnet_rg              = azurerm_resource_group.transit.name
  remote_vnet_name            = module.vnet.vnet_name
  remote_vnet_id              = module.vnet.vnet_id
  route_table_destinations    = var.spoke_udrs
  route_table_next_hop        = [var.fw_internal_lb_ip]
  location                    = var.location
  resource_group_name         = azurerm_resource_group.spoke2_rg.name
}

module "spoke2_vm" {
  source              = "./modules/spoke_vm/"
  name                = "${var.spoke2_prefix}-vm"
  vm_count            = var.spoke2_vm_count
  subnet_id           = module.spoke2_vnet.vnet_subnets[0]
  availability_set_id = ""
  publisher           = "Canonical"
  offer               = "UbuntuServer"
  sku                 = "16.04-LTS"
  username            = var.spoke_username
  password            = var.spoke_password
  tags                = var.tags
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke2_rg.name
}