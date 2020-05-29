# Configure the Microsoft Azure Provider
provider "azurerm" {}

resource "random_id" "resource_group" {
  byte_length = 2
}

# ********** RESOURCE GROUP **********

# Create a resource group
resource "azurerm_resource_group" "resourcegroup" {
	name		= "${var.RG_Name}-${lower(random_id.resource_group.hex)}"
	location	= "${var.Azure_Region}"
}