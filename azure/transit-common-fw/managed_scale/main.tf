resource "azurerm_resource_group" "rg" {
  name     = "scaled-vmseries-rg"
  location = "eastus"
}

data "azurerm_subnet" "mgmt" {
  name                 = var.mgmt_subnet
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}

data "azurerm_subnet" "untrust" {
  name                 = var.untrust_subnet
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}

data "azurerm_subnet" "trust" {
  name                 = var.trust_subnet
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}

#-----------------------------------------------------------------------------------------------------------------
# Create VM-Series NGFW.  For every fw_name entered, an additional VM-Series instance will be deployed.
module "vmseries" {
  source                       = "./modules/vmseries/"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.rg.name
  fw_names                     = var.fw_names
  fw_username                  = var.fw_username
  fw_password                  = var.fw_password
  fw_panos                     = var.fw_panos
  fw_license                   = var.fw_license
  fw_nsg_prefix                = var.fw_nsg_prefix
  fw_avset_name                = var.fw_avset_name
  fw_subnet_mgmt               = data.azurerm_subnet.mgmt.id
  fw_subnet_untrust            = data.azurerm_subnet.untrust.id
  fw_subnet_trust              = data.azurerm_subnet.trust.id
  fw_bootstrap_storage_account = var.fw_bootstrap_storage_account
  fw_bootstrap_access_key      = var.fw_bootstrap_access_key
  fw_bootstrap_file_share      = var.fw_bootstrap_file_share
  fw_bootstrap_share_directory = var.fw_bootstrap_share_directory
  prefix                       = var.prefix
}

module "add_to_public_lb" {
  source              = "./modules/managed_scale/"
  location            = var.location
  resource_group_name = var.vnet_rg
  lb_name             = var.public_lb_name

  lb_backend_pool_name       = var.public_lb_pool
  lb_backend_pool_count      = length(var.fw_names)
  lb_backend_pool_interfaces = module.vmseries.nic1_id
}

module "add_to_internal_lb" {
  source              = "./modules/managed_scale/"
  location            = var.location
  resource_group_name = var.vnet_rg
  lb_name             = var.internal_lb_name

  lb_backend_pool_name       = var.internal_lb_pool
  lb_backend_pool_count      = length(var.fw_names)
  lb_backend_pool_interfaces = module.vmseries.nic2_id
}

