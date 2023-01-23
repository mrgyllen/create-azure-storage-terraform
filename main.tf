resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name == "" ? module.resource_group_label.id : var.resource_group_name
  location = var.location
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Storage
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_storage_account" "tfstate" {

  name                     = var.storage_account_name == "" ? module.storage_account_label.id : var.storage_account_name
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  access_tier  = "Hot"
  account_kind = "StorageV2"

  identity {
    type = "SystemAssigned"
  }

  # Security
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_container" "tfstate" {

  name                  = module.storage_container_label.id
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# ---------------------------------------------------------------------------------------------------------------------
# Key Vault
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_key_vault" "tfstate" {
  name                       = module.key_vault_label.id
  location                   = azurerm_resource_group.tfstate.location
  resource_group_name        = azurerm_resource_group.tfstate.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.key_vault_sku_name
  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
}

resource "azurerm_key_vault_access_policy" "storage" {
  key_vault_id = azurerm_key_vault.tfstate.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_storage_account.tfstate.identity[0].principal_id

  key_permissions    = ["Get", "Create", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify", ]
  secret_permissions = ["Get", ]
}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = azurerm_key_vault.tfstate.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions    = ["Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify", ]
  secret_permissions = ["Get", ]
}

resource "azurerm_key_vault_key" "tfstate" {
  name         = module.key_vault_label.id
  key_vault_id = azurerm_key_vault.tfstate.id
  key_type     = var.key_vault_key_type
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey", ]

  depends_on = [
    azurerm_key_vault_access_policy.client,
    azurerm_key_vault_access_policy.storage,
  ]
  expiration_date = var.key_vault_key_expiration_date
}

resource "azurerm_storage_account_customer_managed_key" "tfstate" {
  storage_account_id = azurerm_storage_account.tfstate.id
  key_vault_id       = azurerm_key_vault.tfstate.id
  key_name           = azurerm_key_vault_key.tfstate.name
  key_version        = null # null enables automatic key rotation
}
