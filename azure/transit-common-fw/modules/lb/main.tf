resource "azurerm_public_ip" "main" {
  count               = var.type == "public" ? 1 : 0
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = var.sku
}

resource "azurerm_lb" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                          = var.frontend_name
    public_ip_address_id          = var.type == "public" ? join("", azurerm_public_ip.main.*.id) : ""
    subnet_id                     = var.type == "public" ? "" : var.subnet_id
    private_ip_address_allocation = var.private_ip_address == "" ? "Dynamic" : "Static"
    private_ip_address            = var.type == "public" ? "" : var.private_ip_address
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  name                = var.backend_name
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.main.id
}

resource "azurerm_lb_probe" "main" {
  count               = length(var.probe_ports)
  name                = "${var.probe_name}-${element(var.probe_ports, count.index)}"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.main.id
  port                = element(var.probe_ports, count.index)
}

resource "azurerm_lb_rule" "main" {
  count                          = length(var.frontend_ports)
  name                           = "rule-${count.index}"
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.main.id
  protocol                       = var.protocol
  frontend_port                  = element(var.frontend_ports, count.index)
  backend_port                   = element(var.backend_ports, count.index)
  frontend_ip_configuration_name = var.frontend_name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.main.id
  probe_id                       = element(azurerm_lb_probe.main.*.id, count.index)
  enable_floating_ip             = var.enable_floating_ip
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = var.backend_pool_count
  network_interface_id    = element(var.backend_pool_interfaces, count.index)
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

