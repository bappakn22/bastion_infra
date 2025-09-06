resource "azurerm_resource_group" "mi-resource" {
  name     = var.resource_group_name
  location = var.location
}