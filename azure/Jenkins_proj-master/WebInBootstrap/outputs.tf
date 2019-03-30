output "Resource_Group" {
  value = "${azurerm_resource_group.resourcegroup.name}"
}
output "Storage_Account_Access_Key" {
  value = "${azurerm_storage_account.bootstrap.primary_access_key}"
}
output "Bootstrap_Bucket" {
  value="bootstrap${lower(random_id.storage_account.hex)}"
}