resource "azurerm_user_assigned_identity" "secure_user_assigned_identity" {
  resource_group_name = azurerm_resource_group.secure_rg.name
  location            = azurerm_resource_group.secure_rg.location

  name = "secure-user-assinged-identity"
}

resource "azurerm_role_assignment" "secure_kv_role" {
  scope                = azurerm_key_vault.secure_kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_user_assigned_identity.secure_user_assigned_identity.principal_id
  depends_on           = [azurerm_user_assigned_identity.secure_user_assigned_identity]
}

resource "azurerm_role_assignment" "secure_mysql_role" {
  scope                = azurerm_mysql_flexible_server.secure_mysql-flexible-server.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.secure_user_assigned_identity.principal_id
  depends_on           = [azurerm_user_assigned_identity.secure_user_assigned_identity]
}