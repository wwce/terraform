resource "azurerm_network_security_group" "main" {
  name                = "${var.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface" "main" {
  count                     = var.vm_count
  name                      ="${var.name}${count.index + 1}-nic0"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  #network_security_group_id = azurerm_network_security_group.main.id

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "dynamic"
    #load_balancer_backend_address_pools_ids = var.backend_pool_ids
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  count                     = var.vm_count
  network_interface_id      = element(azurerm_network_interface.main.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.main.id
  depends_on = [
    azurerm_virtual_machine.main
  ]
}



resource "azurerm_virtual_machine" "main" {
  count                            = var.vm_count
  name                             ="${var.name}${count.index + 1}"
  location                         = var.location
  resource_group_name              = var.resource_group_name
  network_interface_ids            = [element(azurerm_network_interface.main.*.id, count.index)]
  vm_size                          = "Standard_B1s"
  availability_set_id              = var.availability_set_id
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.name}${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.name}${count.index + 1}"
    admin_username = var.username
    admin_password = var.password
    custom_data    = var.custom_data
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = var.tags
  depends_on = [
    azurerm_network_interface.main
  ]
}

# resource "azurerm_network_interface_backend_address_pool_association" "main" {
#   count                   = length(var.backend_pool_id) != 0 ? var.vm_count : 0
#   network_interface_id    = element(azurerm_network_interface.main.*.id, count.index)
#   ip_configuration_name   = "ipconfig1"
#   backend_address_pool_id = element(var.backend_pool_id, 0)

#   depends_on = [
#     azurerm_virtual_machine.main
#   ]
# }