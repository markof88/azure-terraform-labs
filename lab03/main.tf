terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.46.0"
    }
  }
  required_version = ">= 1.13.1"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo_rg" {
  name     = "rg-terraform-demo"
  location = "Germany West Central"
}

resource "azurerm_storage_account" "demo_sa" {
  name                     = "tfstoragedemo001"
  resource_group_name      = azurerm_resource_group.demo_rg.name
  location                 = azurerm_resource_group.demo_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}
