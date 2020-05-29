output "Panorama Public IP:" {
  value = "${azurerm_public_ip.panorama.ip_address}"
}