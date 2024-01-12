
# Azure Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "secure_vm" {
  name                = "demotaskvm"
  resource_group_name = azurerm_resource_group.demo-task-rg.name
  location            = azurerm_resource_group.demo-task-rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "Password1234!"
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
    identity_ids = [azurerm_user_assigned_identity.secure_user_assigned-identity.id]
  }
 
}


