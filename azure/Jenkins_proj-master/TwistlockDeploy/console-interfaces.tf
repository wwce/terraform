#### CREATE THE NETWORK INTERFACES ####

resource "azurerm_network_interface" "console" {
	name								= "console"
	location							= "${azurerm_resource_group.consolegroup.location}"
	resource_group_name 				= "${azurerm_resource_group.consolegroup.name}"
	ip_configuration {
		name							= "eth0"
		subnet_id						= "${azurerm_subnet.console.id}"
		private_ip_address_allocation 	= "Static"
    private_ip_address = "${var.console_IP}"
		public_ip_address_id = "${azurerm_public_ip.console.id}"
	}
	depends_on = ["azurerm_public_ip.console"]
}