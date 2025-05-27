resource "azurerm_virtual_network_gateway" "example" {
  for_each = var.virtual_network_gateways

  active_active                    = lookup(each.value, "active_active", false)
  default_local_network_gateway_id = lookup(each.value, "default_local_network_gateway_id", null)
  enable_bgp                       = lookup(each.value, "enable_bgp", false)
  generation                       = lookup(each.value, "generation", null)
  location                         = lookup(each.value, "location", azurerm_resource_group.virtual_wan_resource_group[0].location)
  name                             = each.key
  private_ip_address_enabled       = lookup(each.value, "private_ip_address_enabled", null)
  resource_group_name              = lookup(each.value, "resource_group_name", azurerm_resource_group.virtual_wan_resource_group[0].name)
  sku                              = lookup(each.value, "sku", null)
  type                             = lookup(each.value, "type", null)
  vpn_type                         = lookup(each.value, "vpn_type", null)

  dynamic "ip_configuration" {
    for_each = lookup(var.virtual_network_gateway_ip_configurations, each.key, null) != null ? lookup(var.virtual_network_gateway_ip_configurations, each.key, null) : []
    content {
      name                          = "vnetGatewayConfig"
      public_ip_address_id          = azurerm_public_ip.example.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = azurerm_subnet.example.id
    }
  }

  vpn_client_configuration {
    for_each = lookup(var.virtual_network_gateway_vpn_client_configurations, each.key, {}) != {} ? lookup(var.virtual_network_gateway_vpn_client_configurations, each.key, {}) : {}
    content {
      aad_audience          = lookup(vpn_client_configuration.value, "aad_audience", null)
      aad_issuer            = lookup(vpn_client_configuration.value, "aad_issuer", null)
      aad_tenant            = lookup(vpn_client_configuration.value, "aad_tenant", null)
      address_space         = lookup(vpn_client_configuration.value, "address_space", null)
      radius_server_address = lookup(vpn_client_configuration.value, "radius_server_address", null)
      radius_server_secret  = lookup(vpn_client_configuration.value, "radius_server_secret", null)


      dynamic "root_certificate" {
        for_each = lookup(var.virtual_network_gateway_root_certificates, each.key, null) != null ? lookup(var.virtual_network_gateway_root_certificates, each.key, null) : []
        content {
          name = "DigiCert-Federated-ID-Root-CA"

          public_cert_data = ""
        }
      }

      revoked_certificate {
        for_each = lookup(var.virtual_network_gateway_revoked_certificates, each.key, null) != null ? lookup(var.virtual_network_gateway_revoked_certificates, each.key, null) : []
        content {
          name       = "Verizon-Global-Root-CA"
          thumbprint = "912198EEF23DCAC40939312FEE97DD560BAE49B1"
        }
      }
      vpn_client_protocols = lookup(vpn_client_configuration.value, "vpn_client_protocols", null)
    }
  }
}
