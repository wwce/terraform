# ********** RESOURCE GROUP **********

# Create a resource group
resource "azurerm_resource_group" "attackgroup" {
	name		= "${var.KaliRGName}"
	location	= "${var.azure_region}"
}

# ********** VNET **********

# Create a virtual network in the resource group
resource "azurerm_virtual_network" "attack-vnet" {
	name				= "attack-vnet"
	address_space		= ["${var.KaliCIDR}"]
	location			= "${azurerm_resource_group.attackgroup.location}"
	resource_group_name	= "${azurerm_resource_group.attackgroup.name}"
}

#### CREATE THE SUBNETS ####

resource "azurerm_subnet" "attacker" {
  name                 = "attacker"
  resource_group_name  = "${azurerm_resource_group.attackgroup.name}"
  virtual_network_name = "${azurerm_virtual_network.attack-vnet.name}"
  address_prefix       = "${var.attackcidr1}"
}