
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
    identity_ids = [azurerm_user_assigned_identity.secure_user_assigned_identity.id]
  }
  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysql_link]
}


resource "azurerm_mysql_flexible_server_active_directory_administrator" "secure_databse" {
  server_id   = azurerm_mysql_flexible_server.secure_mysql_flexible_server.id
  identity_id = azurerm_user_assigned_identity.secure_user_assigned_identity.id
  login       = "LOGIN NAME OR YOUR USER ACCOUNT NAME"
  object_id   = "OBJECT_ID OF YOUR TENANT EMAIL ACCOUNT"
  tenant_id   = data.azurerm_client_config.secure_tenant_config.tenant_id
  depends_on  = [azurerm_mysql_flexible_server.secure_mysql_flexible_server]
}

# Create a database within the MySQL Flexible Server
resource "azurerm_mysql_flexible_database" "secure_mysql_db" {
  name                = "secure-flexible-db" 
  resource_group_name = azurerm_resource_group.secure_rg.name
  server_name         = azurerm_mysql_flexible_server.secure_mysql_flexible_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  depends_on = [ azurerm_mysql_flexible_server_active_directory_administrator.secure_databse ]
}

#To connect to mysql flexible server via command line
#mysql -h secure-mysqlfs.mysql.database.azure.com --user 'tenantusername OR LOGIN NAME' --enable-cleartext-plugin --password=$(az account get-access-token --resource-type oss-rdbms --output tsv --query accessToken)
