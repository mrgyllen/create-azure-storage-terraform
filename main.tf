# ---------------------------------------------------------------------------------------------------------------------
# locals . ip_rules
# If you don't want any ip_rules, the below local variables should be deleted.
# Below config white lists terraform cloud notifications ip ranges.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  terraform_ip_range = [for i in data.tfe_ip_ranges.addresses.notifications : replace(i, "/32", "")]
  client_ip          = chomp(data.http.myip.response_body)
  ip_rules           = concat(local.terraform_ip_range, [local.client_ip], [var.client_machine_pip])
}

# Random number used in Key Vault name must be maximum 24 chars long. 
# Make sure you use a correct length on the random string!
resource "random_string" "resource_code" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = module.resource_group_label.id
  location = var.location
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Storage
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_storage_account" "tfstate" {
  # checkov:skip=CKV_AZURE_206: This storage account is a basic (inexpensive) example and doesn't use > LRS for replication
  # checkov:skip=CKV_AZURE_59: Checkov misses that the field 'allow_blob_public_access' is renamed to 'allow_nested_items_to_be_public' and is set correctly
  # Azure Resource Manager: 3.0 Upgrade Guide - The field 'allow_blob_public_access' is renamed to 'allow_nested_items_to_be_public'
  name                     = module.storage_account_label.id
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  access_tier              = "Hot"
  account_kind             = "StorageV2"

  identity {
    type = "SystemAssigned"
  }

  # Security
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  shared_access_key_enabled       = true # enable to access the storage account with key
  allow_nested_items_to_be_public = false

  queue_properties {
    logging {
      delete                = true
      read                  = true
      version               = "2.0"
      write                 = true
      retention_policy_days = "10"
    }
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_container" "tfstate" {

  name                  = module.storage_container_label.id
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# Set the network rules
resource "azurerm_storage_account_network_rules" "tfstate" {
  storage_account_id = azurerm_storage_account.tfstate.id

  default_action = "Deny"
  ip_rules       = [for i in local.ip_rules : i]
  bypass         = ["Logging", "Metrics", "AzureServices"]

  depends_on = [
    azurerm_storage_container.tfstate
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Storage Logging
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_log_analytics_workspace" "tfstate" {
  name                = "tfstate-log-workspace"
  location            = azurerm_resource_group.tfstate.location
  resource_group_name = azurerm_resource_group.tfstate.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_storage_insights" "tfstate" {
  name                = "tfstate-storageinsightconfig"
  resource_group_name = azurerm_resource_group.tfstate.name
  workspace_id        = azurerm_log_analytics_workspace.tfstate.id

  storage_account_id   = azurerm_storage_account.tfstate.id
  storage_account_key  = azurerm_storage_account.tfstate.primary_access_key
  blob_container_names = [azurerm_storage_container.tfstate.name]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure KeyVault
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_key_vault" "tfstate" {
  # checkov:skip=CKV_AZURE_109: Checkov misses that default_action = "Deny" is already set correct nu I also need to set it to Allow because I dont have terrafrom runner ips to white-list.
  name                       = "${module.key_vault_label.id}-${random_string.resource_code.result}"
  location                   = azurerm_resource_group.tfstate.location
  resource_group_name        = azurerm_resource_group.tfstate.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.key_vault_sku_name
  purge_protection_enabled   = var.purge_protection
  soft_delete_retention_days = 90

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices" # Allows all azure services to access your keyvault. Can be set to 'None'
    ip_rules       = [for i in local.ip_rules : i]
  }
}

resource "azurerm_key_vault_access_policy" "storage" {
  key_vault_id = azurerm_key_vault.tfstate.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_storage_account.tfstate.identity[0].principal_id

  key_permissions    = ["Get", "Create", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify", ]
  secret_permissions = ["Get", ]

  depends_on = [
    azurerm_storage_container.tfstate
  ]
}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = azurerm_key_vault.tfstate.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  lifecycle {
    create_before_destroy = true
  }

  key_permissions         = var.kv-key-permissions-full
  secret_permissions      = var.kv-secret-permissions-full
  certificate_permissions = var.kv-certificate-permissions-full
  storage_permissions     = var.kv-storage-permissions-full
}

resource "azurerm_key_vault_key" "tfstate" {
  # checkov:skip=CKV_AZURE_112: Ensure key vault key is backed by HSM
  #   This is a basic KeyVault with standard SKU and HSM can only be used with a premium SKU KeyVault
  #   https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys
  name            = module.key_vault_label.id
  key_vault_id    = azurerm_key_vault.tfstate.id
  key_type        = var.key_vault_key_type
  key_size        = 2048
  expiration_date = "2023-12-31T23:59:59Z"
  key_opts        = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey", ]

  depends_on = [
    azurerm_key_vault_access_policy.client,
    azurerm_key_vault_access_policy.storage,
  ]
}

resource "azurerm_storage_account_customer_managed_key" "tfstate" {
  storage_account_id = azurerm_storage_account.tfstate.id
  key_vault_id       = azurerm_key_vault.tfstate.id
  key_name           = azurerm_key_vault_key.tfstate.name
  key_version        = null # null enables automatic key rotation
}
