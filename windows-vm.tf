
# Azure Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "secure_vm" {
  name                = "securevm"
  resource_group_name = azurerm_resource_group.secure_rg.name
  location            = azurerm_resource_group.secure_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = azurerm_key_vault_secret.secure_windows_vm_secret.value
  #admin_password      = "Password1234!"
  network_interface_ids = [
    azurerm_network_interface.secure_vm_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.secure_user_assigned_identity.id]
  }
  depends_on = [azurerm_subnet.secure_windows_vm_subnet]
}

resource "azurerm_virtual_machine_extension" "installation_tool" {
  name                 = "installationTool"
  virtual_machine_id   = azurerm_windows_virtual_machine.secure_vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<-SETTINGS
  {
    "commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command \\\"Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/iambrotherfranklyn/housekeeping/main/tool-installations.ps1' -OutFile '\\$env:TEMP\\tool-installations.ps1'; & '\\$env:TEMP\\tool-installations.ps1'\\\""
  }
  SETTINGS

  depends_on = [azurerm_windows_virtual_machine.secure_vm]
}
