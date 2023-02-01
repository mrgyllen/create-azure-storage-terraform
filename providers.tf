# Define Terraform provider
terraform {
  required_version = ">= 1.3.7"

  required_providers {
    azurerm = {
      version = "~>3.41.0"
      source  = "hashicorp/azurerm"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.2.1"
    }
  }
}
# Configure the Azure provider
provider "azurerm" {
  features {}
}
