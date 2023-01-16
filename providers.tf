# Define Terraform provider
terraform {
  required_version = ">= 1.3"
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "terraformstate"
    container_name       = "tfstate"
    key                  = "actions.tfstate"
  }
  required_providers {
    azurerm = {
      version = "~>3.30"
      source  = "hashicorp/azurerm"
    }
  }
}
# Configure the Azure provider
provider "azurerm" { 
  features {}  
}
