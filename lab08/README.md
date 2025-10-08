# Lab 08 – Using `count`, `for_each`, and `for` in Terraform

## Goal

In this lab, you will learn how to **create multiple resources** dynamically in Terraform using:  
- `count`  
- `for_each`  
- `for` expressions  

These features help make configurations **more scalable and reusable** by avoiding repetitive code.

---

## Key Concepts

### `count`
- Creates **multiple instances** of a resource based on a numeric value.  
- Each instance can be referenced with an **index** (`count.index`).

### `for_each`
- Iterates over **maps** or **sets** to create resources.  
- Each instance is referenced by a **key**, not an index.

### `for` Expression
- Used to **transform or filter** lists and maps.  
- Commonly used in **locals** and **outputs**.

---

## `variables.tf`

```hcl
variable "storage_account_names_list" {
  description = "List of storage account names (for count example)"
  type        = list(string)
  default     = ["tfcountdemo001", "tfcountdemo002"]
}

variable "storage_account_names_set" {
  description = "Set of storage account names (for for_each example)"
  type        = set(string)
  default     = ["tfforeachdemo001", "tfforeachdemo002"]
}

variable "resource_group_name" {
  description = "Resource group for all storage accounts"
  type        = string
  default     = "rg-terraform-lab08"
}

variable "location" {
  description = "Azure region for storage accounts"
  type        = string
  default     = "Germany West Central"
}
````
main.tf – Using count, for_each, and for
1️⃣ Create Multiple Storage Accounts Using count
hcl
Code kopieren
resource "azurerm_storage_account" "count_demo" {
  count                    = length(var.storage_account_names_list)
  name                     = var.storage_account_names_list[count.index]
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    method = "count"
  }
}
2️⃣ Create Multiple Storage Accounts Using for_each
hcl
Code kopieren
resource "azurerm_storage_account" "foreach_demo" {
  for_each                 = var.storage_account_names_set
  name                     = each.value
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    method = "for_each"
  }
}
3️⃣ Output Storage Account Names and IDs Using a for Loop
hcl
Code kopieren
output "count_storage_accounts" {
  description = "List of storage account names created with count"
  value       = [for sa in azurerm_storage_account.count_demo : sa.name]
}

output "foreach_storage_ids" {
  description = "Map of storage account IDs created with for_each"
  value       = { for k, sa in azurerm_storage_account.foreach_demo : k => sa.id }
}

Run Commands
bash
Code kopieren
terraform init
terraform validate
terraform plan
terraform apply -auto-approve

Example Output
text
Code kopieren
Outputs:

count_storage_accounts = [
  "tfcountdemo001",
  "tfcountdemo002"
]

foreach_storage_ids = {
  "tfforeachdemo001" = "/subscriptions/.../storageAccounts/tfforeachdemo001"
  "tfforeachdemo002" = "/subscriptions/.../storageAccounts/tfforeachdemo002"
}

Summary
In Lab 08, you learned how to:

Use count to create multiple resources from a list

Use for_each to iterate over sets or maps

Use for expressions to transform data for outputs

Simplify your Terraform code and avoid repetition

💡 These iteration constructs are fundamental for creating modular and scalable Terraform configurations.