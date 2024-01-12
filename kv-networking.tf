resource "azurerm_subnet" "secure_kv_subnet" {
  name                 = "kv-subnet"
  resource_group_name  = azurerm_virtual_network.secure_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.secure_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
   service_endpoints = ["Microsoft.KeyVault"]
}