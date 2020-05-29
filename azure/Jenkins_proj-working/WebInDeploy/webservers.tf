data "template_file" "cloudconfig" {
  
  template = "${file("${path.root}${var.Web_Initscript_Path}")}"
}
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content = "${data.template_file.cloudconfig.rendered}"
  }
}

resource "azurerm_virtual_machine" "webserver" {
  name                  = "webserver"
  location              = "${data.azurerm_resource_group.resourcegroup.location}"
  resource_group_name   = "${data.azurerm_resource_group.resourcegroup.name}"
  vm_size               = "Standard_A3"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "web-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "webserver"
    admin_username = "${var.Admin_Username}"
    admin_password = "${var.Admin_Password}"
    custom_data    = "${data.template_cloudinit_config.config.rendered}"
  }

  network_interface_ids = ["${azurerm_network_interface.web1.id}"]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}