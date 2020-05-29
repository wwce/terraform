//# ********** RESOURCE GROUP **********
//
//# Create a resource group
resource "azurerm_resource_group" "resourcegroup" {
	name		= "${var.RG_Name}"
	location	= "${var.Azure_Region}"
}

//# ********** VNET **********
//
//# Create a virtual network in the resource group
//resource "azurerm_virtual_network" "vnet" {
//	name				= "vnet-fw"
//	address_space		= ["${var.VNetCIDR}"]
//	location			= "${azurerm_resource_group.resourcegroup.location}"
//	resource_group_name	= "${azurerm_resource_group.resourcegroup.name}"
//}
//
//#### CREATE THE SUBNETS ####
//
//resource "azurerm_subnet" "management" {
//  name                 = "management"
//  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
//  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
//  address_prefix       = "${var.WebCIDR_MGMT}"
//}
//
//resource "azurerm_subnet" "untrust" {
//  name                 = "untrust"
//  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
//  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
//  address_prefix       = "${var.WebCIDR_UntrustBlock}"
//}
//
//resource "azurerm_subnet" "trust" {
//  name                 = "trust"
//  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
//  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
//  address_prefix       = "${var.WebCIDR_TrustBlock}"
//}
//
//resource "azurerm_subnet" "loadbalancers" {
//  name                 = "loadbalancers"
//  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
//  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
//  address_prefix       = "${var.WebCIDR_AppGWBlock}"
//}
//
//resource "azurerm_subnet" "webservers" {
//  name                 = "webservers"
//  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
//  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
//  address_prefix       = "${var.WebCIDR_WebBlock}"
//}