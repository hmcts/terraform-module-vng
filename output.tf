output "id" {
  value = azurerm_virtual_network_gateway.this.id
}

output "local_network_gateway_ids" {
  description = "Map of local network gateway IDs keyed by gateway name"
  value       = { for k, v in azurerm_local_network_gateway.this : k => v.id }
}

output "connection_ids" {
  description = "Map of connection IDs keyed by connection name"
  value       = { for k, v in azurerm_virtual_network_gateway_connection.this : k => v.id }
}
