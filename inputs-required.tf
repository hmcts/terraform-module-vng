variable "resource_group_name" {
  description = "Name of existing resource group to deploy resources into"
  type        = string
}

variable "location" {
  description = "Target Azure location to deploy the resource"
  type        = string
}

variable "env" {
  description = "Environment name for naming."
  type        = string
}

variable "public_ip_address_id" {
  description = "Public IP address resource ID."
  type        = string
}

variable "subnet_id" {
  description = "Gateway subnet resource ID."
  type        = string
}
