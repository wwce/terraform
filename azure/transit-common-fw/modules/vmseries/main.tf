#-----------------------------------------------------------------------------------------------------------------
# Create NSGs for firewall dataplane interfaces (required for Standard SKU LB)
resource "azurerm_network_security_group" "mgmt" {
  name                = "${var.prefix}nsg-mgmt"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "mgmt-inbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "22"]
    source_address_prefix      = "${var.fw_nsg_prefix}"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "data" {
  name                = "${var.prefix}nsg-data"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "data-inbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "data-outbound"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#-----------------------------------------------------------------------------------------------------------------
# Create public IPs for firewall's management & dataplane1 interface
resource "azurerm_public_ip" "nic0" {
  count               = "${length(var.fw_names)}"
  name                = "${var.prefix}${var.fw_names[count.index]}-nic0-pip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "${var.public_ip_address_allocation}"
  sku                 = "${var.sku}"
}

resource "azurerm_public_ip" "nic1" {
  count               = "${length(var.fw_names)}"
  name                = "${var.prefix}${var.fw_names[count.index]}-nic1-pip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "${var.public_ip_address_allocation}"
  sku                 = "${var.sku}"
}

#-----------------------------------------------------------------------------------------------------------------
# Create firewall interfaces (mgmt, data1, data2).  Dynamic interface is created first, then IP is set statically.
resource "azurerm_network_interface" "nic0_dynamic" {
  count               = "${length(var.fw_names)}"
  name                = "${var.prefix}${var.fw_names[count.index]}-nic0"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${var.fw_subnet_mgmt}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic1_dynamic" {
  count               = "${length(var.fw_names)}"
  name                = "${var.prefix}${var.fw_names[count.index]}-nic1"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${var.fw_subnet_untrust}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic2_dynamic" {
  count               = "${length(var.fw_names)}"
  name                = "${var.prefix}${var.fw_names[count.index]}-nic2"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${var.fw_subnet_trust}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic0_static" {
  count                     = "${length(var.fw_names)}"
  name                      = "${var.prefix}${var.fw_names[count.index]}-nic0"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${azurerm_network_security_group.mgmt.id}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${var.fw_subnet_mgmt}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${azurerm_network_interface.nic0_dynamic.*.private_ip_address[count.index]}"
    public_ip_address_id          = "${element(azurerm_public_ip.nic0.*.id, count.index)}"
  }
}

resource "azurerm_network_interface" "nic1_static" {
  count                     = "${length(var.fw_names)}"
  name                      = "${var.prefix}${var.fw_names[count.index]}-nic1"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${azurerm_network_security_group.data.id}"
  enable_ip_forwarding      = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${var.fw_subnet_untrust}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${azurerm_network_interface.nic1_dynamic.*.private_ip_address[count.index]}"
    public_ip_address_id          = "${element(azurerm_public_ip.nic1.*.id, count.index)}"
  }
}

resource "azurerm_network_interface" "nic2_static" {
  count                     = "${length(var.fw_names)}"
  name                      = "${var.prefix}${var.fw_names[count.index]}-nic2"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${azurerm_network_security_group.data.id}"
  enable_ip_forwarding      = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${var.fw_subnet_trust}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${azurerm_network_interface.nic2_dynamic.*.private_ip_address[count.index]}"
  }
}

#-----------------------------------------------------------------------------------------------------------------
# Create VM-Series NGFWs
resource "azurerm_availability_set" "default" {
  name                = "${var.prefix}${var.fw_avset_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  managed             = true
}

resource "azurerm_virtual_machine" "vmseries" {
  count                        = "${length(var.fw_names)}"
  name                         = "${var.prefix}${var.fw_names[count.index]}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  vm_size                      = "${var.fw_size}"
  primary_network_interface_id = "${element(azurerm_network_interface.nic0_static.*.id, count.index)}"

  network_interface_ids = [
    "${element(azurerm_network_interface.nic0_static.*.id, count.index)}",
    "${element(azurerm_network_interface.nic1_static.*.id, count.index)}",
    "${element(azurerm_network_interface.nic2_static.*.id, count.index)}",
  ]

  availability_set_id = "${azurerm_availability_set.default.id}"

  os_profile_linux_config {
    disable_password_authentication = false
  }

  plan {
    name      = "${var.fw_license}"
    publisher = "paloaltonetworks"
    product   = "vmseries1"
  }

  storage_image_reference {
    publisher = "paloaltonetworks"
    offer     = "vmseries1"
    sku       = "${var.fw_license}"
    version   = "${var.fw_panos}"
  }

  storage_os_disk {
    name              = "${var.prefix}${var.fw_names[count.index]}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.prefix}${var.fw_names[count.index]}"
    admin_username = "${var.fw_username}"
    admin_password = "${var.fw_password}"
    custom_data    = "${join(",", list("storage-account=${var.fw_bootstrap_storage_account}", "access-key=${var.fw_bootstrap_access_key}", "file-share=${var.fw_bootstrap_file_share}", "share-directory=${var.fw_bootstrap_share_directory}"))}"
  }
}
