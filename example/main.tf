resource "azurerm_resource_group" "this" {
  name     = "${var.product}-${var.env}-rg"
  location = var.location

  tags = module.tags.common_tags
}

# Create a VNet for the gateway subnet
resource "azurerm_virtual_network" "this" {
  name                = "${var.product}-${var.env}-vnet"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]

  tags = module.tags.common_tags
}

# Create the gateway subnet
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP for the VPN gateway
resource "azurerm_public_ip" "gateway" {
  name                = "${var.product}-${var.env}-gateway-ip"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = module.tags.common_tags
}

module "vnet_gateway" {
  source = "../"

  # Required variables
  resource_group_name  = azurerm_resource_group.this.name
  location             = azurerm_resource_group.this.location
  env                  = var.env
  public_ip_address_id = azurerm_public_ip.gateway.id
  subnet_id            = azurerm_subnet.gateway.id

  # Optional variables
  product    = var.product
  type       = "Vpn"
  vpn_type   = "RouteBased"
  sku        = "VpnGw1"
  generation = "Generation1"

  # Multiple local network gateways example
  local_network_gateways = {
    "branch-office-1" = {
      gateway_address   = "203.0.113.10"
      address_space     = ["192.168.1.0/24"]
      create_connection = true
      connection_config = {
        connection_type = "IPsec"
        shared_key      = "example-shared-key-1"
        routing_weight  = 10
        enable_bgp      = false
      }
    }
    "branch-office-2" = {
      gateway_address   = "203.0.113.20"
      address_space     = ["192.168.2.0/24", "192.168.3.0/24"]
      create_connection = true
      connection_config = {
        connection_type                    = "IPsec"
        shared_key                         = "example-shared-key-2"
        routing_weight                     = 20
        use_policy_based_traffic_selectors = true
        enable_bgp                         = false
      }
    }
    "datacenter" = {
      gateway_address   = "203.0.113.30"
      address_space     = ["172.16.0.0/16"]
      create_connection = false # Only create gateway, no connection
    }
  }

  # VPN client configuration
  enable_vpn_client_configuration = true
  vpn_client_address_space        = ["10.2.0.0/24"]

  # Example root certificate (base64 encoded certificate data)
  root_certificates = [
    {
      name             = "RootCert1"
      public_cert_data = "MIIDQjCCAiqgAwIBAgIQPiHAAYglQqL6CzIBAQAAAAowDQYJKoZIhvcNAQELBQAwHzEdMBsGA1UEAxMUVlBORXhhbXBsZVJvb3RDZXJ0aWZpY2F0ZTAeFw0yMzEwMjUxMjMwMDBaFw0yNTEwMjUxMjMwMDBaMB8xHTAbBgNVBAMTFFZQTkV4YW1wbGVSb290Q2VydGlmaWNhdGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC4iEKQrXvJ8wJdKT2pqKl4KbCvRvY5QjQWKsNvGgbqWUdOdU1URHlRfIEWJaZYBIx7BXwFMZY3HYz"
    }
  ]

  common_tags = module.tags.common_tags
}

module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.env
  product     = var.product
  builtFrom   = var.builtFrom
}
