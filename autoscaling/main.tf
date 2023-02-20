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


resource "azurerm_resource_group" "scalesets-loadbalancer-demo" {
  name     = "scalesets-loadbalancer-${var.prefix}"
  location = var.location
  tags = {
    env = "scalesets-loadbalancer-${var.prefix}"
  }
}