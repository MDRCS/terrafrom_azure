terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.41.0"
    }

    databricks = {
      source  = "databricks/databricks"
      version = "=1.9.2"
    }

    external = {
      source  = "hashicorp/external"
      version = "=2.2.2"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  # subscription_id = var.subscription_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "hub_spoke" {
  name     = "${local.org}-rg"
  location = local.location
}