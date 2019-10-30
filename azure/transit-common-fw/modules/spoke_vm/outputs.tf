output "nic0_id" {
  value = azurerm_network_interface.main.*.id
}

