resource "azurerm_resource_group" "secure_rg" {
  name     = var.resource_group_name
  location = var.location
}
