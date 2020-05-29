#### CREATE THE ROUTE TABLES ####

resource "azurerm_route_table" "panorama" {
  name                = "panorama"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  route {
    name           = "internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "internet"
  }
}

resource "azurerm_subnet_route_table_association" "panorama" {
  subnet_id      = "${azurerm_subnet.panorama.id}"
  route_table_id = "${azurerm_route_table.panorama.id}"
}