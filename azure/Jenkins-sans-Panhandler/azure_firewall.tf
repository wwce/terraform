resource "azurerm_firewall" "app1-azure-firewall" {
  name                = "app1-azure-firewall"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  threat_intel_mode   = "Deny"
  ip_configuration {
    name                 = "app1configuration"
    subnet_id            = "${azurerm_subnet.firewall.id}"
    public_ip_address_id = "${azurerm_public_ip.appgw1.id}"
  }
  ip_configuration {
    name                 = "app2configuration"
    public_ip_address_id = "${azurerm_public_ip.appgw2.id}"
  }
}

resource "azurerm_firewall_nat_rule_collection" "app1dnat" {
  name                = "appdnat"
  azure_firewall_name = "${azurerm_firewall.app1-azure-firewall.name}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  priority            = 100
  action              = "Dnat"

  rule {
    name                  = "appdnat1"
    source_addresses      = [ "*", ]
    destination_ports     = [ "80", ]
    destination_addresses = [ "${azurerm_public_ip.appgw1.ip_address}", ]
    protocols             = [ "TCP", ]
    translated_address    = "10.0.3.8"
    translated_port       = "80"
  }
  rule {
    name                  = "appdnat2"
    source_addresses      = [ "*", ]
    destination_ports     = [ "80", ]
    destination_addresses = [ "${azurerm_public_ip.appgw2.ip_address}", ]
    protocols             = [ "TCP", ]
    translated_address    = "10.0.3.9"
    translated_port       = "80"
  }
}

resource "azurerm_firewall_network_rule_collection" "to-internet" {
  name                = "outbound"
  azure_firewall_name = "${azurerm_firewall.app1-azure-firewall.name}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  priority            = 100
  action              = "Allow"

  rule {
    name = "webserver"

    source_addresses = [
      "${azurerm_subnet.webservers.address_prefixes[0]}",
    ]

    destination_ports = [
      "443",
    ]

    destination_addresses = [
      "*",
    ]

    protocols = [
      "TCP",
    ]
  }
}
