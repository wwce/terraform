#### CREATE PUBLIC IP ADDRESSES ####

resource "azurerm_public_ip" console {
	name                = "console"
	location			      = "${azurerm_resource_group.consolegroup.location}"
	resource_group_name	= "${azurerm_resource_group.consolegroup.name}"
	allocation_method   = "Static"
}