resource "azurerm_virtual_network" "main" {
  name                = var.name
  location            = var.location
  address_space       = [var.vnet_cidr]
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers
  tags                = var.tags
}

resource "azurerm_subnet" "main" {
  count                = length(var.subnet_cidrs)
  name = var.subnet_names != null ? element(var.subnet_names, count.index) :  "${var.name}-subnet${count.index + 1}"

  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = var.resource_group_name
  address_prefixes       = [element(var.subnet_cidrs, count.index)]
}

resource "azurerm_subnet_route_table_association" "main" {
  count          = var.route_table_ids != null ? length(var.subnet_cidrs)  : 0
  route_table_id = element(var.route_table_ids, count.index)
  subnet_id      = element(azurerm_subnet.main.*.id, count.index)
  depends_on = [
    azurerm_subnet.main
  ]
}
