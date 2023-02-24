locals {
  prefix-hub-nva         = "hub-nva"
  hub-nva-location       = "eastus"
  hub-nva-resource-group = "hub-nva-rg"
}

resource "azurerm_resource_group" "hub-nva-rg" {
  name     = "${local.prefix-hub-nva}-rg"
  location = local.hub-nva-location

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_public_ip" "hub-public-ip" {
  name                = "${local.prefix-hub-nva}-public-ip"
  location            = azurerm_resource_group.hub-nva-rg.location
  resource_group_name = azurerm_resource_group.hub-nva-rg.name

  allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "hub-nva-nic" {
  name                 = "${local.prefix-hub-nva}-nic"
  location             = azurerm_resource_group.hub-nva-rg.location
  resource_group_name  = azurerm_resource_group.hub-nva-rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.prefix-hub-nva
    subnet_id                     = azurerm_subnet.hub-dmz.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.36"
    public_ip_address_id          = azurerm_public_ip.hub-public-ip.id
  }

  tags = {
    environment = local.prefix-hub-nva
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "hub-nsg" {
  name                = "${local.prefix-hub-nva}-nsg"
  location            = azurerm_resource_group.hub-nva-rg.location
  resource_group_name = azurerm_resource_group.hub-nva-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = data.external.my_ip.result.ip
    destination_address_prefix = "*"
  }

  # Allow Outbound Access from Hub and Spoke Network to my laptop IP Address
  security_rule {
    name                       = "Conn"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = data.external.my_ip.result.ip
  }

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_subnet_network_security_group_association" "mgmt-nsg-association" {
  subnet_id                 = azurerm_subnet.hub-mgmt.id
  network_security_group_id = azurerm_network_security_group.hub-nsg.id
}

resource "azurerm_virtual_machine" "hub-nva-vm" {
  name                  = "${local.prefix-hub-nva}-vm"
  location              = azurerm_resource_group.hub-nva-rg.location
  resource_group_name   = azurerm_resource_group.hub-nva-rg.name
  network_interface_ids = [azurerm_network_interface.hub-nva-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix-hub-nva}-vm"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_virtual_machine_extension" "enable-routes" {
  name                 = "enable-iptables-routes"
  virtual_machine_id   = azurerm_virtual_machine.hub-nva-vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"


  settings = <<SETTINGS
    {
        "fileUris": [
        "https://raw.githubusercontent.com/mspnp/reference-architectures/master/scripts/linux/enable-ip-forwarding.sh"
        ],
        "commandToExecute": "bash enable-ip-forwarding.sh"
    }
SETTINGS

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_route_table" "hub-gateway-rt" {
  name                          = "hub-gateway-rt"
  location                      = azurerm_resource_group.hub-nva-rg.location
  resource_group_name           = azurerm_resource_group.hub-nva-rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "toHub"
    address_prefix = "10.0.0.0/16"
    next_hop_type  = "VnetLocal"
  }

  route {
    name                   = "toSpoke1"
    address_prefix         = "10.1.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.2.36"
  }

  route {
    name                   = "toSpoke2"
    address_prefix         = "10.2.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.2.36"
  }

  route {
    name           = "default"
    address_prefix = "0.0.0.0/1"
    next_hop_type  = "Internet" # To Allow Hub to communicate with outside resources
  }

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_subnet_route_table_association" "hub-gateway-rt-hub-vnet-gateway-subnet" {
  subnet_id      = azurerm_subnet.hub-gateway-subnet.id
  route_table_id = azurerm_route_table.hub-gateway-rt.id
  depends_on     = [azurerm_subnet.hub-gateway-subnet]
}

resource "azurerm_route_table" "spoke1-rt" {
  name                          = "spoke1-rt"
  location                      = azurerm_resource_group.hub-nva-rg.location
  resource_group_name           = azurerm_resource_group.hub-nva-rg.name
  disable_bgp_route_propagation = false

  route {
    name                   = "toSpoke2"
    address_prefix         = "10.2.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.2.36"
  }

  route {
    name           = "default"
    address_prefix = "0.0.0.0/1"
    next_hop_type  = "Internet" # To Allow Spoke 1 to communicate with outside resources
  }

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_subnet_route_table_association" "spoke1-rt-spoke1-vnet-mgmt" {
  subnet_id      = azurerm_subnet.spoke1-mgmt.id
  route_table_id = azurerm_route_table.spoke1-rt.id
  depends_on     = [azurerm_subnet.spoke1-mgmt]
}

resource "azurerm_subnet_route_table_association" "spoke1-rt-spoke1-vnet-workload" {
  subnet_id      = azurerm_subnet.spoke1-workload.id
  route_table_id = azurerm_route_table.spoke1-rt.id
  depends_on     = [azurerm_subnet.spoke1-workload]
}

resource "azurerm_route_table" "spoke2-rt" {
  name                          = "spoke2-rt"
  location                      = azurerm_resource_group.hub-nva-rg.location
  resource_group_name           = azurerm_resource_group.hub-nva-rg.name
  disable_bgp_route_propagation = false

  route {
    name                   = "toSpoke1"
    address_prefix         = "10.1.0.0/16"
    next_hop_in_ip_address = "10.0.2.36"
    next_hop_type          = "VirtualAppliance"
  }

  route {
    name           = "default"
    address_prefix = "0.0.0.0/1"
    next_hop_type  = "Internet" # To Allow Spoke 2 to communicate with outside resources
  }

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_subnet_route_table_association" "spoke2-rt-spoke2-vnet-mgmt" {
  subnet_id      = azurerm_subnet.spoke2-mgmt.id
  route_table_id = azurerm_route_table.spoke2-rt.id
  depends_on     = [azurerm_subnet.spoke2-mgmt]
}

resource "azurerm_subnet_route_table_association" "spoke2-rt-spoke2-vnet-workload" {
  subnet_id      = azurerm_subnet.spoke2-workload.id
  route_table_id = azurerm_route_table.spoke2-rt.id
  depends_on     = [azurerm_subnet.spoke2-workload]
}