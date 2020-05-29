#### CREATE THE LOAD BALANCERS ####

#### AppGW1 ####

resource "azurerm_application_gateway" "appgw1" {
  name                = "appgw1"
  location            = "${data.azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  sku {
    name = "WAF_Medium"
    tier = "WAF"
    capacity = 2
  }
  waf_configuration {
    enabled = "true"
    firewall_mode = "Prevention"
    rule_set_type = "OWASP"
    rule_set_version = "3.0"
  }
  gateway_ip_configuration {
    name = "loadbalancers"
    subnet_id = "${azurerm_subnet.loadbalancers.id}"
  }
  frontend_port {
    name = "http"
    port = 80
  }
  frontend_ip_configuration {
    name                 = "lbpublicipaddress1"
    public_ip_address_id = "${azurerm_public_ip.appgw1.id}"
  }
  backend_address_pool {
    name = "webservers"
    ip_addresses = ["${var.Web_IP}"]
  }
  http_listener {
    name                           = "http"
    frontend_ip_configuration_name = "lbpublicipaddress1"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }
  backend_http_settings {
    name                  = "http"
    cookie_based_affinity = "Disabled"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 1
  }
  request_routing_rule {
    name                       = "http"
    rule_type                  = "Basic"
    http_listener_name         = "http"
    backend_address_pool_name  = "webservers"
    backend_http_settings_name = "http"
  }
  depends_on = ["data.azurerm_resource_group.resourcegroup"]
}

#### AppGW2 ####

resource "azurerm_application_gateway" "appgw2" {
  name                = "appgw2"
  location            = "${data.azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  sku {
    name = "WAF_Medium"
    tier = "WAF"
    capacity = 2
  }
  waf_configuration {
    enabled = "true"
    firewall_mode = "Prevention"
    rule_set_type = "OWASP"
    rule_set_version = "3.0"
  }
  gateway_ip_configuration {
    name = "loadbalancers"
    subnet_id = "${azurerm_subnet.loadbalancers.id}"
  }
  frontend_port {
    name = "http"
    port = 80
  }
  frontend_ip_configuration {
    name                 = "lbpublicipaddress2"
    public_ip_address_id = "${azurerm_public_ip.appgw2.id}"
  }
  backend_address_pool {
    name = "firewalls"
    ip_addresses = ["${var.FW_Untrust_IP}"]
  }
  http_listener {
    name                           = "http"
    frontend_ip_configuration_name = "lbpublicipaddress2"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }
  backend_http_settings {
    name                  = "http"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }
  request_routing_rule {
    name                       = "http"
    rule_type                  = "Basic"
    http_listener_name         = "http"
    backend_address_pool_name  = "firewalls"
    backend_http_settings_name = "http"
  }
  depends_on = ["data.azurerm_resource_group.resourcegroup"]
}

#### INTERNAL APP FACING LOAD BALANCER ####

resource "azurerm_lb" "weblb" {
  name                = "weblb"
  location            = "${data.azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  frontend_ip_configuration {
    name                          = "weblbip"
		subnet_id                     = "${azurerm_subnet.webservers.id}"
    private_ip_address_allocation = "Static"
    private_ip_address = "${var.WebLB_IP}"
  }
}
resource "azurerm_lb_backend_address_pool" "webservers" {
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  loadbalancer_id     = "${azurerm_lb.weblb.id}"
  name                = "webservers"
}
resource "azurerm_network_interface_backend_address_pool_association" "webservers" {
  network_interface_id    = "${azurerm_network_interface.web1.id}"
  ip_configuration_name   = "web1eth0"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.webservers.id}"
}
resource "azurerm_lb_probe" "webservers" {
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  loadbalancer_id     = "${azurerm_lb.weblb.id}"
  name                = "http-running-probe"
  port                = 8080
}

resource "azurerm_lb_rule" "webservers" {
  resource_group_name            = "${data.azurerm_resource_group.resourcegroup.name}"
  loadbalancer_id                = "${azurerm_lb.weblb.id}"
  name                           = "WebRule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "weblbip"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.webservers.id}"
  probe_id                       = "${azurerm_lb_probe.webservers.id}"
}
