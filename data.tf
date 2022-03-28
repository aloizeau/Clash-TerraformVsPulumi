data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

data "http" "currentip" {
  url = "http://ipv4.icanhazip.com"
}

data "azurerm_resource_group" "rg" {
  name = local.rg_name
}
