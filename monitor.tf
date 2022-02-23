resource "azurerm_log_analytics_workspace" "monitor" {
  name                = local.log_analytics_workspace_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "PerGB2018"
  tags                = local.tags
}

resource "azurerm_log_analytics_solution" "ci" {
  solution_name         = "ContainerInsights"
  resource_group_name   = azurerm_log_analytics_workspace.monitor.resource_group_name
  location              = azurerm_log_analytics_workspace.monitor.location
  workspace_resource_id = azurerm_log_analytics_workspace.monitor.id
  workspace_name        = azurerm_log_analytics_workspace.monitor.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
  tags = local.tags
}

resource "azurerm_application_insights" "ai" {
  name                = local.application_insights_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = azurerm_log_analytics_workspace.monitor.location
  application_type    = "web"
  tags                = local.tags
}
