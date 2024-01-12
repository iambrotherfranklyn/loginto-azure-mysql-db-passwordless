resource "azurerm_subnet" "secure_kv_subnet" {
  name                 = "kv-subnet"
  resource_group_name  = azurerm_virtual_network.secure_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.secure_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.KeyVault"]
  depends_on           = [azurerm_virtual_network.secure_vnet]
}

resource "azurerm_private_endpoint" "secure_kv_endpoint" {
  name                = "secure-kv-endpoint"
  location            = azurerm_resource_group.secure_rg.location
  resource_group_name = azurerm_resource_group.secure_rg.name
  subnet_id           = azurerm_subnet.secure_kv_subnet.id

  private_service_connection {
    name                           = "secure-kv-privateserviceconnection"
    private_connection_resource_id = azurerm_key_vault.secure_kv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "secure-kv-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.secure_kv.id]
  }
  depends_on = [azurerm_subnet.secure_kv_subnet]
}


resource "azurerm_private_dns_zone" "secure_kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.secure_rg.name
  depends_on          = [azurerm_resource_group.secure_rg]
}

resource "azurerm_private_dns_zone_virtual_network_link" "secure_kv_link" {
  name                  = "secure_kv-dns-zone-link"
  resource_group_name   = azurerm_resource_group.secure_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.secure_kv.name
  virtual_network_id    = azurerm_virtual_network.secure_vnet.id
  depends_on            = [azurerm_private_endpoint.secure_kv_endpoint]

}
