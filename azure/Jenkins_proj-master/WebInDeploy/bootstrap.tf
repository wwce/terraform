resource "random_id" "storage_account" {
  byte_length = 8
}

resource "azurerm_storage_account" "jenkins" {
  name                     = "${lower(random_id.storage_account.hex)}"
  resource_group_name      = "${azurerm_resource_group.resourcegroup.name}"
  location                 = "${azurerm_resource_group.resourcegroup.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "bootstrap" {
  name = "bootstrap"
  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
  storage_account_name = "${azurerm_storage_account.jenkins.name}"
  quota = 1
}