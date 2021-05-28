#-----------------------------------------------------------------------------------------------------------------
# Create NSGs for firewall dataplane interfaces (required for Standard SKU LB)
resource "azurerm_network_security_group" "mgmt" {
  name                = "${var.name}-nsg-mgmt"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "mgmt-inbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "22"]
    source_address_prefix      = var.nsg_prefix
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "data" {
  name                = "${var.name}-nsg-data"
  location            = var.location
  resource_group_name = var.resource_group_name

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
  count               = var.nic0_public_ip ? var.vm_count : 0
  name                = "${var.name}${count.index + 1}-nic0-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_address_allocation
  sku                 = var.sku
}

resource "azurerm_public_ip" "nic1" {
  count               = var.nic1_public_ip ? var.vm_count : 0
  name                = "${var.name}${count.index + 1}-nic1-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_address_allocation
  sku                 = var.sku
}

resource "azurerm_public_ip" "nic2" {
  count               = var.nic2_public_ip ? var.vm_count : 0
  name                = "${var.name}${count.index + 1}-nic2-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_address_allocation
  sku                 = var.sku
}

#-----------------------------------------------------------------------------------------------------------------
# Create firewall interfaces (mgmt, data1, data2).  Dynamic interface is created first, then IP is set statically.

resource "azurerm_network_interface" "nic0" {
  count                     = var.vm_count
  name                      = "${var.name}${count.index + 1}-nic0"
  location                  = var.location
  resource_group_name       = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_mgmt
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.nic0_public_ip ? element(concat(azurerm_public_ip.nic0.*.id, [""]), count.index) : ""

  }
}

resource "azurerm_network_interface" "nic1" {
  count                     = var.vm_count
  name                      = "${var.name}${count.index + 1}-nic1"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  enable_ip_forwarding      = true

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = var.subnet_untrust
    private_ip_address_allocation           = "Dynamic"
    public_ip_address_id                    = var.nic1_public_ip ? element(concat(azurerm_public_ip.nic1.*.id, [""]), count.index) : ""
  }
}

resource "azurerm_network_interface" "nic2" {
  count                     = var.vm_count
  name                      = "${var.name}${count.index + 1}-nic2"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  enable_ip_forwarding      = true

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = var.subnet_trust
    private_ip_address_allocation           = "Dynamic"
    public_ip_address_id                    = var.nic2_public_ip ? element(concat(azurerm_public_ip.nic2.*.id, [""]), count.index) : ""
  }
}

resource "azurerm_network_interface_security_group_association" "nic0" {
  count                     = var.vm_count
  network_interface_id      = element(azurerm_network_interface.nic0.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.mgmt.id
}

resource "azurerm_network_interface_security_group_association" "nic1" {
  count                     = var.vm_count
  network_interface_id      = element(azurerm_network_interface.nic1.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.data.id
}

resource "azurerm_network_interface_security_group_association" "nic2" {
  count                     = var.vm_count
  network_interface_id      = element(azurerm_network_interface.nic2.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.data.id
}


#-----------------------------------------------------------------------------------------------------------------
# Create VM-Series NGFWs
resource "azurerm_availability_set" "default" {
  name                        = var.avset_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  platform_fault_domain_count = var.avset_fault_domain_count
  managed                     = true
}

resource "azurerm_virtual_machine" "vmseries" {
  count                        = var.vm_count
  name                         = "${var.name}${count.index + 1}"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  vm_size                      = var.size
  primary_network_interface_id = element(azurerm_network_interface.nic0.*.id, count.index)

  network_interface_ids = [
    element(azurerm_network_interface.nic0.*.id, count.index),
    element(azurerm_network_interface.nic1.*.id, count.index),
    element(azurerm_network_interface.nic2.*.id, count.index),
  ]

  availability_set_id = azurerm_availability_set.default.id

  os_profile_linux_config {
    disable_password_authentication = false
  }

  plan {
    name      = var.license
    publisher = "paloaltonetworks"
    product   = "vmseries-flex"
  }

  storage_image_reference {
    publisher = "paloaltonetworks"
    offer     = "vmseries-flex"
    sku       = var.license
    version   = var.panos
  }

  storage_os_disk {
    name              = "${var.name}${count.index + 1}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.name}${count.index + 1}"
    admin_username = var.username
    admin_password = var.password
    custom_data = join(
      ",",
      [
        "storage-account=${var.bootstrap_storage_account}",
        "access-key=${var.bootstrap_access_key}",
        "file-share=${var.bootstrap_file_share}",
        "share-directory=${var.bootstrap_share_directory}",
      ],
    )
  }
}