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

output "my_public_ip" {
  value = [chomp(data.http.myip.response_body)]
}

# ---------------------------------------------------------------------------------------------------------------------
# Key Vault Attributes
# ---------------------------------------------------------------------------------------------------------------------
### The Key Vault ###
#output "key_vault_id" {
#  value       = azurerm_key_vault.tfstate.id
#  description = ""
#}

### the Key Vault Key ###
#output "key_vault_key_id" {
#  value       = azurerm_key_vault_key.tfstate.id
#  description = "The Key Vault Key ID"
#}

#output "key_vault_key_version" {
#  value       = azurerm_key_vault_key.tfstate.version
#  description = "The current version of the Key Vault Key."
#}
