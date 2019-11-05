resource "azurerm_firewall" "app1-azure-firewall" {
  name                = "app1-azure-firewall"
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  location            = "${data.azurerm_resource_group.resourcegroup.location}"

  ip_configuration {
    name                 = "app1configuration"
    subnet_id            = "${azurerm_subnet.AzureFirewallSubnet.id}"
    public_ip_address_id = "${azurerm_public_ip.appgw1.id}"
  }
}

resource "azurerm_firewall_nat_rule_collection" "app1dnat" {
  name                = "app1dnat"
  azure_firewall_name = azurerm_firewall.app1-azure-firewall.name
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  priority            = 100
  action              = "Dnat"

  rule {
    name                  = "app1dnat1"
    source_addresses      = [ "0.0.0.0/0", ]
    destination_ports     = [ "80", ]
    destination_addresses = [ "${azurerm_public_ip.appgw1.ip_address}", ]
    protocols             = [ "TCP", ]
    translated_address    = local.dnat_rules[count.index].translated_address
    translated_port       = "80"
  }
}

resource "azurerm_firewall_nat_rule_collection" "snat" {
  count               = length(local.snat_rules)
  name                = local.snat_rules[count.index].name
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.vnet.name
  priority            = 10000 + 100 * count.index
  action              = "Snat"

  rule {
    name                  = local.snat_rules[count.index].name
    source_addresses      = local.snat_rules[count.index].source_addresses
    destination_ports     = local.snat_rules[count.index].destination_ports
    destination_addresses = [for dest in local.snat_rules[count.index].destination_addresses : contains(var.public_ip_names, dest) ? azurerm_public_ip.fw[index(var.public_ip_names, dest)].ip_address : dest]
    protocols             = local.snat_rules[count.index].protocols
    translated_address    = local.snat_rules[count.index].translated_address
    translated_port       = local.snat_rules[count.index].translated_port
  }
}

resource "azurerm_firewall" "app2-azure-firewall" {
  name                = "app2-azure-firewall"
  resource_group_name = "${data.azurerm_resource_group.resourcegroup.name}"
  location            = "${data.azurerm_resource_group.resourcegroup.location}"

  ip_configuration {
    name                 = "app2configuration"
    subnet_id            = "${azurerm_subnet.AzureFirewallSubnet.id}"
    public_ip_address_id = "${azurerm_public_ip.appgw2.id}"
  }
}
