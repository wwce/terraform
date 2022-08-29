terraform {
  required_version = "~> 1.2"
}

provider "azurerm" {
  #version         = "= 1.41"  "~> 2.40.0"
#  subscription_id = var.subscription_id
#  client_id       = var.client_id
#  client_secret   = var.client_secret
#  tenant_id       = var.tenant_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
