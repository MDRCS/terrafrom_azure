data "external" "my_ip" {
  program = ["curl", "https://api.ipify.org?format=json"]
}

data "azurerm_subnet" "hub_gw" {
  name              = "GatewaySubnet"
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  resource_group_name  = azurerm_resource_group.hub_spoke.name
}

data "azurerm_subnet" "hub_jumphost" {
  name                  = "jump"
  virtual_network_name  = azurerm_virtual_network.vnet_hub.name
  resource_group_name   = azurerm_resource_group.hub_spoke.name
}

data "azurerm_subnet" "spoke_a_subnet" {
  name                  = "SpokeASubnet"
  virtual_network_name  = azurerm_virtual_network.vnet_spoke_a.name
  resource_group_name   = azurerm_resource_group.hub_spoke.name
}

data "azurerm_subnet" "spoke_b_subnet" {
  name                  = "SpokeBSubnet"
  virtual_network_name  = azurerm_virtual_network.vnet_spoke_b.name
  resource_group_name   = azurerm_resource_group.hub_spoke.name
}
