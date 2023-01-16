# Define Terraform provider
terraform {
  required_version = ">= 1.3"
  
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
