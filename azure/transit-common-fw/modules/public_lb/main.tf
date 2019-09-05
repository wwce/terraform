resource "azurerm_public_ip" "main" {
  name                = "${var.lb_name}-pip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "Static"
  sku                 = "${var.lb_sku}"
}
resource "azurerm_lb" "main" {
  name                = "${var.lb_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "${var.lb_sku}"

  frontend_ip_configuration {
    name                          = "${var.lb_frontend_name}"
    public_ip_address_id = "${azurerm_public_ip.main.id}"
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
  count                          = "${length(var.lb_allowed_tcp_ports)}"
  name                           = "rule-${count.index}"
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.main.id}"
  protocol                       = "Tcp"
  frontend_port                  = "${element(var.lb_allowed_tcp_ports, count.index)}"
  backend_port                   = "${element(var.lb_allowed_tcp_ports, count.index)}"
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