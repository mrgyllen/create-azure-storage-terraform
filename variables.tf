# company
variable "resource_group_name" {
  description   = "(Required) Specifies the Resource Group where the Azure Storage Account should exist."
  default       = "terraform-state-rg"
  type          = string
}

# environment
variable "environment" {
  type = string
  description = "(Required) This variable defines the environment to be built"
  default = "Dev"
}

# azure region
variable "location" {
  type = string
  description = "(Required) Azure region where resources will be created"
  default = "North Europe"
}
