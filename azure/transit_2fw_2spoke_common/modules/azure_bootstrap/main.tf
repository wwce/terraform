

resource "random_string" "randomstring" {
  length      = 15
  min_lower   = 5
  min_numeric = 10
  special     = false
}

resource "azurerm_storage_share" "main" {
  name                 = "${var.name}${random_string.randomstring.result}"
  storage_account_name = var.storage_account_name
  quota                = var.quota
}

resource "null_resource" "upload" {
provisioner "local-exec" {
  command = <<EOT
az storage directory create --account-name ${var.storage_account_name} --account-key ${var.storage_account_key} --share-name ${azurerm_storage_share.main.name} --name config
az storage directory create --account-name ${var.storage_account_name} --account-key ${var.storage_account_key} --share-name ${azurerm_storage_share.main.name} --name content
az storage directory create --account-name ${var.storage_account_name} --account-key ${var.storage_account_key} --share-name ${azurerm_storage_share.main.name} --name license
az storage directory create --account-name ${var.storage_account_name} --account-key ${var.storage_account_key} --share-name ${azurerm_storage_share.main.name} --name software


az storage file upload-batch --account-name ${var.storage_account_name} --account-key ${var.storage_account_key} --destination ${azurerm_storage_share.main.name}/config  --source ${var.local_file_path}config
az storage file upload-batch --account-name ${var.storage_account_name} --account-key ${var.storage_account_key} --destination ${azurerm_storage_share.main.name}/content --source ${var.local_file_path}content
az storage file upload-batch --account-name ${var.storage_account_name} --account-key ${var.storage_account_key} --destination ${azurerm_storage_share.main.name}/license --source ${var.local_file_path}license
az storage file upload-batch --account-name ${var.storage_account_name} --account-key ${var.storage_account_key} --destination ${azurerm_storage_share.main.name}/software --source ${var.local_file_path}software


EOT
}
}

resource "null_resource" "dependency_setter" {
  depends_on = [
    azurerm_storage_share.main,
    null_resource.upload
  ]
}