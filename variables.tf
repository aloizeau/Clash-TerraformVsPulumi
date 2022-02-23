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
