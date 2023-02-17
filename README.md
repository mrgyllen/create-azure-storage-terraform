# Create Azure Storage Account

![Azure Storage Account](https://img.shields.io/badge/azure%20Storage%20Account-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Terraform Cloud](https://img.shields.io/badge/terraform%20cloud-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

This is my first attempt at creating a storage account with terraform hcl to be used as a backend state file storage. I have tried to use common/good/best practices and also verified with different lint tools to find bad practices and/or security problems.

Unfortunately, I haven't been able to "fix" all the checks because I choose to use the simplest Azure options on the storage which aren't the best options if the storage is supposed to be used in a production environment. Another problem I had was that I choose terraform cloud for the backend state file (can't use what I am creating, right? catch 22 😊) which uses a runner with a **dynamic** ip address (different every apply) so I can't whitelist it (you need to upgrade to Business Plan to solve that problem) in the security rules.

## Prerequisites

- You need an Azure account and if you don't have one, get a [free one here](https://azure.microsoft.com/en-us/free/).

- Create a service principal (replace [ServicePrincipalName] with a name and [subscription-id] with your id) and copy the JSON output:

    ```bash
    az ad sp create-for-rbac --name [ServicePrincipalName] --role Contributor --scopes /subscriptions/[subscription-id] --sdk-auth
    ```

- Create a local backend file:
  1. Create a terraform [API token](https://app.terraform.io/app/settings/tokens).
  2. Create a new [Terraform Cloud](https://app.terraform.io/) workspace.
  3. Create a terraform backend file, e.g. `config-terraform.tfbackend`. **(Make sure to NOT commit this file in your repo!!)**

    ```text
    hostname     = "app.terraform.io"
    organization = "[your-terraform-cloud-organization]"
    workspaces { name = "[your-newly-created-workspace]" }
    token = "[your-terraform-api-token]"
    ```

- Create variables in your Terraform Cloud workspace (values in the json output)
  1. ARM_CLIENT_ID = [clientId]
  2. ARM_CLIENT_SECRET = [clientSecret] **Mark it as sensitive**
  3. ARM_SUBSCRIPTION_ID = [subscriptionId]
  4. ARM_TENANT_ID = [tenantId]

- If you don't want to change the variables in `variables.tf` you can use a `terraform.tfvars` file to set the variables.

## Execution

1. Execute below terraform commands to deploy the storage

```bash
  terraform init -backend-config=config.terraform.tfbackend
  terraform fmt
  terraform validate
  terraform plan
  terraform apply
```

## Resources

[MS Learn: Store Terraform state in Azure Storage](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)

[MS Learn: Customer-managed keys for Azure Storage encryption](https://learn.microsoft.com/en-us/azure/storage/common/customer-managed-keys-overview)

- Lint and static analysis tools
  - [TFLint](https://github.com/terraform-linters/tflint)
  - [Checkov](https://www.checkov.io/)
  - [tfsec](https://github.com/aquasecurity/tfsec)

- Terraform:
  - [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
  - [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
  - [azurerm_storage_account_network_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules)
  - [azurerm_storage_account_customer_managed_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_customer_managed_key)
  - [azurerm_log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace)
  - [azurerm_log_analytics_storage_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_storage_insights)
  - [azurerm_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault)
  - [azurerm_key_vault_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy)
  - [azurerm_key_vault_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key)
