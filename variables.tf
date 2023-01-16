resource "random_string" "resource_code" {
  length = 8
  upper = false
  numeric = true
  lower = true
  special = false
}

variable "resource_group_name" {
  description   = "(Required) Specifies the Resource Group where the Azure Storage Account should exist."
  default       = "terraform-state-rg"
  type          = string
}

variable "storage_account_name" {
  description   = "(Required) Specifies the Azure Storage Acccount name."
  default       = "terraformstate${random_string.resource_code.result}"
  type          = string
}

variable "storage_container_name" {
  description   = "(Required) Specifies the storage container name to be used for terraform state."
  default       = "tfstate"
  type          = string
}

variable "environment" {
  type = string
  description = "(Required) This variable defines the environment tag"
  default = "Dev"
}

variable "location" {
  type = string
  description = "(Required) Azure region where resources will be created"
  default = "North Europe"
}
