# ********** RESOURCE GROUP **********

# Create a resource group
resource "random_id" "attack_resource_group" {
  byte_length = 2
}
resource "azurerm_resource_group" "attackgroup" {
	name		= "${var.Attack_RG_Name}-${lower(random_id.attack_resource_group.hex)}"
	location	= "${var.Azure_Region}"
}

# ********** VNET **********

# Create a virtual network in the resource group
resource "azurerm_virtual_network" "attack-vnet" {
	name				= "attack-vnet"
	address_space		= ["${var.Attack_CIDR}"]
	location			= "${azurerm_resource_group.attackgroup.location}"
	resource_group_name	= "${azurerm_resource_group.attackgroup.name}"
}

#### CREATE THE SUBNETS ####

resource "azurerm_subnet" "attacker" {
  name                 = "attacker"
  resource_group_name  = "${azurerm_resource_group.attackgroup.name}"
  virtual_network_name = "${azurerm_virtual_network.attack-vnet.name}"
  address_prefix       = "${var.Attack_Subnet_CIDR}"
}