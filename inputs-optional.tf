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

  validation {
    condition     = !var.active_active || length(var.bgp_peering_address) == 1
    error_message = "If active_active is true, the bgp_peering_address list must contain exactly one address."
  }
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

variable "create_local_network_gateway" {
  description = "If true, a Local Network Gateway will be created."
  type        = bool
  default     = true
}

variable "gateway_address" {
  description = "The gateway IP address of the local network. Required if create_local_network_gateway is true."
  type        = string
  default     = null
}

variable "local_network_address_space" {
  description = "The address space of the local network. Required if create_local_network_gateway is true."
  type        = list(string)
  default     = []
}

variable "create_gateway_connection" {
  description = "If true, a Virtual Network Gateway Connection will be created. Requires create_local_network_gateway to be true."
  type        = bool
  default     = true
}

variable "connection_type" {
  description = "The type of connection. Valid options are IPsec, ExpressRoute, or Vnet2Vnet."
  type        = string
  default     = "IPsec"
}

variable "shared_key" {
  description = "The shared key for the IPsec connection. Required if create_gateway_connection is true and type is IPsec."
  type        = string
  default     = null
  sensitive   = true
}

variable "routing_weight" {
  description = "The routing weight for the connection."
  type        = number
  default     = 10
}

variable "use_policy_based_traffic_selectors" {
  description = "If true, policy-based traffic selectors will be used for the connection."
  type        = bool
  default     = false
}

variable "generation" {
  description = "The generation of the Virtual Network Gateway"
  type        = string
  default     = "None"
}
