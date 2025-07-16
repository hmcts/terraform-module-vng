# terraform-module-vng

## Azure Virtual Network Gateway Terraform Module

This Terraform module creates an Azure Virtual Network Gateway, supporting configuration for VPN client address spaces, root and revoked certificates, and advanced gateway settings.

---

## Usage

```hcl
module "vnet_gateway" {
  source                = "git::https://github.com/your-org/terraform-module-vng.git?ref=main"

  resource_group_name   = "my-resource-group"
  location              = "uksouth"
  env                   = "prod"
  public_ip_address_id  = azurerm_public_ip.example.id
  subnet_id             = azurerm_subnet.example.id

  # Optional
  product               = "myproduct"
  name                  = "custom-gateway"
  override_name         = null
  type                  = "Vpn"
  vpn_type              = "RouteBased"
  sku                   = "VpnGw1"
  active_active         = false
  enable_bgp            = false
  vpn_client_address_space = ["10.2.0.0/24"]

  root_certificates = [
    {
      name             = "RootCert1"
      public_cert_data = "MIIDuzCCAqOgAwIBAgIQ..."
    }
  ]

  revoked_certificates = [
    {
      name       = "RevokedCert1"
      thumbprint = "912198EEF23DCAC40939312FEE97DD560BAE49B1"
    }
  ]
}



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input_location) | Azure region | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input_env) | Environment name for naming | `string` | n/a | yes |
| <a name="input_public_ip_address_id"></a> [public_ip_address_id](#input_public_ip_address_id) | Public IP address resource ID | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet_id](#input_subnet_id) | Gateway subnet resource ID | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input_product) | Product name for naming | `string` | `null` | no |
| <a name="input_name"></a> [name](#input_name) | Override product part of name | `string` | `null` | no |
| <a name="input_override_name"></a> [override_name](#input_override_name) | Override the generated name | `string` | `null` | no |
| <a name="input_type"></a> [type](#input_type) | Gateway type | `string` | `"Vpn"` | no |
| <a name="input_vpn_type"></a> [vpn_type](#input_vpn_type) | VPN type | `string` | `"RouteBased"` | no |
| <a name="input_sku"></a> [sku](#input_sku) | Gateway SKU | `string` | `"Basic"` | no |
| <a name="input_active_active"></a> [active_active](#input_active_active) | Enable active-active mode | `bool` | `false` | no |
| <a name="input_enable_bgp"></a> [enable_bgp](#input_enable_bgp) | Enable BGP | `bool` | `false` | no |
| <a name="input_vpn_client_address_space"></a> [vpn_client_address_space](#input_vpn_client_address_space) | VPN client address space | `list(string)` | `["10.2.0.0/24"]` | no |
| <a name="input_root_certificates"></a> [root_certificates](#input_root_certificates) | List of root certificates | `list(object)` | `[]` | no |
| <a name="input_revoked_certificates"></a> [revoked_certificates](#input_revoked_certificates) | List of revoked certificates | `list(object)` | `[]` | no |
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.32.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.32.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_local_network_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) | resource |
| [azurerm_virtual_network_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |
| [azurerm_virtual_network_gateway_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_active"></a> [active\_active](#input\_active\_active) | Enable active-active mode. | `bool` | `false` | no |
| <a name="input_bgp_asn"></a> [bgp\_asn](#input\_bgp\_asn) | BGP ASN. | `number` | `null` | no |
| <a name="input_bgp_peer_weight"></a> [bgp\_peer\_weight](#input\_bgp\_peer\_weight) | The weight added to routes learned through BGP peering. Valid values are between 0 and 100. | `number` | `null` | no |
| <a name="input_bgp_peering_address"></a> [bgp\_peering\_address](#input\_bgp\_peering\_address) | BGP peering address. | `list(string)` | `[]` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common Tags | `map(string)` | `null` | no |
| <a name="input_enable_bgp"></a> [enable\_bgp](#input\_enable\_bgp) | Enable BGP. | `bool` | `false` | no |
| <a name="input_enable_vpn_client_configuration"></a> [enable\_vpn\_client\_configuration](#input\_enable\_vpn\_client\_configuration) | If true, VPN client configuration will be enabled. | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment name for naming. | `string` | n/a | yes |
| <a name="input_generation"></a> [generation](#input\_generation) | The generation of the Virtual Network Gateway | `string` | `"None"` | no |
| <a name="input_ip_configuration_name"></a> [ip\_configuration\_name](#input\_ip\_configuration\_name) | Name for the IP configuration block of the Virtual Network Gateway. | `string` | `"vnetGatewayConfig"` | no |
| <a name="input_local_network_gateways"></a> [local\_network\_gateways](#input\_local\_network\_gateways) | Map of local network gateways to create. Key is the gateway name suffix. | <pre>map(object({<br/>    gateway_address   = string<br/>    address_space     = list(string)<br/>    create_connection = optional(bool, true)<br/>    connection_config = optional(object({<br/>      connection_type                    = optional(string, "IPsec")<br/>      shared_key                         = optional(string)<br/>      routing_weight                     = optional(number, 10)<br/>      use_policy_based_traffic_selectors = optional(bool, false)<br/>      enable_bgp                         = optional(bool, false)<br/>    }), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Target Azure location to deploy the resource | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The default name will be product+env, you can override the product part by setting this | `string` | `null` | no |
| <a name="input_override_name"></a> [override\_name](#input\_override\_name) | Override the generated name. | `string` | `null` | no |
| <a name="input_product"></a> [product](#input\_product) | Product name for naming. | `string` | `null` | no |
| <a name="input_public_ip_address_id"></a> [public\_ip\_address\_id](#input\_public\_ip\_address\_id) | Public IP address resource ID. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of existing resource group to deploy resources into | `string` | n/a | yes |
| <a name="input_revoked_certificates"></a> [revoked\_certificates](#input\_revoked\_certificates) | List of revoked certificates. | <pre>list(object({<br/>    name       = string<br/>    thumbprint = string<br/>  }))</pre> | `[]` | no |
| <a name="input_root_certificates"></a> [root\_certificates](#input\_root\_certificates) | List of root certificates. | <pre>list(object({<br/>    name             = string<br/>    public_cert_data = string<br/>  }))</pre> | `[]` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | Gateway SKU. | `string` | `"Basic"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Gateway subnet resource ID. | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Gateway type. | `string` | `"Vpn"` | no |
| <a name="input_vpn_client_address_space"></a> [vpn\_client\_address\_space](#input\_vpn\_client\_address\_space) | VPN client address space. | `list(string)` | <pre>[<br/>  "10.2.0.0/24"<br/>]</pre> | no |
| <a name="input_vpn_type"></a> [vpn\_type](#input\_vpn\_type) | VPN type. | `string` | `"RouteBased"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_ids"></a> [connection\_ids](#output\_connection\_ids) | Map of connection IDs keyed by connection name |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_local_network_gateway_ids"></a> [local\_network\_gateway\_ids](#output\_local\_network\_gateway\_ids) | Map of local network gateway IDs keyed by gateway name |
<!-- END_TF_DOCS -->