locals {
  app_code          = "clash"
  rg_name           = "Clash"
  retention_in_days = 90

  loc_prefix                     = data.azurerm_resource_group.rg.location == "westeurope" ? "we" : data.azurerm_resource_group.rg.location == "northeurope" ? "ne" : data.azurerm_resource_group.rg.location == "francecentral" ? "fc" : "u"
  env_prefix                     = var.environment == "development" ? "dev" : var.environment == "integration" ? "int" : var.environment == "qualification" ? "qual" : var.environment == "pre-production" ? "pre-prod" : var.environment == "production" ? "" : "unknow"
  key_vault_name                 = join("", ["kv", local.app_code, local.env_prefix, local.loc_prefix])
  log_analytics_workspace_name   = join("", ["log", local.app_code, local.env_prefix, local.loc_prefix])
  application_insights_name      = join("", ["ai", local.app_code, local.env_prefix, local.loc_prefix])
  sql_server_name                = join("", ["sql", local.app_code, local.env_prefix, "eu"])
  sql_server_storage             = join("", ["sqlstor", local.app_code, local.env_prefix, local.loc_prefix])
  functions_storage_account_name = join("", ["fnstor", local.app_code, local.env_prefix, local.loc_prefix])
  functions_app_plan_name        = join("", ["fnplan", local.app_code, local.env_prefix, local.loc_prefix])
  functions_app_name             = join("", ["fn", local.app_code, local.env_prefix, local.loc_prefix])

  tags = {
    environment = var.environment,
    appCode     = "Clash",
    createdBy   = "Terraform",
    owner       = "Antoine LOIZEAU"
  }
}

