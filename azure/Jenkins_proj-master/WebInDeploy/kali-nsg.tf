resource "azurerm_network_security_group" "Attack_NSG" {
  name                = "Attack_NSG"
	location			      = "${azurerm_resource_group.attackgroup.location}"
	resource_group_name	= "${azurerm_resource_group.attackgroup.name}"

  security_rule {
    name                       = "Allow-FW-22"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "${var.Attack_IP}"
  }

  security_rule {
    name                       = "Allow-FW-443"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "${var.Attack_IP}"
  }

  security_rule {
    name                       = "Allow-FW-5000"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "5000"
    source_address_prefix      = "*"
    destination_address_prefix = "${var.Attack_IP}"
  }
}
resource "azurerm_subnet_network_security_group_association" "attackgroup" {
  subnet_id                 = "${azurerm_subnet.attacker.id}"
  network_security_group_id = "${azurerm_network_security_group.Attack_NSG.id}"
}