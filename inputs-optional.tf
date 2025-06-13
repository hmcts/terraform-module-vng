variable "name" {
  description = "The default name will be product+env, you can override the product part by setting this"
  type        = string
  default     = null
}

variable "override_name" {
  description = "Override the generated name."
  type        = string
  default     = null
}

variable "product" {
  description = "Product name for naming."
  type        = string
  default     = null
}

variable "type" {
  description = "Gateway type."
  type        = string
  default     = "Vpn"
}

variable "vpn_type" {
  description = "VPN type."
  type        = string
  default     = "RouteBased"
}

variable "sku" {
  description = "Gateway SKU."
  type        = string
  default     = "Basic"
}

variable "active_active" {
  description = "Enable active-active mode."
  type        = bool
  default     = false
}

variable "enable_bgp" {
  description = "Enable BGP."
  type        = bool
  default     = false
}

variable "bgp_asn" {
  description = "BGP ASN."
  type        = number
  default     = null
}

variable "bgp_peering_address" {
  description = "BGP peering address."
  type        = list(string)
  default     = []
}

variable "bgp_peer_weight" {
  description = "The weight added to routes learned through BGP peering. Valid values are between 0 and 100."
  type        = number
  default     = null
}

variable "vpn_client_address_space" {
  description = "VPN client address space."
  type        = list(string)
  default     = ["10.2.0.0/24"]
}

variable "root_certificates" {
  description = "List of root certificates."
  type = list(object({
    name             = string
    public_cert_data = string
  }))
  default = []
}

variable "revoked_certificates" {
  description = "List of revoked certificates."
  type = list(object({
    name       = string
    thumbprint = string
  }))
  default = []
}

variable "common_tags" {
  description = "Common Tags"
  type        = map(string)
  default     = null
}

variable "ip_configuration_name" {
  description = "Name for the IP configuration block of the Virtual Network Gateway."
  type        = string
  default     = "vnetGatewayConfig"
}

variable "enable_vpn_client_configuration" {
  description = "If true, VPN client configuration will be enabled."
  type        = bool
  default     = true # Assuming it's commonly used, can be false
}

variable "local_network_gateways" {
  description = "Map of local network gateways to create. Key is the gateway name suffix."
  type = map(object({
    gateway_address   = string
    address_space     = list(string)
    create_connection = optional(bool, true)
    connection_config = optional(object({
      connection_type                    = optional(string, "IPsec")
      shared_key                         = optional(string)
      routing_weight                     = optional(number, 10)
      use_policy_based_traffic_selectors = optional(bool, false)
      enable_bgp                         = optional(bool, false)
    }), {})
  }))
  default = {}
}

variable "generation" {
  description = "The generation of the Virtual Network Gateway"
  type        = string
  default     = "None"
}

variable "create_public_ip" {
  description = "If true, a public IP address will be created for the Virtual Network Gateway."
  type        = bool
  default     = false
}

variable "public_ip_name" {
  description = "Name of the public IP address resource."
  type        = string
  default     = null
}
variable "public_ip_allocation_method" {
  description = "Allocation method for the public IP address."
  type        = string
  default     = "Dynamic"
}

variable "create_gateway_subnet" {
  description = "If true, a gateway subnet will be created."
  type        = bool
  default     = false
}

variable "subnet_name" {
  description = "Name of the gateway subnet. Required if create_gateway_subnet is true."
  type        = string
  default     = "GatewaySubnet"
}

variable "address_prefixes" {
  description = "Address prefixes for the gateway subnet."
  type        = list(string)
  default     = []
}

variable "virtual_network_name" {
  description = "Name of the virtual network where the gateway subnet will be created. Required if create_gateway_subnet is true."
  type        = string
  default     = null
}
