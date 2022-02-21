locals {
  app_code      = "clash"
  loc_prefix    = var.location == "westeurope" ? "we" : var.location == "northeurope" ? "ne" : var.location == "francecentral" ? "fc" : "u"
  env_prefix    = var.environment == "development" ? "d" : var.environment == "integration" ? "i" : var.environment == "qualification" ? "q" : var.environment == "pre-production" ? "a" : var.environment == "production" ? "p" : "u"
  env_trigramme = var.environment == "development" ? "dev" : var.environment == "integration" ? "int" : var.environment == "qualification" ? "qual" : var.environment == "pre-production" ? "pre-prod" : var.environment == "production" ? "" : "unknow"

  rg_name                      = "Clash"
  ai_name                      = join("", [local.app_code, local.env_prefix, local.loc_prefix])
  key_vault_name               = join("", [local.app_code, local.env_prefix, local.loc_prefix])
  log_analytics_workspace_name = join("", [local.app_code, local.env_prefix, local.loc_prefix])
  retention_in_days            = 90
  tags = {
    environment = var.environment,
    appCode     = "Clash",
    createdBy   = "Terraform",
    owner       = "Antoine LOIZEAU"
  }
}

