resource "azurerm_resource_group" "state-rg" {
  name     = var.resource_group_name
  location = var.location
  
  lifecycle {
    prevent_destroy = true
  }
  
  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_account" "state-sta" {
  depends_on = [azurerm_resource_group.state-rg]
  
  name                      = var.storage_account_name
  resource_group_name       = azurerm_resource_group.state-rg.name
  location                  = azurerm_resource_group.state-rg.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  allow_blob_public_access  = false

  lifecycle {
    prevent_destroy = true
  }
  
  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_container" "tfstate" {
  depends_on = [azurerm_storage_account.state-sta]
  
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.state-sta.name
  container_access_type = "private"
}
