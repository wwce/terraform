#### CREATE THE NETWORK INTERFACES ####

resource "azurerm_network_interface" "panorama" {
	name								= "${var.networkInterfaceName}"
	location            = "${azurerm_resource_group.resourcegroup.location}"
	resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
	ip_configuration {
		name							              = "${var.networkInterfaceName}"
		subnet_id						            = "${azurerm_subnet.panorama.id}"
		private_ip_address_allocation 	= "Dynamic"
		public_ip_address_id            = "${azurerm_public_ip.panorama.id}"
	}
	depends_on = ["azurerm_public_ip.panorama"]
}