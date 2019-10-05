resource "azurerm_network_security_group" "Console_NSG" {
  name                  = "Console_NSG"
  location		= "${azurerm_resource_group.consolegroup.location}"
  resource_group_name	= "${azurerm_resource_group.consolegroup.name}"

  security_rule {
    name                       = "Allow-22"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "${var.Console_IP}"
  }

  security_rule {
    name                       = "Allow-8080-8090"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080-8090"
    source_address_prefix      = "*"
    destination_address_prefix = "${var.Console_IP}"
  }

}
resource "azurerm_subnet_network_security_group_association" "Consolegroup" {
  subnet_id                 = "${azurerm_subnet.console.id}"
  network_security_group_id = "${azurerm_network_security_group.Console_NSG.id}"
}
