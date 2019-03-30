#### CREATE THE NETWORK INTERFACES ####

resource "azurerm_network_interface" "fwmanagement" {
	name								= "fwmanagement"
	location							= "${data.azurerm_resource_group.resourcegroup.location}"
	resource_group_name 				= "${data.azurerm_resource_group.resourcegroup.name}"
	ip_configuration {
		name							= "fweth0"
		subnet_id						= "${azurerm_subnet.management.id}"
		private_ip_address_allocation 	= "Static"
    private_ip_address = "${var.FW_Mgmt_IP}"
		public_ip_address_id = "${azurerm_public_ip.fwmanagement.id}"
	}
	depends_on = ["azurerm_public_ip.fwmanagement"]
}

resource "azurerm_network_interface" "fwuntrust" {
	name								= "fwuntrust"
	location							= "${data.azurerm_resource_group.resourcegroup.location}"
	resource_group_name 				= "${data.azurerm_resource_group.resourcegroup.name}"
	enable_ip_forwarding				= "true"
	ip_configuration {
		name							= "fweth1"
		subnet_id						= "${azurerm_subnet.untrust.id}"
		private_ip_address_allocation 	= "Static"
    private_ip_address = "${var.FW_Untrust_IP}"
	}
}

resource "azurerm_network_interface" "fwtrust" {
	name								= "fwtrust"
	location							= "${data.azurerm_resource_group.resourcegroup.location}"
	resource_group_name 				= "${data.azurerm_resource_group.resourcegroup.name}"
	enable_ip_forwarding				= "true"
	ip_configuration {
		name							= "fweth2"
		subnet_id						= "${azurerm_subnet.trust.id}"
		private_ip_address_allocation 	= "Static"
    private_ip_address = "${var.FW_Trust_IP}"
	}
}

#### WEB SERVER INTERFACES FOR APP1 ####

resource "azurerm_network_interface" "web1" {
  name                = "web1eth0"
  location            = "${data.azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  ip_configuration {
    name                          = "web1eth0"
    subnet_id                     = "${azurerm_subnet.webservers.id}"
    private_ip_address_allocation = "Static"
    private_ip_address = "${var.Web_IP}"
  }
}