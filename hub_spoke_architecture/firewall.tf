locals {
  prefix    = "az-firewall"
  fw_name   = "tcm-labs-azfw"
  fw_policy = "tcm-labs-fw-policy"
  fw_location = "eastus"
}

resource "azurerm_firewall_policy" "fw_policy" {
  name                = local.fw_policy
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  location            = azurerm_resource_group.hub-vnet-rg.location
}

resource "azurerm_public_ip" "fw_ip" {
  name                = "${local.prefix}-fw-ip"
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "fw-mgmt-ip" {
  name                = "${local.prefix}-fw-mgmt-ip"
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fw" {
  name                = local.fw_name
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "ipconfig"
    subnet_id            = azurerm_subnet.hub_firewall.id
    public_ip_address_id = azurerm_public_ip.fw_ip.id
  }

  # On Azure Free-Tier we are limited to 4 public ip that we can create
  management_ip_configuration {
    name                 = "mgmt_ipconfig"
    subnet_id            = azurerm_subnet.hub_firewall_mgmt.id
    public_ip_address_id = azurerm_public_ip.fw-mgmt-ip.id 
  }

  timeouts {
    create = "60m"
    update = "30m"
  }
}

# Create Firewall Policies
resource "azurerm_firewall_policy_rule_collection_group" "fw_rules_deny" {
  name               = "${local.prefix}-frw-rules-deny"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 1000

  network_rule_collection {
    name     = "deny_network_rule_call"
    priority = 1000
    action   = "Deny"
    rule {
      name                  = "deny_all"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "fw_rules_allow" {
  name               = "${local.prefix}-frw-rules-allow"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 500

  network_rule_collection {
    name     = "allow_network_rule_call"
    priority = 500
    action   = "Allow"

    rule {
      name                  = "allow_my_ip_address"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = [data.external.my_ip.result.ip]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }

    rule {
      name                  = "allow_outbound_traffic"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }

    rule {
      name                  = "allow_hub_jumphost"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = azurerm_subnet.hub-dmz.address_prefixes
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }

    rule {
      name                  = "allow_a_to_b_via_hub"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = azurerm_subnet.spoke1-mgmt.address_prefixes
      destination_addresses = azurerm_subnet.spoke2-mgmt.address_prefixes
      destination_ports     = ["*"]
    }

    rule {
      name                  = "allow_b_to_a_via_hub"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = azurerm_subnet.spoke2-mgmt.address_prefixes
      destination_addresses = azurerm_subnet.spoke1-mgmt.address_prefixes
      destination_ports     = ["*"]
    }
  }

  nat_rule_collection {
    name     = "nat_rule_coll"
    priority = 400
    action   = "Dnat"
    rule {
      name                = "jumphost_rdp"
      protocols           = ["TCP"]
      source_addresses    = [data.external.my_ip.result.ip]
      destination_address = azurerm_public_ip.fw_ip.ip_address
      destination_ports   = ["3387"]
      translated_address  = "10.0.4.4"
      translated_port     = "3389"
    }
  }
}
