output "CONSOLE-MGT" {
  value = "${azurerm_public_ip.console.ip_address}"
}
output "Console_RG_Name" {
  value = "${azurerm_resource_group.consolegroup.name}"
}