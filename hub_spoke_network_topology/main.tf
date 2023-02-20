# # Define the provider
# provider "azurerm" {
#   features {}
# }

# # Define the resource group for the hub and spokes
# resource "azurerm_resource_group" "hub_and_spokes_rg" {
#   name     = "hub-and-spokes-rg"
#   location = "eastus"
# }

# #############################

# # Define the hub virtual network and its resources
# resource "azurerm_virtual_network" "hub_vnet" {
#   name                = "hub-vnet"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.hub_and_spokes_rg.location
#   resource_group_name = azurerm_resource_group.hub_and_spokes_rg.name

#   subnet {
#     name           = "hub-subnet"
#     address_prefix = "10.0.1.0/24"
#   }

#   # Define the hub virtual network gateway and its resources
#   resource "azurerm_virtual_network_gateway" "hub_gateway" {
#     name                = "hub-gateway"
#     location            = azurerm_resource_group.hub_and_spokes_rg.location
#     resource_group_name = azurerm_resource_group.hub_and_spokes_rg.name
#     type                = "Vpn"
#     vpn_type            = "RouteBased"
#     sku                 = "VpnGw1"
#     active_active       = false

#     ip_configuration {
#       name                          = "gw-ip-config"
#       subnet_id                     = azurerm_virtual_network.hub_vnet.subnet_id
#       private_ip_address_allocation = "Dynamic"
#     }
#   }
# }

# # Define the spoke virtual networks and their resources
# resource "azurerm_virtual_network" "spoke1_vnet" {
#   name                = "spoke1-vnet"
#   address_space       = ["10.1.0.0/16"]
#   location            = azurerm_resource_group.hub_and_spokes_rg.location
#   resource_group_name = "spoke1-rg"

#   subnet {
#     name           = "spoke1-subnet"
#     address_prefix = "10.1.1.0/24"
#   }
# }

# resource "azurerm_virtual_network" "spoke2_vnet" {
#   name                = "spoke2-vnet"
#   address_space       = ["10.2.0.0/16"]
#   location            = azurerm_resource_group.hub_and_spokes_rg.location
#   resource_group_name = "spoke2-rg"

#   subnet {
#     name           = "spoke2-subnet"
#     address_prefix = "10.2.1.0/24"
#   }
# }

# # Define the virtual network gateways for the spokes
# resource "azurerm_virtual_network_gateway" "spoke1_gateway" {
#   name                = "spoke1-gateway"
#   location            = azurerm_virtual_network.spoke1_vnet.location
#   resource_group_name = "spoke1-rg"
#   type                = "Vpn"
#   vpn_type            = "RouteBased"
#   sku                 = "VpnGw1"
#   active_active       = false

#   ip_configuration {
#     name                          = "gw-ip-config"
#     subnet_id                     = azurerm_virtual_network.spoke1_vnet.subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_virtual_network_gateway" "spoke2_gateway" {
#   name                = "spoke2-gateway"
#   location            = azurerm_virtual_network.spoke2_vnet.location
#   resource_group_name = "spoke2-rg"
#   type                = "Vpn"
#   vpn_type            = "RouteBased"
#   sku                 = "VpnGw1"
#   active_active       = false

#   ip_configuration {
#     name                          = "gw-ip-config"
#     subnet_id                     = azurerm_virtual_network.spoke2_vnet.subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_virtual_network_gateway_connection" "hub_spoke1_connection" {
#   name                               = "hub-spoke1-connection"
#   location                           = azurerm_resource_group.hub_and_spokes_rg.location
#   resource_group_name                = azurerm_resource_group.hub_and_spokes_rg.name
#   virtual_network_gateway_id         = azurerm_virtual_network_gateway.hub_gateway.id
#   remote_virtual_network_id          = azurerm_virtual_network.spoke1_vnet.id
#   connection_type                    = "IPsec"
#   routing_weight                     = 10
#   shared_key                         = "yoursharedkey"
#   enable_bgp                         = false
#   use_policy_based_traffic_selectors = false
# }

