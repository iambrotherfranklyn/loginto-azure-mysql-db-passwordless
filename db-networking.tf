resource "azurerm_subnet" "secure_db_subnet" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_virtual_network.secure_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.secure_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints = ["Microsoft.Sql"]
  depends_on = [ azurerm_virtual_network.secure_vnet ]
}

resource "azurerm_network_security_group" "secure_db_nsg" {
  name                = "secure-db-nsg"
  location            = azurerm_resource_group.secure_rg.location
  resource_group_name = azurerm_resource_group.secure_rg.name
  depends_on = [ azurerm_subnet.secure_db_subnet ]
}


resource "azurerm_network_security_rule" "mysql_inbound_rule" {
  name                        = "InboundFromvm"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = azurerm_network_interface.windows_vm_nic.private_ip_address
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.secure_rg.name
  network_security_group_name = azurerm_network_security_group.secure_db_nsg.name
  depends_on = [ azurerm_network_security_group.secure_db_nsg, azurerm_private_endpoint.mysql_private_endpoint ]
}


resource "azurerm_subnet_network_security_group_association" "secure_db_security_rule_association" {
  subnet_id                 = azurerm_subnet.secure_db_subnet.id
  network_security_group_id = azurerm_network_security_group.secure_db_nsg.id
  depends_on = [ azurerm_network_security_rule.mysql_inbound_rule ]
}


resource "azurerm_private_endpoint" "secure_db_endpoint" {
  name                = "secure-db-endpoint"
  location            = azurerm_resource_group.secure_rg.location
  resource_group_name = azurerm_resource_group.secure_rg.name
  subnet_id           = azurerm_subnet.secure_db_subnet.id

  private_service_connection {
    name                           = "secure-db-privateserviceconnection"
    private_connection_resource_id = azurerm_mysql_flexible_server.secure_mysql_flexible_server.id
    is_manual_connection           = false
    subresource_names              = ["mysqlServer"]
  }

  private_dns_zone_group {
    name                 = "mysql-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.mysql.id]
  }
}


resource "azurerm_private_dns_zone" "mysql" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.secure_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql_link" {
  name                  = "mysql-dns-zone-link"
  resource_group_name   = azurerm_resource_group.secure_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = azurerm_virtual_network.secure_vnet.id
  
}

/*
# Fetch the Private IP address
data "azurerm_private_endpoint_connection" "mysql_private_connection" {
  name                = azurerm_private_endpoint.mysql_private_endpoint.private_service_connection[0].name
  resource_group_name = azurerm_resource_group.secure_rg.name
  private_endpoint_id = azurerm_private_endpoint.secure_db_endpoint.id
}
*/