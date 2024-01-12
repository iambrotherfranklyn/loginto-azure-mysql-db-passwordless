
resource "azurerm_mysql_flexible_server" "secure_mysql_flexible_server" {
  name                   = "secure-mysqlfs"
  resource_group_name    = azurerm_resource_group.secure_rg.name
  location               = azurerm_resource_group.secure_rg.location
  administrator_login    = "adminuser"
  administrator_password = azurerm_key_vault_secret.secure_db_secret.value
  sku_name               = "B_Standard_B1s"
  zone                   = "1"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.secure_user_assigned_identity]
  }
  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysql_link]
}


resource "azurerm_mysql_flexible_server_active_directory_administrator" "secure_databse" {
  server_id   = azurerm_mysql_flexible_server.secure_mysql_flexible_server.id
  identity_id = azurerm_user_assigned_identity.secure_user_assigned_identity.id
  login       = "sqladmin"
  object_id   = "4eb31a59-f884-4a52-a7fe-3cd29615581b"
  tenant_id   = data.azurerm_client_config.secure_tenant_config.tenant_id
  depends_on  = [azurerm_mysql_flexible_server.secure_mysql_flexible_server.id]
}