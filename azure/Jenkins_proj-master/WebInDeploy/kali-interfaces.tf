#### CREATE THE NETWORK INTERFACES ####

resource "azurerm_network_interface" "attacker" {
	name								= "attacker"
	location							= "${azurerm_resource_group.attackgroup.location}"
	resource_group_name 				= "${azurerm_resource_group.attackgroup.name}"
	ip_configuration {
		name							= "eth0"
		subnet_id						= "${azurerm_subnet.attacker.id}"
		private_ip_address_allocation 	= "Static"
    private_ip_address = "${var.Attack_IP}"
		public_ip_address_id = "${azurerm_public_ip.attacker.id}"
	}
	depends_on = ["azurerm_public_ip.attacker"]
}