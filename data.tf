# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
# Use this data source to access the configuration of the AzureRM provider.
data "azurerm_client_config" "current" {}

# Get our public IP address
data "http" "myip" {
  url = "https://icanhazip.com/"
}
