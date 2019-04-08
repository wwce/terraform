output "MGT-IP-FW-1" {
  value = "${azurerm_public_ip.fwmanagement.ip_address}"
}

output "NLB-DNS" {
  value = "${var.WebLB_IP}"
}

output "ALB-DNS" {
  value = "${azurerm_public_ip.appgw2.fqdn}"
}

output "NATIVE-DNS" {
  value = "${azurerm_public_ip.appgw1.fqdn}"
}

output "ATTACKER_IP" {
  value = "${azurerm_public_ip.attacker.ip_address}"
}

output "RG_Name" {
  value = "${data.azurerm_resource_group.resourcegroup.name}"
}

output "Attacker_RG_Name" {
  value = "${azurerm_resource_group.attackgroup.name}"
}
