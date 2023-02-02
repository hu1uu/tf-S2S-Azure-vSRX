# Network Security Group and Rules

resource "azurerm_network_security_group" "nsgcompute" {
  name                = "vm-core-test-centralus-000-nsg"
  location            = azurerm_resource_group.rgtestcore.location
  resource_group_name = azurerm_resource_group.rgtestcore.name

  security_rule {
    name                       = "SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = local.onpremise_addresses
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "ICMP-In"
    priority                   = 301
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = local.onpremise_addresses
    destination_address_prefix = "*"
  }

  
    security_rule {
    name                       = "ICMP-Out"
    priority                   = 301
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = local.onpremise_addresses
  }

  tags = local.common_tags
  }



# NIC for VM
resource "azurerm_network_interface" "nicforvm" {
  name                = "nic-${var.environment}-${var.azure_region}-${var.instance}"
  location            = azurerm_resource_group.rgtestcore.location
  resource_group_name = azurerm_resource_group.rgtestcore.name


  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet_compute.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Microsoft recommends applying an NSG to either interface or subnet, but not to both.
# Resource to assoicate NSG with NIC
# resource "azurerm_network_interface_security_group_association" "nsgniccoretest" {
#     network_interface_id = azurerm_network_interface.nicforvm.id
#     network_security_group_id = azurerm_network_security_group.nsgcompute.id
# }

# Resource to assoicate NSG with one of SNET
resource "azurerm_subnet_network_security_group_association" "nsgsnetcompute" {
  subnet_id                 = azurerm_subnet.snet_compute.id
  network_security_group_id = azurerm_network_security_group.nsgcompute.id
}

# Linux VM
resource "azurerm_linux_virtual_machine" "vmcoretest" {
  name                = "vm-core-test-centralus-000"
  computer_name       = "core-test-000"
  resource_group_name = azurerm_resource_group.rgtestcore.name
  location            = azurerm_resource_group.rgtestcore.location

  # az vm list-sizes --location "centralus" -o table
  size                  = "Standard_D2as_v5"
  admin_username        = local.admin_username
  network_interface_ids = [azurerm_network_interface.nicforvm.id]

  admin_ssh_key {
    username   = local.admin_username
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

  os_disk {
    name                 = "osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # az vm image list --location "centralus" -o table
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = local.common_tags

}