//# ********** RESOURCE GROUP **********
//# Configure the Providers
provider "azurerm" {}
provider "random" {}

//# Create a resource group
resource "azurerm_resource_group" "resourcegroup" {
	name		= "${var.virtualMachineRG}"
	location	= "${var.Location}"
}