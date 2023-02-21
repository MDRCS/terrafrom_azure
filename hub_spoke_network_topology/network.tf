# Define Hub Vnet
resource "azurerm_virtual_network" "vnet_hub" {
  name                = "${local.org}-hub"
  location            = local.location
  resource_group_name = azurerm_resource_group.hub_spoke.name
  address_space       = ["10.0.0.0/16"]
  depends_on          = [azurerm_resource_group.hub_spoke]
}

# Define Spoke A Vnet
resource "azurerm_virtual_network" "vnet_spoke_a" {
  name                = "${local.org}-spoke-a"
  location            = local.location
  resource_group_name = azurerm_resource_group.hub_spoke.name
  address_space       = ["10.1.0.0/16"]
  depends_on          = [azurerm_resource_group.hub_spoke]
}

# Define Spoke B Vnet
resource "azurerm_virtual_network" "vnet_spoke_b" {
  name                = "${local.org}-spoke-b"
  location            = local.location
  resource_group_name = azurerm_resource_group.hub_spoke.name
  address_space       = ["10.2.0.0/16"]
  depends_on          = [azurerm_resource_group.hub_spoke]
}

# terraform apply -auto-approve -var-file=values.tfvars

resource "azurerm_subnet" "hub_gw" {
  name                                      = "GatewaySubnet"
  resource_group_name                       = azurerm_resource_group.hub_spoke.name
  virtual_network_name                      = azurerm_virtual_network.vnet_hub.name
  address_prefixes                          = ["10.0.1.0/24"]
  private_endpoint_network_policies_enabled = true
  depends_on                                = [azurerm_resource_group.hub_spoke]
}

resource "azurerm_subnet" "hub_firewall" {
  name                                      = "AzureFirewallSubnet"
  resource_group_name                       = azurerm_resource_group.hub_spoke.name
  virtual_network_name                      = azurerm_virtual_network.vnet_hub.name
  address_prefixes                          = ["10.0.2.0/24"]
  private_endpoint_network_policies_enabled = true
  depends_on                                = [azurerm_resource_group.hub_spoke]
}

resource "azurerm_subnet" "hub_firewall_mgmt" {
  name                                      = "AzureFirewallManagementSubnet"
  resource_group_name                       = azurerm_resource_group.hub_spoke.name
  virtual_network_name                      = azurerm_virtual_network.vnet_hub.name
  address_prefixes                          = ["10.0.3.0/24"]
  private_endpoint_network_policies_enabled = true
  depends_on                                = [azurerm_resource_group.hub_spoke]
}

resource "azurerm_subnet" "hub_jumphost" {
  name                                      = "jump"
  resource_group_name                       = azurerm_resource_group.hub_spoke.name
  virtual_network_name                      = azurerm_virtual_network.vnet_hub.name
  address_prefixes                          = ["10.0.4.0/24"]
  private_endpoint_network_policies_enabled = true
  depends_on                                = [azurerm_resource_group.hub_spoke]
}

# Spokes Subnets 
resource "azurerm_subnet" "spoke_a_subnet" {
  name                                      = "SpokeASubnet"
  resource_group_name                       = azurerm_resource_group.hub_spoke.name
  virtual_network_name                      = azurerm_virtual_network.vnet_spoke_a.name
  address_prefixes                          = ["10.1.1.0/24"]
  private_endpoint_network_policies_enabled = true
  depends_on                                = [azurerm_resource_group.hub_spoke]
}

resource "azurerm_subnet" "spoke_b_subnet" {
  name                                      = "SpokeBSubnet"
  resource_group_name                       = azurerm_resource_group.hub_spoke.name
  virtual_network_name                      = azurerm_virtual_network.vnet_spoke_b.name
  address_prefixes                          = ["10.2.1.0/24"]
  private_endpoint_network_policies_enabled = true
  depends_on                                = [azurerm_resource_group.hub_spoke]
}

# Create peering between Vnets
resource "azurerm_virtual_network_peering" "hub_to_spoke_a" {
  name                         = "${local.org}-hub-to-${local.org}-spoke-a" # to refactor
  resource_group_name          = azurerm_resource_group.hub_spoke.name
  virtual_network_name         = azurerm_virtual_network.vnet_hub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_spoke_a.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "spoke_a_to_hub" {
  name                         = "${local.org}-spoke-a-to-${local.org}-spoke-b" # to refactor
  resource_group_name          = azurerm_resource_group.hub_spoke.name
  virtual_network_name         = azurerm_virtual_network.vnet_spoke_a.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_spoke_b.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub_to_spoke_b" {
  name                         = "${local.org}-hub-to-${local.org}-spoke-b" # to refactor
  resource_group_name          = azurerm_resource_group.hub_spoke.name
  virtual_network_name         = azurerm_virtual_network.vnet_hub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_spoke_b.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "spoke_b_to_hub" {
  name                         = "${local.org}-spoke-b-to-${local.org}-hub" # to refactor
  resource_group_name          = azurerm_resource_group.hub_spoke.name
  virtual_network_name         = azurerm_virtual_network.vnet_spoke_b.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}