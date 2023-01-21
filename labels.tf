# Resource Group
# https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules#microsoftresources
# Length: 1-90 characters
# Valid Characters: Underscores, hyphens, periods, parentheses, and letters or digits as defined by the Char.IsLetterOrDigit function.
# Valid characters are members of the following categories in UnicodeCategory: UppercaseLetter, LowercaseLetter,TitlecaseLetter, ModifierLetter, OtherLetter, DecimalDigitNumber
# Can't end with period.
module "resource_group_label" {
  source       = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  namespace    = var.namespace
  stage        = var.stage
  name         = var.name
  attributes   = var.attributes
  delimiter    = "-"
  convert_case = true
  tags         = var.default_tags
  enabled      = var.resource_group_name == "" ? true : false
}

# Storage Account
# https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules#microsoftstorage
# Length: 3-24 characters
# Valid Characters: Lowercase letters and numbers only
module "storage_account_label" {
  source       = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  namespace    = var.namespace
  stage        = var.stage
  name         = var.name
  attributes   = var.attributes
  delimiter    = ""
  convert_case = true
  tags         = var.default_tags
  enabled      = var.storage_account_name == "" ? true : false
}

# Storage Container Label
# https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules#microsoftstorage
# Length: 3-63 characters
# Valid Characters: Lowercase letters, numbers, and hyphens. Start with lowercase letter or number. Can't use consecutive hyphens.
module "storage_container_label" {
  source       = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  namespace    = var.namespace
  stage        = var.stage
  name         = var.name
  attributes   = var.attributes
  delimiter    = "-"
  convert_case = true
  tags         = var.default_tags
  enabled      = var.storage_account_name == "" ? true : false
}

# Key Vault
# https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules#microsoftkeyvault
# Length: 3-24 characters
# Valid charachters: Alphanumerics and hyphens. Start with letter. End with letter or digit. Can't contain consecutive hyphens.
module "key_vault_label" {
  source       = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  namespace    = var.namespace
  stage        = var.stage
  name         = var.name
  attributes   = var.attributes
  delimiter    = "-"
  convert_case = true
  tags         = var.default_tags
  enabled      = var.storage_account_name == "" ? true : false
}
