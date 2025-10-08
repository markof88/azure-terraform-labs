output "rgname" {
  description = "The name of the Resource Group"
  value       = azurerm_resource_group.example.name
}

output "sa_names" {
  description = "The names of the Storage Accounts"
  value       = [for i in azurerm_storage_account.example : i.name]
}
