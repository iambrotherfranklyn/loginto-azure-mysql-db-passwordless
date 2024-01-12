# Create a Private Endpoint for the MySQL server
resource "azurerm_private_endpoint" "mysql_private_endpoint" {
  name                = "example-mysql-private-endpoint"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "mysql-private-service-connection"
    private_connection_resource_id = azurerm_mysql_server.example.id
    is_manual_connection           = false
    subresource_names              = ["mysqlServer"]
  }
}


output "mysql_private_ip" {
  value = data.azurerm_private_endpoint_connection.mysql_private_connection.private_ip_address
}
