#-----------------------------------------------------------------------------------------------------------------
# Create spoke VNET
resource "azurerm_virtual_network" "main" {
  name                = var.name
  location            = var.location
  address_space       = [var.address_space]
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers
  tags                = var.tags
}

resource "azurerm_subnet" "main" {
  count                = length(var.subnet_prefixes)
  name                 = "${var.name}-subnet${count.index}"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = var.resource_group_name
  address_prefix       = var.subnet_prefixes[count.index]
}

#-----------------------------------------------------------------------------------------------------------------
# Create peering link between new spoke VNET and transit VNET
resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  name                         = "${var.name}-to-${var.remote_vnet_name}"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.main.name
  remote_virtual_network_id    = var.remote_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  name                         = "${var.remote_vnet_name}-to-${var.name}"
  resource_group_name          = var.remote_vnet_rg
  virtual_network_name         = var.remote_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.main.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

#-----------------------------------------------------------------------------------------------------------------
# Create route table for subnets with default route to transit virtual appliance
resource "azurerm_route_table" "main" {
  name                = "${var.name}-route-table"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route" "main" {
  count                  = length(var.route_table_destinations)
  name                   = "udr-${count.index}"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.main.name
  address_prefix         = element(var.route_table_destinations, count.index)
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = element(var.route_table_next_hop, count.index)
}

resource "azurerm_subnet_route_table_association" "main" {
  count          = length(var.subnet_prefixes)
  subnet_id      = element(azurerm_subnet.main.*.id, count.index)
  route_table_id = azurerm_route_table.main.id
  depends_on = [
    azurerm_route_table.main,
    azurerm_subnet.main,
  ]
}

