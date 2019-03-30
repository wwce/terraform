data "template_file" "attacker" {
  
  template = "${file("${path.root}${var.Attack_Initscript_Path}")}"
}
data "template_cloudinit_config" "attacker" {
  gzip          = true
  base64_encode = true

  part {
    content = "${data.template_file.attacker.rendered}"
  }
}

resource "azurerm_virtual_machine" "attacker" {
  name                  = "attacker"
	location			        = "${azurerm_resource_group.attackgroup.location}"
	resource_group_name	  = "${azurerm_resource_group.attackgroup.name}"
  vm_size               = "Standard_A3"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "attacker-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "attacker"
    admin_username = "${var.Admin_Username}"
    admin_password = "${var.Admin_Password}"
    custom_data    = "${data.template_cloudinit_config.attacker.rendered}"
  }

  network_interface_ids = ["${azurerm_network_interface.attacker.id}"]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}