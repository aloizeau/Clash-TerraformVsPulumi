resource "azurerm_key_vault" "kv" {
  tenant_id           = data.azurerm_client_config.current.tenant_id
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = local.key_vault_name

  sku_name = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"
    #default_action ="Deny"
    # The list of allowed ip addresses (Current agent DevOps Ip) + cf. https://docs.microsoft.com/en-us/azure/devops/organizations/security/allow-list-ip-url?view=azure-devops&tabs=IP-V4#inbound-connections
    #ip_rules = [chomp(data.http.currentip.body), "40.74.28.0/23"]
  }
  tags = local.tags
}

resource "azurerm_key_vault_access_policy" "current" {
  key_vault_id = azurerm_key_vault.kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = ["Get", "List", "Set", "Delete", "Purge"]
}
resource "azurerm_key_vault_access_policy" "function" {
  key_vault_id = azurerm_key_vault.kv.id

  # tenant_id = azurerm_linux_function_app.api.identity[0].tenant_id
  # object_id = azurerm_linux_function_app.api.identity[0].principal_id
  tenant_id          = module.function.identity[0].tenant_id
  object_id          = module.function.identity[0].principal_id
  secret_permissions = ["Get", "List", "Set", "Delete", "Purge"]
}
resource "random_password" "admin_password" {
  length           = 16
  special          = true
  override_special = "_%@$"
}

resource "azurerm_key_vault_secret" "sql" {
  name            = "sql-admin-password"
  value           = random_password.admin_password.result
  key_vault_id    = azurerm_key_vault.kv.id
  tags            = local.tags
  content_type    = "text/plain"
  expiration_date = formatdate("YYYY-MM-DD'T'00:00:00Z", timeadd(timestamp(), "2160h")) #Today + 90Days

  depends_on = [
    azurerm_key_vault_access_policy.current
  ]
  lifecycle {
    ignore_changes = [
      expiration_date
    ]
  }
}

resource "azurerm_key_vault_secret" "ai" {
  name            = "ai-key"
  value           = azurerm_application_insights.ai.instrumentation_key
  key_vault_id    = azurerm_key_vault.kv.id
  tags            = local.tags
  content_type    = "text/plain"
  expiration_date = formatdate("YYYY-MM-DD'T'00:00:00Z", timeadd(timestamp(), "2160h")) #Today + 90Days

  depends_on = [
    azurerm_key_vault_access_policy.current
  ]

  lifecycle {
    ignore_changes = [
      expiration_date
    ]
  }
}
