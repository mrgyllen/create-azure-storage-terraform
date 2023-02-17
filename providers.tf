# Define Terraform provider
terraform {
  required_version = ">= 1.3.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.42.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.2.1"
    }

    tfe = {
      version = "~> 0.42.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}
# Configure the Azure provider
provider "azurerm" {
  features {}
}
