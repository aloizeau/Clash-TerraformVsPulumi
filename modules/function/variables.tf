variable "app_service_plan_id" {
  type        = string
  description = "Azure service plan ID"
}
variable "storage_account_id" {
  type        = string
  description = "Azure storage ID"
}
variable "function_name" {
  type        = string
  description = "Azure function name"
}
variable "tags" {
  type        = map(string)
  description = "Azure function tags"
  default     = {}
}
variable "ai_key" {
  type        = string
  description = "Azure App Insights instrumentation key"
}
