locals {
  name = var.override_name == null ? (var.name == null ? "${var.product}-${var.env}" : "${var.name}-${var.env}") : var.override_name
}

resource "azurerm_virtual_network_gateway" "this" {
  name                = local.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = var.type
  vpn_type = var.vpn_type

  active_active = var.active_active
  enable_bgp    = var.enable_bgp
  sku           = var.sku
  generation    = var.generation

  dynamic "bgp_settings" {
    for_each = var.enable_bgp ? [1] : []
    content {
      asn         = var.bgp_asn
      peer_weight = var.bgp_peer_weight

      dynamic "peering_addresses" {
        for_each = var.bgp_peering_address
        content {
          apipa_addresses = peering_addresses.value
        }
      }
    }
  }

  ip_configuration {
    name                          = var.ip_configuration_name
    public_ip_address_id          = var.public_ip_address_id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  dynamic "vpn_client_configuration" {
    for_each = var.enable_vpn_client_configuration ? [1] : []
    content {
      address_space = var.vpn_client_address_space

      dynamic "root_certificate" {
        for_each = var.root_certificates
        content {
          name             = root_certificate.value.name
          public_cert_data = root_certificate.value.public_cert_data
        }
      }

      dynamic "revoked_certificate" {
        for_each = var.revoked_certificates
        content {
          name       = revoked_certificate.value.name
          thumbprint = revoked_certificate.value.thumbprint
        }
      }
    }
  }

  tags = var.common_tags
}

resource "azurerm_local_network_gateway" "this" {
  for_each = var.local_network_gateways

  name                = "${local.name}-${each.key}-local"
  location            = var.location
  resource_group_name = var.resource_group_name

  gateway_address = each.value.gateway_address
  address_space   = each.value.address_space

  tags = var.common_tags
}

resource "azurerm_virtual_network_gateway_connection" "this" {
  for_each = { for k, v in var.local_network_gateways : k => v if v.create_connection }

  name                = "${local.name}-${each.key}-connection"
  location            = var.location
  resource_group_name = var.resource_group_name

  type                               = each.value.connection_config.connection_type
  virtual_network_gateway_id         = azurerm_virtual_network_gateway.this.id
  local_network_gateway_id           = azurerm_local_network_gateway.this[each.key].id
  shared_key                         = each.value.connection_config.shared_key
  enable_bgp                         = each.value.connection_config.enable_bgp
  routing_weight                     = each.value.connection_config.routing_weight
  use_policy_based_traffic_selectors = each.value.connection_config.use_policy_based_traffic_selectors

  tags = var.common_tags
}
