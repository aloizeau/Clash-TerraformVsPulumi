provider "azurerm" {
  # More information on the authentication methods supported by
  # the AzureRM Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

terraform {
  required_version = "1.1.6"
  required_providers {
    azurerm = "=2.97.0"
  }

  backend "azurerm" {
  }
  #backend "local" {}
}
