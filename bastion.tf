# Subnet dedicated for Azure Bastion
resource "azurerm_subnet" "secure_bastion_subnet" {
  name                 = "AzureBastionSubnet" # Must be this name
  resource_group_name  = azurerm_resource_group.secure_rg.name
  virtual_network_name = azurerm_virtual_network.secure_vnet.name
  address_prefixes     = ["10.0.4.0/24"]
  depends_on           = [azurerm_virtual_network.secure_vnet]
}

# Public IP for Azure Bastion
resource "azurerm_public_ip" "secure_Public_ip" {
  name                = "securergpip"
  location            = azurerm_resource_group.secure_rg.location
  resource_group_name = azurerm_resource_group.secure_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on          = [azurerm_resource_group.secure_rg]
}

# Azure Bastion Host
resource "azurerm_bastion_host" "secure_bastion" {
  name                = "secure-rgbastion"
  location            = azurerm_resource_group.secure_rg.location
  resource_group_name = azurerm_resource_group.secure_rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.secure_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.secure_Public_ip.id
  }
  depends_on = [azurerm_subnet.secure_bastion_subnet]
}
