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
    environment = local.common_tags.environment
  }
}