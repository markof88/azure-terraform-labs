terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-lab04"
    storage_account_name = "lab04463"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
