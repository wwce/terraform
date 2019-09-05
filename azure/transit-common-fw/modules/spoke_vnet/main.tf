#-----------------------------------------------------------------------------------------------------------------
# Create spoke VNET
resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.vnet_name}"
  location            = "${var.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.main.name}"
  dns_servers         = "${var.dns_servers}"
  tags                = "${var.tags}"
}

resource "azurerm_subnet" "main" {
  count                = "${length(var.subnet_names)}"
  name                 = "${var.subnet_names[count.index]}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  address_prefix       = "${var.subnet_prefixes[count.index]}"
}

#-----------------------------------------------------------------------------------------------------------------
# Create peering link between new spoke VNET and transit VNET
data "azurerm_virtual_network" "transit" {
  name                = "${var.transit_vnet_name}"
  resource_group_name = "${var.transit_vnet_resource_group}"
}

resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  name                         = "${var.vnet_name}-to-${var.transit_vnet_name}"
  resource_group_name          = "${azurerm_resource_group.main.name}"
  virtual_network_name         = "${azurerm_virtual_network.main.name}"
  remote_virtual_network_id    = "${data.azurerm_virtual_network.transit.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  name                         = "${var.transit_vnet_name}-to-${var.vnet_name}"
  resource_group_name          = "${var.transit_vnet_resource_group}"
  virtual_network_name         = "${var.transit_vnet_name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.main.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

#-----------------------------------------------------------------------------------------------------------------
# Create route table for subnets with default route to transit virtual appliance
resource "azurerm_route_table" "main" {
  name                = "${var.vnet_name}-route-table"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_route" "main" {
  count                  = "${length(var.route_table_destinations)}"
  name                   = "udr-${count.index}"
  resource_group_name    = "${azurerm_resource_group.main.name}"
  route_table_name       = "${azurerm_route_table.main.name}"
  address_prefix         = "${element(var.route_table_destinations, count.index)}"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "${element(var.route_table_next_hop, count.index)}"
}

resource "azurerm_subnet_route_table_association" "main" {
  count          = "${length(var.subnet_names)}"
  subnet_id      = "${element(azurerm_subnet.main.*.id, count.index)}"
  route_table_id = "${azurerm_route_table.main.id}"
}
