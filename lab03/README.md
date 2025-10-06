# Lab 03 – Azure Authentication, Resource Group & Storage Account with Terraform

## Overview

In this lab, you’ll explore **how Terraform authenticates and authorizes access to Azure**, and how to use the **AzureRM provider** to create foundational Azure resources — a **Resource Group** and a **Storage Account**.

You’ll also learn about **resource dependencies** and how Terraform automatically handles them during provisioning.

---

## Learning Objectives

By the end of **Lab 03**, you will understand:

- **Authentication and Authorization** with Azure using a Service Principal  
- How to create a **Resource Group** with Terraform  
- How to manage a **Storage Account** declaratively  
- How Terraform automatically manages **resource dependencies**  
- How to write clean, modular Terraform **code samples**

---

## Step 1: Review AzureRM Provider Documentation

Start by exploring the official Terraform provider documentation:

🔗 [Terraform Registry – AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

It explains:
- Resource definitions (e.g., `azurerm_resource_group`, `azurerm_storage_account`)  
- Arguments and attributes for each resource  
- Authentication options  
- Version compatibility  

---

## Step 2: Authentication and Authorization

Terraform uses Azure credentials to perform actions via the **Azure Resource Manager (ARM) API**.  
The recommended authentication method is a **Service Principal (SP)**.

### Log in to Azure

```bash
az login
```

### Create a Service Principal

Run the following command (replace `$SUBSCRIPTION_ID` with your actual ID):

```bash
az ad sp create-for-rbac -n az-demo --role="Contributor" --scopes="/subscriptions/$SUBSCRIPTION_ID"
```

This command:
- Creates a Service Principal named **az-demo**
- Assigns it the **Contributor** role
- Limits its scope to your subscription

Azure will output JSON containing credentials:

```json
{
  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "displayName": "az-demo",
  "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

---

## Step 3: Set Environment Variables

To authenticate Terraform securely, export the Service Principal credentials as environment variables:

```bash
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_SUBSCRIPTION_ID="<subscriptionId>"
export ARM_TENANT_ID="<tenant>"
```

✅ This prevents credentials from being hardcoded into Terraform files and enables non-interactive authentication for CI/CD or automation pipelines.

---

## Step 4: Terraform Configuration – Code Sample

Below is the Terraform configuration used in this lab:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.46.0"
    }
  }
  required_version = ">= 1.13.1"
}

provider "azurerm" {
  features {}
}

# ---------------------------
# Resource Group
# ---------------------------
resource "azurerm_resource_group" "demo_rg" {
  name     = "rg-terraform-demo"
  location = "West Europe"
}

# ---------------------------
# Storage Account
# ---------------------------
resource "azurerm_storage_account" "demo_sa" {
  name                     = "tfstoragedemo001"
  resource_group_name      = azurerm_resource_group.demo_rg.name
  location                 = azurerm_resource_group.demo_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

---

## Step 5: Understanding Dependencies

Notice how the storage account references:

```hcl
resource_group_name = azurerm_resource_group.demo_rg.name
```

Terraform automatically understands this dependency — it will **create the Resource Group first** before the Storage Account.

You don’t need to define dependency rules manually; Terraform’s **dependency graph** handles this automatically.

---

## Step 6: Initialize and Apply

Run the following Terraform workflow:

```bash
terraform init
terraform plan
terraform apply
```

Confirm the deployment when prompted.

To clean up:

```bash
terraform destroy
```

Terraform will remove all resources safely, respecting dependency order.

---

## Summary

In **Lab 03**, you learned how to:

- Authenticate Terraform to Azure with a Service Principal  
- Use environment variables for secure authorization  
- Create and manage a Resource Group and Storage Account  
- Understand and leverage Terraform’s dependency management  
- Write reusable, declarative Terraform configurations  

---
