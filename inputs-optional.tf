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
