#### AppGW2 ####
resource "random_id" "storage_account" {
  byte_length = 2
}

resource "azurerm_public_ip" "appgw" {
  name                = "appgw"
  location            = var.location
  resource_group_name = var.resource_group_name
  domain_name_label   = "appgw-${lower(random_id.storage_account.hex)}"
  allocation_method   = "Dynamic"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "appgw"
  location            = var.location
  resource_group_name = var.resource_group_name

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
    name = "appgw"
    subnet_id = var.subnet_appgw
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appgw"
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  backend_address_pool {
    name = "BackendPool"
    ip_addresses = var.fw_private_ips

  }

  http_listener {
    name                           = "http"
    frontend_ip_configuration_name = "appgw"
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
    backend_address_pool_name  = "BackendPool"
    backend_http_settings_name = "http"
  }
}