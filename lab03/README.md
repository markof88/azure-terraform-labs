# Lab 03 – Terraform Azure Provider: Resource Group & Storage Account

## Overview

In this lab, you’ll use the **Terraform AzureRM provider** to create two fundamental Azure resources:
- A **Resource Group**
- A **Storage Account**

You’ll also learn how to authenticate Terraform with Azure using a **Service Principal** and environment variables — a best practice for secure automation.

---

## Step 1: Explore the Terraform AzureRM Provider

Before writing code, get familiar with the official provider documentation:

🔗 [Terraform Registry – AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

The documentation lists:
- Supported resources and data sources  
- Argument references  
- Usage examples  
- Version requirements  

Understanding this documentation is key to writing clean, reusable Terraform code.

---

## Step 2: Log in to Azure

First, authenticate to Azure using the CLI:

```bash
az login
```

This opens a browser window for your Azure account authentication and displays subscription details in the terminal.

---

## Step 3: Create a Service Principal

Terraform uses Azure credentials to deploy infrastructure.  
A **Service Principal (SP)** provides programmatic access to Azure resources without relying on your personal login.

Run the following command to create one:

```bash
az ad sp create-for-rbac -n az-demo --role="Contributor" --scopes="/subscriptions/$SUBSCRIPTION_ID"
```

This command:
- Creates a Service Principal named `az-demo`
- Assigns the **Contributor** role
- Scopes permissions to your specific Azure subscription

After running it, Azure will return output similar to:

```json
{
  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "displayName": "az-demo",
  "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

---

## Step 4: Set Environment Variables

Terraform reads Azure credentials from environment variables.  
Use the values generated from the previous step to set them:

```bash
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_SUBSCRIPTION_ID="<subscriptionId>"
export ARM_TENANT_ID="<tenant>"
```

✅ These exports ensure that Terraform can authenticate to Azure using your Service Principal securely — without embedding credentials in configuration files.

> **Tip:** You can add these exports to a `.env` or `terraform.auto.tfvars` file (excluded via `.gitignore`) for easier reuse.

---

## Step 5: Create Terraform Configuration

Once authenticated, create your Terraform configuration file (e.g., `main.tf`) to define Azure resources.

Example:

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

# Create Resource Group
resource "azurerm_resource_group" "demo_rg" {
  name     = "rg-terraform-demo"
  location = "West Europe"
}

# Create Storage Account
resource "azurerm_storage_account" "demo_sa" {
  name                     = "tfstoragedemo001"
  resource_group_name      = azurerm_resource_group.demo_rg.name
  location                 = azurerm_resource_group.demo_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

---

## Step 6: Run Terraform Commands

Initialize Terraform and deploy the resources:

```bash
terraform init
terraform plan
terraform apply
```

To clean up the resources later:

```bash
terraform destroy
```

---

## Summary

By completing **Lab 03**, you will have learned how to:
- Authenticate Terraform with Azure using a Service Principal  
- Set up environment variables securely  
- Use the AzureRM provider to create a Resource Group and Storage Account  
- Apply and destroy Terraform-managed infrastructure  

---