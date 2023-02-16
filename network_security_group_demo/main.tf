terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.43.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "network-security-group-demo" {
  name = "network-security-group-${var.prefix}"
  location = var.location
  tags = {
    env = "network-security-group-${var.prefix}"
  }
}