variable "env" {
  description = "Environment name"
  type        = string
  default     = "sandbox"
}

variable "product" {
  description = "Product name"
  type        = string
  default     = "platops"
}

variable "builtFrom" {
  description = "Source of the build"
  type        = string
  default     = "local"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "UK South"
}
