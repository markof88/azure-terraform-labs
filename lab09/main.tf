resource "azurerm_resource_group" "example" {
  lifecycle {
    create_before_destroy = true
  }

  name     = "${var.environment}-resources"
  location = var.allowed_locations[2]
  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_account" "example" {
  for_each                 = var.sa_name
  name                     = each.value
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}
