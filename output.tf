# ---------------------------------------------------------------------------------------------------------------------
# Resource Group attributes
# ---------------------------------------------------------------------------------------------------------------------

output "resource_group_id" {
  value       = azurerm_resource_group.tfstate.id
  description = "The ID of the Resource Group."
}

output "resource_group_name" {
  value       = azurerm_resource_group.tfstate.name
  description = "The name of the resource group"
}

# ---------------------------------------------------------------------------------------------------------------------
# Storage Account attributes:
# ---------------------------------------------------------------------------------------------------------------------
output "storage_account_id" {
  value       = azurerm_storage_account.tfstate.id
  description = "The ID of the Storage Account"
}

output "storage_account_primary_location" {
  value       = azurerm_storage_account.tfstate.primary_location
  description = "The primary location of the storage account."
}

output "storage_account_primary_blob_endpoint" {
  value       = azurerm_storage_account.tfstate.primary_blob_endpoint
  description = "The endpoint URL for blob storage in the primary location."
}

output "storage_account_primary_access_key" {
  value       = azurerm_storage_account.tfstate.primary_access_key
  description = "The primary access key for the storage account. This value is sensitive and masked from Terraform output."
  sensitive   = true
}

# ---------------------------------------------------------------------------------------------------------------------
# Storage Container attributes
# ---------------------------------------------------------------------------------------------------------------------

output "storage_container_id" {
  value       = azurerm_storage_container.tfstate.id
  description = "The ID of the Storage Container."
}

output "storage_container_has_immutability_policy" {
  value       = azurerm_storage_container.tfstate.has_immutability_policy
  description = "Is there an Immutability Policy configured on this Storage Container?"
}

output "storage_container_has_legal_hold" {
  value       = azurerm_storage_container.tfstate.has_legal_hold
  description = "Is there a Legal Hold configured on this Storage Container?"
}

output "storage_container_resource_manager_id" {
  value       = azurerm_storage_container.tfstate.resource_manager_id
  description = "The Resource Manager ID of this Storage Container."
}

# ---------------------------------------------------------------------------------------------------------------------
# Misc outputs
# ---------------------------------------------------------------------------------------------------------------------

output "my_public_ip" {
  value       = [chomp(data.http.myip.response_body)]
  description = "My(client) public ip adress."
}

output "key_vault_sku_name" {
  value       = azurerm_key_vault.tfstate.sku_name
  description = "Selected SKU on KeyVault."
}

output "terraform_ip_notifications_ranges" {
  value       = data.tfe_ip_ranges.addresses.notifications
  description = "Terraform Cloud notifications ip ranges."
}
