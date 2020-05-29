# Configure the Microsoft Azure Provider
provider "azurerm" {}

data "azurerm_resource_group" "resourcegroup" {
  name = "${var.RG_Name}"
}

# ********** VNET **********

# Create a virtual network in the resource group
resource "azurerm_virtual_network" "vnet" {
  name				= "vnet-fw"
  address_space		= ["${var.Victim_CIDR}"]
  location		= "${data.azurerm_resource_group.resourcegroup.location}"
  resource_group_name	= "${data.azurerm_resource_group.resourcegroup.name}"
}

#### CREATE THE SUBNETS ####

resource "azurerm_subnet" "management" {
  name                 = "management"
  resource_group_name  = "${data.azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${var.Mgmt_Subnet_CIDR}"
}

resource "azurerm_subnet" "untrust" {
  name                 = "untrust"
  resource_group_name  = "${data.azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${var.Untrust_Subnet_CIDR}"
}

resource "azurerm_subnet" "trust" {
  name                 = "trust"
  resource_group_name  = "${data.azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${var.Trust_Subnet_CIDR}"
}

resource "azurerm_subnet" "loadbalancers" {
  name                 = "loadbalancers"
  resource_group_name  = "${data.azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${var.AppGW_Subnet_CIDR}"
}

resource "azurerm_subnet" "webservers" {
  name                 = "webservers"
  resource_group_name  = "${data.azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${var.Web_Subnet_CIDR}"
}