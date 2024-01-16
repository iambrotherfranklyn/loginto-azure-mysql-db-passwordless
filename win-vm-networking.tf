resource "azurerm_subnet" "secure_windows_vm_subnet" {
  name                 = "windows-vm-subnet"
  resource_group_name  = azurerm_virtual_network.secure_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.secure_vnet.name
  address_prefixes     = ["10.0.3.0/24"]
  depends_on           = [azurerm_virtual_network.secure_vnet]

}

resource "azurerm_network_security_group" "secure_vm_nsg" {
  name                = "secure-vm-nsg"
  location            = azurerm_resource_group.secure_rg.location
  resource_group_name = azurerm_resource_group.secure_rg.name
  depends_on          = [azurerm_subnet.secure_windows_vm_subnet]
}

resource "azurerm_network_security_rule" "mysql_outbound_rule" {
  name                        = "OutboundToMySQL"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306" # Default MySQL port
  source_address_prefix       = "*"    # Applies to all sources in the subnet
  destination_address_prefix  = azurerm_private_endpoint.secure_db_endpoint.private_service_connection[0].private_ip_address
  resource_group_name         = azurerm_resource_group.secure_rg.name
  network_security_group_name = azurerm_network_security_group.secure_vm_nsg.name
  depends_on                  = [azurerm_network_security_group.secure_vm_nsg]
}

resource "azurerm_network_security_rule" "secure_bastion_to_vm_rdp" {
  name                        = "SecureBastionToVMRDP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389" 
  source_address_prefix       = "VirtualNetwork"             
  #source_address_prefix       = "AzureBastionSubnet" # Allow traffic from Azure Bastion
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.secure_rg.name
  network_security_group_name = azurerm_network_security_group.secure_vm_nsg.name
}


resource "azurerm_subnet_network_security_group_association" "secure_vm_security_rule_association" {
  subnet_id                 = azurerm_subnet.secure_windows_vm_subnet.id
  network_security_group_id = azurerm_network_security_group.secure_vm_nsg.id
  depends_on                = [azurerm_network_security_rule.mysql_outbound_rule]
}



resource "azurerm_network_interface" "secure_vm_nic" {
  name                = "secure_vm_nic"
  location            = azurerm_resource_group.secure_rg.location
  resource_group_name = azurerm_resource_group.secure_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.secure_windows_vm_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.3.8"
  }
  depends_on = [azurerm_subnet.secure_windows_vm_subnet]
}


/*
resource "azurerm_network_security_rule" "allow_winrm" {
  name                        = "allowWinRM"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5986"  // For WinRM over HTTPS
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.example.resource_group_name
  network_security_group_name = azurerm_network_security_group.example.name
}
*/