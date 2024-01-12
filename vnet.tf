resource "azurerm_virtual_network" "secure_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.secure_rg.location
  resource_group_name = azurerm_resource_group.secure_rg.name
  address_space       = var.vnet_address_space
  depends_on = [ azurerm_resource_group.secure_rg ]
 
}