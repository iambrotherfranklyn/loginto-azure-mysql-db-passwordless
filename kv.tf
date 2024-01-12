

data "azurerm_client_config" "secure_tenant_config" {}
resource "azurerm_key_vault" "secure_kv" {
  name                        = "securekeyvault990497"
  location                    = azurerm_resource_group.secure_rg.location
  resource_group_name         = azurerm_resource_group.secure_rg.name
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.secure_tenant_config.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enabled_for_disk_encryption = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    #bypass                     = "none"
    ip_rules                   = ["92.7.185.142"]
    virtual_network_subnet_ids = []
  }
  timeouts {
    create = "30m"
    read   = "30m"
  }
}


resource "azurerm_key_vault_access_policy" "secure_db-kv_access_policy" {
  key_vault_id = azurerm_key_vault.secure_kv.id

  tenant_id = data.azurerm_client_config.secure_tenant_config.tenant_id
  object_id = azurerm_user_assigned_identity.secure_user_assigned_identity.principal_id

  secret_permissions = [
    "Get",
    # "List",
    # "Set",
    # "Delete",
  ]
  depends_on = [azurerm_key_vault.secure_kv]
}

#mine
resource "azurerm_key_vault_access_policy" "secure_db-kv_access_policy_franklyn" {
  key_vault_id = azurerm_key_vault.secure_kv.id

  tenant_id = data.azurerm_client_config.secure_tenant_config.tenant_id
  object_id = "4eb31a59-f884-4a52-a7fe-3cd29615581b"

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
  ]
  depends_on = [azurerm_key_vault.secure_kv]
}

resource "azurerm_key_vault_secret" "secure_windows_vm_secret" {
  name         = "secret-for-windows-vm"
  value        = random_password.password_generator.result
  key_vault_id = azurerm_key_vault.secure_kv.id
  depends_on   = [azurerm_key_vault_access_policy.secure_db-kv_access_policy]
}


resource "azurerm_key_vault_secret" "secure_db_secret" {
  name         = "secret-for-db"
  value        = random_password.password_generator.result
  key_vault_id = azurerm_key_vault.secure_kv.id
  depends_on   = [azurerm_key_vault_access_policy.secure_db-kv_access_policy]
}

