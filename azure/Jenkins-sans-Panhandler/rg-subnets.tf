//# ********** RESOURCE GROUP **********
//
//# Create a resource group

resource "azurerm_resource_group" "resourcegroup" {
	name		= "${var.RG_Name}"
	location	= "${var.Azure_Region}"
}
