variable "default_tags" {
  description = "Default billing tags to be applied across all resources"
  type        = map(string)
  default     = {}
}

variable "storage_account_tier" {
  type        = string
  default     = "Standard"
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium"
}
variable "storage_account_replication_type" {
  type        = string
  default     = "GRS"
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
}

variable "key_vault_key_type" {
  type        = string
  default     = "RSA"
  description = "Specifies the Key Type to use for this Key Vault Key. For Terraform state, supply RSA or RSA-HSM."
}

variable "key_vault_sku_name" {
  type        = string
  default     = "standard"
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium."
}

variable "key_vault_key_expiration_date" {
  type        = string
  default     = "2023-12-31T23:59:00Z"
  description = "Expiration of the Key Vault Key, in UTC datetime (Y-m-d'T'H:M:S'Z')."
}

# ---------------------------------------------------------------------------------------------------------------------
# rg_label_ - resource group label variables - used in terraform-null-label
# ---------------------------------------------------------------------------------------------------------------------

variable "rg_label_namespace" {
  description = "Namespace, which could be your organization name. First item in naming sequence."
  default     = ""
  type        = string
}

variable "rg_label_stage" {
  description = "Stage, e.g. `prod`, `staging`, `dev`, or `test`. Second item in naming sequence."
  default     = ""
  type        = string
}

variable "rg_label_name" {
  description = "Name, which could be the name of your solution or app. Third item in naming sequence."
  default     = ""
  type        = string
}

variable "rg_label_attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes, e.g. `1`"
}

variable "rg_label_delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between (1) `namespace`, (2) `name`, (3) `stage` and (4) `attributes`"
}

variable "resource_group_name" {
  default     = ""
  type        = string
  description = "The resource group name. If not provided, the resource group will be generated by the label module in the format namespace-stage-name"
}

variable "storage_account_name" {
  type        = string
  default     = ""
  description = "Storage account name. If not provided, the name will be generated by the label module in the format namespace-stage-name. Must be 3-24	characters, with lowercase letters and numbers only."
}

variable "environment" {
  type = string
  description = "This variable defines the environment tag"
  default = "staging"
}

variable "location" {
  type = string
  description = "(Required) Azure region where resources will be created"
  default = "North Europe"
}
