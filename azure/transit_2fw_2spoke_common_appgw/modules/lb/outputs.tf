output public_ip {
  value = azurerm_public_ip.main.*.ip_address
}

output backend_pool_id {
  value = azurerm_lb_backend_address_pool.main.id
}

output backend_pool_name {
  value = azurerm_lb_backend_address_pool.main.name
}