# resource "azurerm_virtual_network_gateway_connection" "hub_spoke2_connection" {
#   name                               = "hub-spoke2-connection"
#   location                           = azurerm_resource_group.hub_and_spokes_rg.location
#   resource_group_name                = azurerm_resource_group.hub_and_spokes_rg.name
#   virtual_network_gateway_id         = azurerm_virtual_network_gateway.hub_gateway.id
#   remote_virtual_network_id          = azurerm_virtual_network.spoke2_vnet.id
#   connection_type                    = "IPsec"
#   routing_weight                     = 10
#   shared_key                         = "yoursharedkey"
#   enable_bgp                         = false
#   use_policy_based_traffic_selectors = false
# }

# # address_prefix = "10.0.2.0/24"
# # }

# resource "azurerm_subnet" "spoke2_subnet" {
#   name                 = "spoke2-subnet"
#   resource_group_name  = "spoke2-rg"
#   virtual_network_name = "spoke2-vnet"
#   address_prefix       = "10.0.3.0/24"
# }

# resource "azurerm_virtual_network_gateway" "spoke1_gateway" {
#   name                = "spoke1-gateway"
#   location            = azurerm_virtual_network.spoke1_vnet.location
#   resource_group_name = "spoke1-rg"
#   type                = "Vpn"
#   vpn_type            = "RouteBased"
#   sku                 = "VpnGw1"
#   active_active       = false

#   ip_configuration {
#     name                          = "gw-ip-config"
#     subnet_id                     = azurerm_virtual_network.spoke1_vnet.subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_virtual_network_gateway" "spoke2_gateway" {
#   name                = "spoke2-gateway"
#   location            = azurerm_virtual_network.spoke2_vnet.location
#   resource_group_name = "spoke2-rg"
#   type                = "Vpn"
#   vpn_type            = "RouteBased"
#   sku                 = "VpnGw1"
#   active_active       = false

#   ip_configuration {
#     name                          = "gw-ip-config"
#     subnet_id                     = azurerm_virtual_network.spoke2_vnet.subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_virtual_network_gateway_connection" "hub_spoke1_connection" {
#   name                               = "hub-spoke1-connection"
#   location                           = azurerm_resource_group.hub_and_spokes_rg.location
#   resource_group_name                = azurerm_resource_group.hub_and_spokes_rg.name
#   virtual_network_gateway_id         = azurerm_virtual_network_gateway.hub_gateway.id
#   remote_virtual_network_id          = azurerm_virtual_network.spoke1_vnet.id
#   connection_type                    = "IPsec"
#   routing_weight                     = 10
#   shared_key                         = "yoursharedkey"
#   enable_bgp                         = false
#   use_policy_based_traffic_selectors = false
# }

# resource "azurerm_virtual_network_gateway_connection" "hub_spoke2_connection" {
#   name                               = "hub-spoke2-connection"
#   location                           = azurerm_resource_group.hub_and_spokes_rg.location
#   resource_group_name                = azurerm_resource_group.hub_and_spokes_rg.name
#   virtual_network_gateway_id         = azurerm_virtual_network_gateway.hub_gateway.id
#   remote_virtual_network_id          = azurerm_virtual_network.spoke2_vnet.id
#   connection_type                    = "IPsec"
#   routing_weight                     = 10
#   shared_key                         = "yoursharedkey"
#   enable_bgp                         = false
#   use_policy_based_traffic_selectors = false
# }

# resource "azurerm_network_security_group" "hub_nsg" {
#   name                = "hub-nsg"
#   location            = azurerm_resource_group.hub_and_spokes_rg.location
#   resource_group_name = azurerm_resource_group.hub_and_spokes_rg.name
# }

# resource "azurerm_network_security_group" "spoke1" {
#   name                = "spoke1-nsg"
#   location            = azurerm_resource_group.spoke1_rg.location
#   resource_group_name = azurerm_resource_group.spoke1_rg.name
# }

