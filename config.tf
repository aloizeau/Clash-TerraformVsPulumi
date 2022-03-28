provider "azurerm" {
  # More information on the authentication methods supported by
  # the AzureRM Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

  skip_provider_registration = true
  features {
    # https://github.com/hashicorp/terraform-provider-azurerm/issues/8968
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

terraform {
  required_version = "1.1.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.2"
    }
  }

  backend "azurerm" {
  }
  #backend "local" {}
}
