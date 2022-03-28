# Data App Service Plan
data "azurerm_app_service_plan" "plan" {
  name                = element(split("/", var.app_service_plan_id), 8)
  resource_group_name = element(split("/", var.app_service_plan_id), 4)
}

# Data App Service Plan
data "azurerm_storage_account" "storage" {
  name                = element(split("/", var.storage_account_id), 8)
  resource_group_name = element(split("/", var.storage_account_id), 4)
}

resource "azurerm_linux_function_app" "custom" {
  name                       = var.function_name
  resource_group_name        = element(split("/", var.app_service_plan_id), 4)
  location                   = data.azurerm_app_service_plan.plan.location
  service_plan_id            = data.azurerm_app_service_plan.plan.id
  storage_account_name       = data.azurerm_storage_account.storage.name
  storage_account_access_key = data.azurerm_storage_account.storage.primary_access_key
  https_only                 = true
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = var.ai_key
    FUNCTIONS_WORKER_RUNTIME       = "dotnet"
    WEBSITE_RUN_FROM_PACKAGE       = "1"

    StorageOptions__ConnectionString = data.azurerm_storage_account.storage.primary_connection_string
  }

  identity {
    type = "SystemAssigned"
  }

  site_config {
    pre_warmed_instance_count = 5
    cors {
      allowed_origins = [
        "http://localhost:3000",
      ]
    }
  }
  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }

  tags = var.tags
}
