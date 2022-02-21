variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "environment" {
  description = "(Optional) Environment in which the resources will be created."
  type        = string
  default     = "development"
  validation {
    condition     = contains(["development", "integration", "qualification", "pre-production", "production"], var.environment)
    error_message = "Sorry, but we only accept 'development', 'integration', 'qualification', 'pre-production' or 'production' environments."
  }
}

variable "location" {
  description = "(Optional) Location in which the resources will be created."
  type        = string
  default     = "francecentral"
  validation {
    condition     = contains(["westeurope", "northeurope", "francecentral"], var.location)
    error_message = "Sorry, but we only accept 'westeurope', 'northeurope' or 'francecentral' environments."
  }
}

variable "state_storage_account_name" {
  type    = string
  default = "clashstate"
}

variable "state_container_name" {
  type    = string
  default = "tfstate"
}
