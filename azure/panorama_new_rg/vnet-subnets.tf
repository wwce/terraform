# ********** VNET **********

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name				        = "${var.virtualNetworkName}"
  address_space		    = ["${var.addressPrefix}"]
  location		        = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name	= "${azurerm_resource_group.resourcegroup.name}"
}

# Create the subnet

resource "azurerm_subnet" "panorama" {
  name                 = "${var.subnetName}"
  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${var.subnet}"
}