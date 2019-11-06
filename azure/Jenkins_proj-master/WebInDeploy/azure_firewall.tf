resource "azurerm_firewall" "app1-azure-firewall" {
  name                = "app1-azure-firewall"
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  location            = "${data.azurerm_resource_group.resourcegroup.location}"

  ip_configuration {
    name                 = "app1configuration"
    subnet_id            = "${azurerm_subnet.firewall.id}"
    public_ip_address_id = "${azurerm_public_ip.appgw1.id}"
  }
}

resource "azurerm_firewall_nat_rule_collection" "app1dnat" {
  name                = "app1dnat"
  azure_firewall_name = "${azurerm_firewall.app1-azure-firewall.name}"
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  priority            = 100
  action              = "Dnat"

  rule {
    name                  = "app1dnat1"
    source_addresses      = [ "*", ]
    destination_ports     = [ "80", ]
    destination_addresses = [ "${azurerm_public_ip.appgw1.ip_address}", ]
    protocols             = [ "TCP", ]
    translated_address    = "10.0.3.8"
    translated_port       = "80"
  }
}

resource "azurerm_firewall" "app2-azure-firewall" {
  name                = "app2-azure-firewall"
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  location            = "${data.azurerm_resource_group.resourcegroup.location}"

  ip_configuration {
    name                 = "app2configuration"
    subnet_id            = "${azurerm_subnet.firewall.id}"
    public_ip_address_id = "${azurerm_public_ip.appgw2.id}"
  }
}

resource "azurerm_firewall_nat_rule_collection" "app2dnat" {
  name                = "app2dnat"
  azure_firewall_name = "${azurerm_firewall.app2-azure-firewall.name}"
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  priority            = 100
  action              = "Dnat"

  rule {
    name                  = "app2dnat1"
    source_addresses      = [ "*", ]
    destination_ports     = [ "80", ]
    destination_addresses = [ "${azurerm_public_ip.appgw2.ip_address}", ]
    protocols             = [ "TCP", ]
    translated_address    = "10.0.3.9"
    translated_port       = "80"
  }
}
