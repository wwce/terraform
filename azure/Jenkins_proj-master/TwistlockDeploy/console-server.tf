data "template_file" "console" {
  
  template = "${file("${path.root}${var.console_Initscript_Path}")}"
}
data "template_cloudinit_config" "console" {
  gzip          = true
  base64_encode = true

  part {
    content = "${data.template_file.console.rendered}"
  }
}

resource "azurerm_virtual_machine" "console" {
  name                  = "console"
	location			        = "${azurerm_resource_group.consolegroup.location}"
	resource_group_name	  = "${azurerm_resource_group.consolegroup.name}"
  vm_size               = "Standard_A3"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "console-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "console"
    admin_username = "${var.Admin_Username}"
    admin_password = "${var.Admin_Password}"
    custom_data    = "${data.template_cloudinit_config.console.rendered}"
  }

  network_interface_ids = ["${azurerm_network_interface.console.id}"]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}