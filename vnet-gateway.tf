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

  dynamic "bgp_settings" {
    for_each = var.enable_bgp ? [1] : []
    content {
      asn         = var.bgp_asn
      peer_weight = var.bgp_peer_weight

      dynamic "peering_addresses" {
        for_each = var.bgp_peering_address
        content {
          apipa_addresses = bgp_peering_address.value
        }
      }
    }
  }

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = var.public_ip_address_id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  vpn_client_configuration {
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

  tags = var.common_tags
}
