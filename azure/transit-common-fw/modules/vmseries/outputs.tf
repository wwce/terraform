output nic0_id {
  value = "${azurerm_network_interface.nic0_static.*.id}"
}

output nic1_id {
  value = "${azurerm_network_interface.nic1_static.*.id}"
}

output nic2_id {
  value = "${azurerm_network_interface.nic2_static.*.id}"
}
