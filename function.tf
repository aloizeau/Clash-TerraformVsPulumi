resource "azurerm_storage_account" "storage" {
  name                     = local.functions_storage_account_name
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_service_plan" "app_plan" {
  name                = local.functions_app_plan_name
  resource_group_name = azurerm_storage_account.storage.resource_group_name
  location            = azurerm_storage_account.storage.location
  os_type             = "Linux"
  sku_name            = var.premium == "no" ? "Y1" : "EP2"
  tags                = local.tags
}

module "function" {
  source              = "./modules/function"
  app_service_plan_id = azurerm_service_plan.app_plan.id
  storage_account_id  = azurerm_storage_account.storage.id
  function_name       = local.functions_app_name
  ai_key              = join("", ["@Microsoft.KeyVault(SecretUri=", azurerm_key_vault.kv.vault_uri, "/secrets/", azurerm_key_vault_secret.ai.name, "/)"])
  tags                = local.tags

  depends_on = [azurerm_key_vault_secret.ai, azurerm_key_vault_secret.sql]
}

# resource "azurerm_linux_function_app" "api" {
#   name                       = local.functions_app_name
#   resource_group_name        = data.azurerm_resource_group.rg.name
#   location                   = data.azurerm_resource_group.rg.location
#   service_plan_id            = azurerm_service_plan.app_plan.id
#   storage_account_name       = azurerm_storage_account.storage.name
#   storage_account_access_key = azurerm_storage_account.storage.primary_access_key
#   https_only                 = true
#   app_settings = {
#     APPINSIGHTS_INSTRUMENTATIONKEY = join("", ["@Microsoft.KeyVault(SecretUri=", azurerm_key_vault.kv.vault_uri, "/secrets/", azurerm_key_vault_secret.ai.name, "/)"])
#     FUNCTIONS_WORKER_RUNTIME       = "dotnet"
#     WEBSITE_RUN_FROM_PACKAGE       = "1"

#     StorageOptions__ConnectionString = azurerm_storage_account.storage.primary_connection_string
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   site_config {
#     pre_warmed_instance_count = 5
#     cors {
#       allowed_origins = [
#         "http://localhost:3000",
#       ]
#     }
#   }
#   lifecycle {
#     ignore_changes = [
#       app_settings["WEBSITE_RUN_FROM_PACKAGE"]
#     ]
#   }
#   depends_on = [azurerm_key_vault_secret.ai, azurerm_key_vault_secret.sql]

#   tags = local.tags
# }
