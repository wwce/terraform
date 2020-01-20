output file_share_name {
  value = azurerm_storage_share.main.name
}

output "completion" {
  value = null_resource.dependency_setter.id
}