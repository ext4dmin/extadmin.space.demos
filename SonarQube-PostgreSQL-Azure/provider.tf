terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.77.0"
    }
  }
  backend "local" {} #"azurerm" {}
}
provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}