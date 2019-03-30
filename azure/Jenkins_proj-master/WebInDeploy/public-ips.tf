#### CREATE PUBLIC IP ADDRESSES ####
resource "random_id" "public_ip" {
  byte_length = 2
}
resource "azurerm_public_ip" fwmanagement {
	name                = "fwmanagement"
	location						= "${data.azurerm_resource_group.resourcegroup.location}"
	resource_group_name	= "${data.azurerm_resource_group.resourcegroup.name}"
	allocation_method   = "Static"
}

resource "azurerm_public_ip" "appgw1" {
  name                = "appgw1"
  location            = "${data.azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  domain_name_label   = "sans-ngfw-${lower(random_id.public_ip.hex)}"
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "appgw2" {
  name                = "appgw2"
  location            = "${data.azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  domain_name_label   = "with-ngfw-${lower(random_id.public_ip.hex)}"
  allocation_method   = "Dynamic"
}