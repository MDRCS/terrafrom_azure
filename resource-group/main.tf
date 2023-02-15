resource "azurerm_resource_group" "demo" {
  name = "resource-group-${var.prefix}"
  location = var.location
  tags = {
    env = "resource-group-${var.prefix}"
  }
}