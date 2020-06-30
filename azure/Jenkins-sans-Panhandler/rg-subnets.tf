//# ********** RESOURCE GROUP **********
//
//# Create a resource group

resource "azurerm_resource_group" "resourcegroup" {
  name    = "${var.RG_Name}-${random_pet.blue_team.id}"
	location	= "${var.Azure_Region}"
}
# ********** VNET **********

# Create a virtual network in the resource group
resource "azurerm_virtual_network" "vnet" {
  name				= "vnet-fw"
  address_space		= ["${var.Victim_CIDR}"]
  location		= "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name	= "${azurerm_resource_group.resourcegroup.name}"
}

#### CREATE THE SUBNETS ####

resource "azurerm_subnet" "management" {
  name                 = "management"
  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = ["${var.Mgmt_Subnet_CIDR}"]
}

resource "azurerm_subnet" "untrust" {
  name                 = "untrust"
  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = ["${var.Untrust_Subnet_CIDR}"]
}

resource "azurerm_subnet" "trust" {
  name                 = "trust"
  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = ["${var.Trust_Subnet_CIDR}"]
}

resource "azurerm_subnet" "loadbalancers" {
  name                 = "loadbalancers"
  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = ["${var.AppGW_Subnet_CIDR}"]
}

resource "azurerm_subnet" "webservers" {
  name                 = "webservers"
  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = ["${var.Web_Subnet_CIDR}"]
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = ["${var.Firewall_Subnet_CIDR}"]
}
