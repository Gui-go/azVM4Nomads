provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tfazrg" {
  name     = "${var.svc_name}-rg"
  location = var.rg_location
}

data "azurerm_key_vault_secret" "tfazkvsecret" {
  name         = var.key_vault_secret
  key_vault_id = "ABC"
}

resource "azurerm_virtual_network" "tfazvnet" {
  name                = "${var.svc_name}-vnet"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.tfazrg.location
  resource_group_name = azurerm_resource_group.tfazrg.name
}

resource "azurerm_subnet" "tfazsubnet" {
  name                 = "${var.svc_name}-snet"
  resource_group_name  = azurerm_resource_group.tfazrg.name
  address_prefixes     = var.subnet_address_prefix
  virtual_network_name = azurerm_virtual_network.tfazvnet.name
}

resource "azurerm_public_ip" "tfazpubip" {
  name                = "${var.svc_name}-pubip"
  location            = azurerm_resource_group.tfazrg.location
  resource_group_name = azurerm_resource_group.tfazrg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "tfaznic" {
  name                = "${var.svc_name}-ni"
  location            = azurerm_resource_group.tfazrg.location
  resource_group_name = azurerm_resource_group.tfazrg.name
  ip_configuration {
    name                          = "${var.svc_name}-intip"
    subnet_id                     = azurerm_subnet.tfazsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tfazpubip.id
  }
}

resource "azurerm_linux_virtual_machine" "tfazvmachine" {
  name                   = "${var.svc_name}-vm"
  location               = azurerm_resource_group.tfazrg.location
  resource_group_name    = azurerm_resource_group.tfazrg.name
  network_interface_ids  = [azurerm_network_interface.tfaznic.id]
  admin_username         = var.vm_admin_username
  admin_password         = data.azurerm_key_vault_secret.tfazkvsecret.value
  computer_name          = var.vm_computer_name
  disable_password_authentication = false
  size                   = var.vm_size
  os_disk {
    storage_account_type = var.vm_disk_type
    disk_size_gb         = var.vm_disk_size_gb
    caching              = "ReadWrite"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "tfaznsg" {
  name                = "my-nsg"
  location            = azurerm_resource_group.tfazrg.location
  resource_group_name = azurerm_resource_group.tfazrg.name
  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow-rdp"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-Outbound"
    priority                   = 500
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "deny-inbound"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "tfazninsg" {
  network_interface_id      = azurerm_network_interface.tfaznic.id
  network_security_group_id = azurerm_network_security_group.tfaznsg.id
}
