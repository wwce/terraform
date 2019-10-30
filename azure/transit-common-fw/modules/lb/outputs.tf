output "public_ip" {
  value = azurerm_public_ip.main.*.ip_address
}

