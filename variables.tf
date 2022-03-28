variable "environment" {
  description = "(Optional) Environment in which the resources will be created."
  type        = string
  default     = "development"
  validation {
    condition     = contains(["development", "integration", "qualification", "pre-production", "production"], var.environment)
    error_message = "Sorry, but we only accept 'development', 'integration', 'qualification', 'pre-production' or 'production' environments."
  }
}

variable "premium" {
  description = "(Optional) Update SKU to premium."
  type        = string
  default     = "no"
  validation {
    condition     = contains(["no", "yes"], var.premium)
    error_message = "Sorry, but we only accept 'no' or 'yes' values."
  }
}
