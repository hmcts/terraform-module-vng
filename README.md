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