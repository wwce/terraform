#### CREATE THE ROUTE TABLES ####

resource "azurerm_route_table" "management" {
  name                = "management"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  route {
    name           = "internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "internet"
  }
}
resource "azurerm_route_table" "untrust" {
  name                = "untrust"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  route {
    name           = "internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "internet"
  }
}

resource "azurerm_route_table" "webservers" {
  name                = "webservers"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  route {
    name           = "attacker"
    address_prefix = "${azurerm_public_ip.attacker.ip_address}"
    next_hop_type  = "internet"
  }
  route {
    name           = "internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address  = "${azurerm_firewall.app1-azure-firewall.ip_configuration[0].private_ip_address}"
  }
}

resource "azurerm_subnet_route_table_association" "management" {
  subnet_id      = "${azurerm_subnet.management.id}"
  route_table_id = "${azurerm_route_table.management.id}"
}

resource "azurerm_subnet_route_table_association" "untrust" {
  subnet_id      = "${azurerm_subnet.untrust.id}"
  route_table_id = "${azurerm_route_table.untrust.id}"
}

resource "azurerm_subnet_route_table_association" "webservers" {
  subnet_id      = "${azurerm_subnet.webservers.id}"
  route_table_id = "${azurerm_route_table.webservers.id}"
}
