resource "azurerm_storage_account" "sql_server_storage" {
  name                     = local.sql_server_storage
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "server" {
  name                         = local.sql_server_name
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = "eastus"
  version                      = "12.0"
  minimum_tls_version          = "1.2"
  administrator_login          = "missadministrator"
  administrator_login_password = azurerm_key_vault_secret.sql.value

  azuread_administrator {
    login_username = "Clash"
    tenant_id      = data.azurerm_subscription.current.tenant_id
    object_id      = data.azurerm_client_config.current.object_id
  }

  tags = local.tags
}

resource "azurerm_mssql_firewall_rule" "rule" {
  name             = "AllowAllRule"
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

resource "azurerm_mssql_database" "db" {
  name                        = local.app_code
  server_id                   = azurerm_mssql_server.server.id
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  auto_pause_delay_in_minutes = 60
  min_capacity                = 1
  max_size_gb                 = 2
  sku_name                    = var.environment == "production" ? "BC_Gen5_2" : "GP_S_Gen5_1"

  tags = local.tags
}

resource "azurerm_mssql_server_extended_auditing_policy" "audit" {
  server_id                               = azurerm_mssql_server.server.id
  storage_account_subscription_id         = data.azurerm_client_config.current.subscription_id
  storage_endpoint                        = azurerm_storage_account.sql_server_storage.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.sql_server_storage.primary_access_key
  storage_account_access_key_is_secondary = true
  retention_in_days                       = 6
}
