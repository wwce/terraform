output nic0_id {
  value = azurerm_network_interface.nic0.*.id
}

output nic1_id {
  value = azurerm_network_interface.nic1.*.id
}

output nic2_id {
  value = azurerm_network_interface.nic2.*.id
}

output nic1_public_ip {
  value = azurerm_public_ip.nic1.*.ip_address
}

output nic0_public_ip {
  value = azurerm_public_ip.nic0.*.ip_address
}

