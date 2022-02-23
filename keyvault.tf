resource "azurerm_key_vault" "kv" {
  tenant_id           = data.azurerm_client_config.current.tenant_id
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = local.key_vault_name

  sku_name = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
  tags = local.tags
}

resource "azurerm_key_vault_access_policy" "current" {
  key_vault_id = azurerm_key_vault.kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = ["get", "list", "set", "delete", "purge"]
}
resource "azurerm_key_vault_access_policy" "function" {
  key_vault_id = azurerm_key_vault.kv.id

  tenant_id = azurerm_function_app.api.identity[0].tenant_id
  object_id = azurerm_function_app.api.identity[0].principal_id

  secret_permissions = ["get", "list", "set", "delete", "purge"]
}
resource "random_password" "admin_password" {
  length           = 16
  special          = true
  override_special = "_%@$"
}

resource "azurerm_key_vault_secret" "sql" {
  name         = "sql-admin-password"
  value        = random_password.admin_password.result
  key_vault_id = azurerm_key_vault.kv.id
  tags         = local.tags

  depends_on = [
    azurerm_key_vault_access_policy.current
  ]
}

resource "azurerm_key_vault_secret" "ai" {
  name         = "ai-key"
  value        = azurerm_application_insights.ai.instrumentation_key
  key_vault_id = azurerm_key_vault.kv.id
  tags         = local.tags

  depends_on = [
    azurerm_key_vault_access_policy.current
  ]
}
