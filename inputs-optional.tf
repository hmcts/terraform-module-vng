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

variable "vpn_client_address_space" {
  description = "VPN client address space."
  type        = list(string)
  default     = ["10.2.0.0/24"]
}

variable "root_certificates" {
  description = "List of root certificates."
  type = list(object({
    name            = string
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