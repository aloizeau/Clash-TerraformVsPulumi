provider "azurerm" {
  # More information on the authentication methods supported by
  # the AzureRM Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  client_id                  = var.client_id
  client_secret              = var.client_secret
  skip_provider_registration = true
  features {}
}

terraform {
  required_version = "1.1.6"
  required_providers {
    azurerm = "=2.97.0"
  }

  # backend "azurerm" {
  #   resource_group_name  = "Clash"
  #   storage_account_name = "clashstate"
  #   container_name       = "tfstates"
  #   key                  = "dev.terraform.tfstate"
  # }
  backend "local" {}
}
