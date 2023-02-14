provider "azurerm" {
    version = "3.42.0"
}

# create a resource group
resource "azurerm_resource_group" "demo" {
    name = "demo-1"
    location = var.location
}