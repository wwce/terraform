#### CREATE THE FIREWALL ####

resource "azurerm_virtual_machine" "firewall" {
	name								= "firewall"
	location						= "${data.azurerm_resource_group.resourcegroup.location}"
	resource_group_name	= "${data.azurerm_resource_group.resourcegroup.name}"
	network_interface_ids =
	[
		"${azurerm_network_interface.fwmanagement.id}",
		"${azurerm_network_interface.fwuntrust.id}",
		"${azurerm_network_interface.fwtrust.id}"
	]

	primary_network_interface_id		= "${azurerm_network_interface.fwmanagement.id}"
	vm_size								= "Standard_D3_v2"

  plan {
    name = "bundle2"
    publisher = "paloaltonetworks"
    product = "vmseries1"
  }

	storage_image_reference	{
		publisher 	= "paloaltonetworks"
		offer		= "vmseries1"
		sku			= "bundle2"
		version		= "8.1.0"
	}

	storage_os_disk {
		name			= "firewall-disk"
		caching 		= "ReadWrite"
		create_option	= "FromImage"
    managed_disk_type = "Standard_LRS"
	}

	delete_os_disk_on_termination    = true
	delete_data_disks_on_termination = true

	os_profile 	{
		computer_name	= "pa-vm"
		admin_username	= "${var.Admin_Username}"
		admin_password	= "${var.Admin_Password}"
		custom_data = "storage-account=${var.Bootstrap_Storage_Account},access-key=${var.Storage_Account_Access_Key},file-share=${var.Storage_Account_Fileshare},share-directory=${var.Storage_Account_Fileshare_Directory}"
	}

	os_profile_linux_config {
    disable_password_authentication = false
  }
}