resource "azurerm_lb" "main" {
  name                = "${var.lb_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "${var.lb_sku}"

  frontend_ip_configuration {
    name                          = "${var.lb_frontend_name}"
    subnet_id                     = "${var.lb_subnet}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.lb_address}"
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  name                = "${var.lb_backend_name}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.main.id}"
}

resource "azurerm_lb_probe" "main" {
  name                = "${var.lb_health_probe_name}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.main.id}"
  port                = "${var.lb_health_probe_port}"
}

resource "azurerm_lb_rule" "main" {
  name                           = "${var.lb_rule_name}"
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.main.id}"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "${var.lb_frontend_name}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.main.id}"
  probe_id                       = "${azurerm_lb_probe.main.id}"
  enable_floating_ip             = true
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = "${var.lb_backend_pool_count}"
  network_interface_id    = "${element(var.lb_backend_pool_interfaces, count.index)}"
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.main.id}"
}
