#### CREATE PUBLIC IP ADDRESSES ####

resource "azurerm_public_ip" fwmanagement {
	name                = "fwmanagement"
	location						= "${azurerm_resource_group.resourcegroup.location}"
	resource_group_name	= "${azurerm_resource_group.resourcegroup.name}"
	allocation_method   = "Static"
}

resource "azurerm_public_ip" "appgw1" {
  name                = "appgw1"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "appgw2" {
  name                = "appgw2"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  allocation_method   = "Dynamic"
}