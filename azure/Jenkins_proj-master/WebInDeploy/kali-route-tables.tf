#### CREATE THE ROUTE TABLES ####

resource "azurerm_route_table" "attacker" {
  name                = "attacker"
	location			      = "${azurerm_resource_group.attackgroup.location}"
	resource_group_name	= "${azurerm_resource_group.attackgroup.name}"
  route {
    name           = "internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "internet"
  }
}
resource "azurerm_subnet_route_table_association" "attacker" {
  subnet_id      = "${azurerm_subnet.attacker.id}"
  route_table_id = "${azurerm_route_table.attacker.id}"
}