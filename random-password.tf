resource "random_password" "password_generator" {
  length           = 11
  lower            = true
  #numeric          = true
  special          = true
  upper            = true
  override_special = "!#%&"
  depends_on       = [azurerm_key_vault.secure_kv]
}

