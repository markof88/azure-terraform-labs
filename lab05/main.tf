terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.46.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-lab04"
    storage_account_name = "lab04463"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
  required_version = ">= 1.13.1"
}

provider "azurerm" {
  features {}
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "staging"
}

locals {
  common_tags = {
    environment = "dev"
    low         = "banking"
    stage       = "alpha"
  }
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
    environment = local.common_tags.stage
  }
}

output "storage_account_name" {
  description = "The ID of the Storage Account"
  value       = azurerm_storage_account.demo_sa.name
}
