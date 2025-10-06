# Lab 05 – Terraform Variables, Locals, and Outputs

## Overview

In this lab, you’ll enhance your Terraform configuration from **Lab 04** by introducing **input variables**, **local variables**, and **output values** to make your code more flexible and reusable.

---

## Objectives

- Add an **input variable** for the environment  
- Use a **tfvars file** and test variable precedence  
- Define **local variables** for tagging  
- Create an **output variable** to display key information  

---

## Step 1: Define Input Variables

Add a new file called `variables.tf`:

```hcl
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "staging"
}
```

---

## Step 2: Create `terraform.tfvars`

Define variable values in `terraform.tfvars`:

```hcl
environment = "demo"
```

You can also override this variable by:
- Exporting as an environment variable:  
  ```bash
  export TF_VAR_environment="prod"
  ```
- Passing directly in the command:  
  ```bash
  terraform apply -var="environment=dev"
  ```

> This demonstrates Terraform’s **variable precedence**: CLI > environment variables > tfvars file > default.

---

## Step 3: Add Local Variables

In `main.tf`, define common tags using locals:

```hcl
locals {
  common_tags = {
    env   = "dev"
    lob   = "banking"
    stage = "alpha"
  }
}
```

Use them in your resource:

```hcl
tags = local.common_tags
```

---

## Step 4: Create Output Variables

Add an output in `outputs.tf`:

```hcl
output "storage_account_name" {
  value = azurerm_storage_account.demo_sa.name
  description = "The name of the created storage account"
}
```

After running `terraform apply`, Terraform will print the value:

```
Outputs:

storage_account_name = "tfremotestorage001"
```

---

## Summary

In **Lab 05**, you learned how to:
- Define and override **input variables**
- Use **locals** for reusable values like tags
- Display key results using **output variables**