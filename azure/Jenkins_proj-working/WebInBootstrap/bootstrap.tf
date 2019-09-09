resource "random_id" "storage_account" {
  byte_length = 2
}
resource "azurerm_storage_account" "bootstrap" {
  name                     = "bootstrap${lower(random_id.storage_account.hex)}"
  resource_group_name      = "${azurerm_resource_group.resourcegroup.name}"
  location                 = "${azurerm_resource_group.resourcegroup.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}