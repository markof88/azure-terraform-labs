```markdown
# Lab 06 – Split Terraform Configuration into Multiple Files

## Goal

In this lab, you will refactor your configuration from **Lab 05** into separate `.tf` files for better structure, readability, and maintainability.  
Terraform automatically loads **all `.tf` files** in the same directory, regardless of their names or order.

---

## Suggested Folder Structure

```

lab06/
├── backend.tf
├── provider.tf
├── resource-group.tf
├── storage-account.tf
├── locals.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars

````

> 💡 **Note:** The file order does not matter — Terraform automatically loads all `.tf` files in the working directory.

---

## backend.tf

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-lab04"
    storage_account_name = "lab04463"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.46.0"
    }
  }

  required_version = ">= 1.13.1"
}
````

---

## provider.tf

```hcl
provider "azurerm" {
  features {}
}
```

---

## variables.tf

```hcl
variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "staging"
}
```

---

## locals.tf

```hcl
locals {
  common_tags = {
    env   = "dev"
    lob   = "banking"
    stage = "alpha"
  }
}
```

---

## resource-group.tf

```hcl
resource "azurerm_resource_group" "demo_rg" {
  name     = "rg-terraform-demo"
  location = "Germany West Central"
  tags     = local.common_tags
}
```

---

## storage-account.tf

```hcl
resource "azurerm_storage_account" "demo_sa" {
  name                     = "tfstoragedemo001"
  resource_group_name      = azurerm_resource_group.demo_rg.name
  location                 = azurerm_resource_group.demo_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = merge(local.common_tags, {
    environment = var.environment
  })
}
```

---

## outputs.tf

```hcl
output "storage_account_name" {
  description = "The name of the created Storage Account"
  value       = azurerm_storage_account.demo_sa.name
}
```

---

## terraform.tfvars

```hcl
environment = "demo"
```

---

## Commands

Run the following Terraform commands:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

---

````
