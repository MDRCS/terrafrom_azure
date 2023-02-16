# AWS VPC
resource "azurerm_virtual_network" "demo" {
    name = "${var.prefix}-network"
    location = var.location
    resource_group_name = azurerm_resource_group.network-security-group-demo.name
    address_space = ["10.0.0.0/16"] # /16 give us 64534 possible ip addresses
    # ref : https://www.aelius.com/njh/subnet_sheet.html
}

resource "azurerm_subnet" "demo-internal-1" {
    name = "${var.prefix}-internal-1"
    resource_group_name = azurerm_resource_group.network-security-group-demo.name
    virtual_network_name = azurerm_virtual_network.demo.name
    address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "allow-ssh" {
    name = "${var.prefix}-allow-ssh"
    location = var.location
    resource_group_name = azurerm_resource_group.network-security-group-demo.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.ssh-source-address
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_security_group" "internet-facing" {
    name = "${var.prefix}-internet-facing"
    location = var.location
    resource_group_name = azurerm_resource_group.network-security-group-demo.name

    security_rule {
        name = "test-rule"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "80"
        source_application_security_group_ids = [azurerm_application_security_group.demo-instance-group.id]
        destination_address_prefix = "*"
    }

    security_rule {
        name = "test-rule-deny"
        priority = 1002
        direction = "Inbound"
        access = "Deny"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}