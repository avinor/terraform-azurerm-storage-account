output "id" {
  description = "Id of the storage account created."
  value       = azurerm_storage_account.storage.id
}

output "name" {
  description = "Name of the storage account created."
  value       = azurerm_storage_account.storage.name
}