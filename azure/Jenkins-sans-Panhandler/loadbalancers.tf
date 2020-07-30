#### CREATE THE LOAD BALANCERS ####

#### AppGW1 ####

resource "azurerm_application_gateway" "appgw1" {
  name                = "appgw1"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
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
    name                 	  = "lbipaddress1"
    subnet_id		 	  = "${azurerm_subnet.loadbalancers.id}"
    private_ip_address_allocation = "static"
    private_ip_address 		  = "10.0.3.8"
  }
  backend_address_pool {
    name 	 = "webservers"
    ip_addresses = ["${var.Web_IP}"]
  }
  http_listener {
    name                           = "http"
    frontend_ip_configuration_name = "lbipaddress1"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }
  probe {
    name                = "probe"
    protocol            = "http"
    path                = "/login"
    host                = "127.0.0.1"
    interval            = "30"
    timeout             = "30"
    unhealthy_threshold = "3"
  }
  backend_http_settings {
    name                  = "http"
    cookie_based_affinity = "Disabled"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 1
    probe_name            = "probe"
  }
  request_routing_rule {
    name                       = "http"
    rule_type                  = "Basic"
    http_listener_name         = "http"
    backend_address_pool_name  = "webservers"
    backend_http_settings_name = "http"
  }
  depends_on = ["azurerm_resource_group.resourcegroup"]
}

#### AppGW2 ####

resource "azurerm_application_gateway" "appgw2" {
  name                = "appgw2"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
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
    name                 	  = "lbpublicipaddress2"
    subnet_id		 	  = "${azurerm_subnet.loadbalancers.id}"
    private_ip_address_allocation = "static"
    private_ip_address 		  = "10.0.3.9"
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
  probe {
    name                = "probe"
    protocol            = "http"
    path                = "/login"
    host                = "127.0.0.1"
    interval            = "30"
    timeout             = "30"
    unhealthy_threshold = "3"
  }
  backend_http_settings {
    name                  = "http"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
    probe_name            = "probe"
  }
  request_routing_rule {
    name                       = "http"
    rule_type                  = "Basic"
    http_listener_name         = "http"
    backend_address_pool_name  = "firewalls"
    backend_http_settings_name = "http"
  }
  depends_on = ["azurerm_resource_group.resourcegroup"]
}
