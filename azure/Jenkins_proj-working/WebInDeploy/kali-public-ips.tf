#### CREATE PUBLIC IP ADDRESSES ####

resource "azurerm_public_ip" attacker {
	name                = "attacker"
	location			      = "${azurerm_resource_group.attackgroup.location}"
	resource_group_name	= "${azurerm_resource_group.attackgroup.name}"
	allocation_method   = "Static"
}