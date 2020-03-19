#### CREATE PUBLIC IP ADDRESSES ####
resource "azurerm_public_ip" panorama {
	name                = "${var.publicIpAddressName}"
	location						= "${azurerm_resource_group.resourcegroup.location}"
	resource_group_name	= "${azurerm_resource_group.resourcegroup.name}"
	allocation_method   = "Static"
}