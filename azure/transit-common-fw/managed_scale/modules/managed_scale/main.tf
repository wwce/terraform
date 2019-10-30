data "azurerm_lb" "main" {
  name                = var.lb_name
  resource_group_name = var.resource_group_name
}

data "azurerm_lb_backend_address_pool" "main" {
  name            = var.lb_backend_pool_name
  loadbalancer_id = data.azurerm_lb.main.id
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = var.lb_backend_pool_count
  network_interface_id    = element(var.lb_backend_pool_interfaces, count.index)
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.main.id
}

