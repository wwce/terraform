resource "azurerm_network_security_group" "panorama" {
  name                     = "${var.networkSecurityGroupName}"
  resource_group_name      = "${azurerm_resource_group.resourcegroup.name}"
  location                 = "${azurerm_resource_group.resourcegroup.location}"

  security_rule {
    name                       = "TCP-22"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "${azurerm_network_interface.panorama.private_ip_address}"
  }
  security_rule {
    name                       = "TCP-443"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "${azurerm_network_interface.panorama.private_ip_address}"
  }
}
resource "azurerm_subnet_network_security_group_association" "panorama" {
  subnet_id                 = "${azurerm_subnet.panorama.id}"
  network_security_group_id = "${azurerm_network_security_group.panorama.id}"
}