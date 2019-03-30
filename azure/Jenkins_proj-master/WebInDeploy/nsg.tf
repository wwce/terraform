resource "azurerm_network_security_group" "PAN_FW_NSG" {
  name                = "DefaultNSG"
  resource_group_name      = "${data.azurerm_resource_group.resourcegroup.name}"
  location                 = "${data.azurerm_resource_group.resourcegroup.location}"

  security_rule {
    name                       = "Allow-22"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "${var.FW_Mgmt_IP}"
  }
  security_rule {
    name                       = "Allow-443"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "${var.FW_Mgmt_IP}"
  }
  
  security_rule {
    name                       = "Allow-80-LB"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "Allow-Intra-80"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${var.Victim_CIDR}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Intra-8080"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "${var.Victim_CIDR}"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = "${azurerm_subnet.management.id}"
  network_security_group_id = "${azurerm_network_security_group.PAN_FW_NSG.id}"
}
resource "azurerm_subnet_network_security_group_association" "untrust" {
  subnet_id                 = "${azurerm_subnet.untrust.id}"
  network_security_group_id = "${azurerm_network_security_group.PAN_FW_NSG.id}"
}
resource "azurerm_subnet_network_security_group_association" "trust" {
  subnet_id                 = "${azurerm_subnet.trust.id}"
  network_security_group_id = "${azurerm_network_security_group.PAN_FW_NSG.id}"
}
resource "azurerm_subnet_network_security_group_association" "loadbalancers" {
  subnet_id                 = "${azurerm_subnet.loadbalancers.id}"
  network_security_group_id = "${azurerm_network_security_group.PAN_FW_NSG.id}"
}
resource "azurerm_subnet_network_security_group_association" "webservers" {
  subnet_id                 = "${azurerm_subnet.webservers.id}"
  network_security_group_id = "${azurerm_network_security_group.PAN_FW_NSG.id}"
}