# resource "azurerm_network_security_group" "spoke2_nsg" {
#   name                = "spoke2-nsg"
#   location            = azurerm_resource_group.spoke2_rg.location
#   resource_group_name = azurerm_resource_group.spoke2_rg.name
# }

# resource "azurerm_network_security_rule" "hub_nsg_inbound_rule" {
#   name                        = "hub-nsg-inbound-rule"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = ""
#   source_port_range           = ""
#   destination_port_range      = ""
#   source_address_prefixes     = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
#   destination_address_prefix  = ""
#   resource_group_name         = azurerm_resource_group.hub_and_spokes_rg.name
#   network_security_group_name = azurerm_network_security_group.hub_nsg.name
# }

# resource "azurerm_network_security_rule" "hub_nsg_outbound_rule" {
#   name                        = "hub-nsg-outbound-rule"
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = ""
#   source_port_range           = ""
#   destination_port_range      = ""
#   source_address_prefixes     = [""]
#   destination_address_prefix  = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
#   resource_group_name         = azurerm_resource_group.hub_and_spokes_rg.name
#   network_security_group_name = azurerm_network_security_group.hub_nsg.name
# }

# resource "azurerm_network_security_rule" "spoke1_nsg_inbound_rule" {
#   name                        = "spoke1-nsg-inbound-rule"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = ""
#   source_port_range           = ""
#   destination_port_range      = ""
#   source_address_prefixes     = ["10.0.1.0/24"]
#   destination_address_prefix  = ""
#   resource_group_name         = azurerm_resource_group.spoke1_rg.name
#   network_security_group_name = azurerm_network_security_group.spoke1_nsg.name
# }

# resource "azurerm_network_security_rule" "spoke1_nsg_outbound_rule" {
#   name                        = "spoke1-nsg-outbound-rule"
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = ""
#   source_port_range           = ""
#   destination_port_range      = "*"
#   source_address_prefixes     = ["10.0.1.0/24"]
#   destination_address_prefix  = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
#   resource_group_name         = azurerm_resource_group.spoke1_rg.name
#   network_security_group_name = azurerm_network_security_group.spoke1_nsg.name
# }

# resource "azurerm_network_security_rule" "spoke2_nsg_inbound_rule" {
#   name                        = "spoke2-nsg-inbound-rule"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = ""
#   source_port_range           = ""
#   destination_port_range      = ""
#   source_address_prefixes     = ["10.0.2.0/24"]
#   destination_address_prefix  = ""
#   resource_group_name         = azurerm_resource_group.spoke2_rg.name
#   network_security_group_name = azurerm_network_security_group.spoke2_nsg.name
# }

# resource "azurerm_network_security_rule" "spoke2_nsg_outbound_rule" {
#   name                        = "spoke2-nsg-outbound-rule"
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = ""
#   source_port_range           = ""
#   destination_port_range      = "*"
#   source_address_prefixes     = ["10.0.2.0/24"]
#   destination_address_prefix  = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
#   resource_group_name         = azurerm_resource_group.spoke2_rg.name
#   network_security_group_name = azurerm_network_security_group.spoke2_nsg.name
# }

# # Define the virtual network peering between the hub and spokes
# resource "azurerm_virtual_network_peering" "hub_to_spoke1" {
#   name                         = "hub-to-spoke1"
#   resource_group_name          = azurerm_resource_group.hub_and_spokes_rg.name
#   virtual_network_name         = azurerm_virtual_network.hub_vnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.spoke1_vnet.id
#   allow_virtual_network_access = true
# }

# resource "azurerm_virtual_network_peering" "hub_to_spoke2" {
#   name                         = "hub-to-spoke2"
#   resource_group_name          = azurerm_resource_group.hub_and_spokes_rg.name
#   virtual_network_name         = azurerm_virtual_network.hub_vnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.spoke2_vnet.id
#   allow_virtual_network_access = true
# }

# resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
#   name                         = "spoke1-to-hub"
#   resource_group_name          = azurerm_resource_group.spoke1_rg.name
#   virtual_network_name         = azurerm_virtual_network.spoke1_vnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.hub_vnet.id
#   allow_virtual_network_access = true
# }

# resource "azurerm_virtual_network_peering" "spoke2_to_hub" {
#   name                         = "spoke2-to-hub"
#   resource_group_name          = azurerm_resource_group.spoke2_rg.name
#   virtual_network_name         = azurerm_virtual_network.spoke2_vnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.hub_vnet.id
#   allow_virtual_network_access = true
# }

# resource "azurerm_subnet" "hub_subnet" {
#   name                 = "hub-subnet"
#   resource_group_name  = azurerm_resource_group.hub_and_spokes_rg.name
#   virtual_network_name = azurerm_virtual_network.hub_vnet.name
#   address_prefixes     = ["10.0.0.0"] # ?
#   subnet_prefix_length = 24
# }

# resource "azurerm_subnet" "spoke1_subnet" {
#   name                 = "spoke1-subnet"
#   resource_group_name  = azurerm_resource_group.spoke1_rg.name
#   virtual_network_name = azurerm_virtual_network.spoke1_vnet.name
#   address_prefixes     = ["10.0.1.0/24"]
#   subnet_prefix_length = 24
# }

# resource "azurerm_subnet" "spoke2_subnet" {
#   name                 = "spoke2-subnet"
#   resource_group_name  = azurerm_resource_group.spoke2_rg.name
#   virtual_network_name = azurerm_virtual_network.spoke2_vnet.name
#   address_prefixes     = ["10.0.2.0/24"]
#   subnet_prefix_length = 24
# }

# # Define the network interface cards for each VM
# resource "azurerm_network_interface" "hub_nic" {
#   name                      = "hub-nic"
#   location                  = azurerm_resource_group.hub_and_spokes_rg.location
#   resource_group_name       = azurerm_resource_group.hub_and_spokes_rg.name
#   network_security_group_id = azurerm_network_security_group.hub_nsg.id

#   ip_configuration {
#     name                          = "hub-nic-ip"
#     subnet_id                     = azurerm_subnet.hub_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_network_interface" "spoke1_nic" {
#   name                      = "spoke1-nic"
#   location                  = azurerm_resource_group.spoke1_rg.location
#   resource_group_name       = azurerm_resource_group.spoke1_rg.name
#   network_security_group_id = azurerm_network_security_group.spoke1_nsg.id

#   ip_configuration {
#     name                          = "spoke1-nic-ip"
#     subnet_id                     = azurerm_subnet.spoke1_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_network_interface" "spoke2_nic" {
#   name                      = "spoke2-nic"
#   location                  = azurerm_resource_group.spoke2_rg.location
#   resource_group_name       = azurerm_resource_group.spoke2_rg.name
#   network_security_group_id = azurerm_network_security_group.spoke2_nsg.id

#   ip_configuration {
#     name                          = "spoke2-nic-ip"
#     subnet_id                     = azurerm_subnet.spoke2_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# # Define the virtual machines for each subnet
# resource "azurerm_linux_virtual_machine" "hub_vm" {
#   name                  = "hub-vm"
#   location              = azurerm_resource_group.hub_and_spokes_rg.location
#   resource_group_name   = azurerm_resource_group.hub_and_spokes_rg.name
#   network_interface_ids = [azurerm_network_interface.hub_nic.id]
#   size                  = "Standard_B1ls"
#   admin_username        = "adminuser"
#   admin_password        = "AdminPassword123!"

#   os_disk {
#     name                 = "hub-os-disk"
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   boot_diagnostics {
#     storage_account_uri = azurerm_storage_account.bootdiag_sa.primary_blob_endpoint
#   }
# }