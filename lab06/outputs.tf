output "storage_account_name" {
  description = "The ID of the Storage Account"
  value       = azurerm_storage_account.demo_sa.name
}