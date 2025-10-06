# Lab 04 – Terraform State File & Remote Backend

## Overview

In this lab, you’ll learn how **Terraform tracks and manages your infrastructure state**, why the **state file** is critical, and how to configure a **remote backend** for secure, collaborative management of your Terraform projects.

You’ll also practice deploying Azure resources (a **Resource Group** and a **Storage Account**) while storing the state remotely in **Azure Blob Storage**.

---

## How Terraform Manages Infrastructure

Terraform follows a **“desired state”** model:

1. You define your **desired infrastructure** in configuration files (`.tf`).
2. Terraform compares it with the **current, real-world state** of your resources.
3. It calculates the **changes** needed to make both states match.

The **goal** is to keep your **actual infrastructure state** identical to your **desired configuration**.

---

## What Is the Terraform State File?

Terraform stores the current state of your infrastructure in a file called the **state file** (`terraform.tfstate`).  
This file contains metadata about all managed resources — names, IDs, configurations, dependencies, etc.

Terraform uses this file to:
- Know what resources already exist  
- Detect configuration drift  
- Plan only necessary changes  
- Support resource destruction in the correct order

![IMG_0015](https://github.com/user-attachments/assets/35b4270e-dd68-44a8-ad55-66c46eda8441)

Example workflow:

```bash
terraform plan
terraform apply
```

During `apply`, Terraform updates both the real infrastructure **and** the local or remote state file.

---

## Why Remote State Matters

By default, Terraform saves its state **locally** (as `terraform.tfstate` in your project folder).  
That’s fine for quick demos — but risky in real environments.

### Problems with local state:
- Difficult to share between team members  
- Easy to lose or overwrite  
- Can expose sensitive data if checked into Git accidentally  

### Benefits of remote state:
- Centralized and shared between team members  
- Secure storage with access control  
- Versioning and state locking to prevent corruption  
- Integrated with automation pipelines (CI/CD)

---

## State File Best Practices

- Prefer **remote backends** for real projects (Azure Blob, AWS S3, Terraform Cloud, etc.)  
- Enable **state locking** when multiple users or CI/CD pipelines may run Terraform simultaneously  
- Backup your state regularly

![IMG_0016](https://github.com/user-attachments/assets/6b014983-1396-4531-8d8c-0644cbcfd94e)

---

## Assignment: Create Azure Resources Using a Remote Backend

### Task

Configure Terraform to store the state file in **Azure Blob Storage**, and deploy:
- A **Resource Group**
- A **Storage Account**

### Example Steps

1. **Create a Storage Account and Container** (manually or via CLI):
   ```bash
   az group create -n rg-tfstate-demo -l "Germany West Central"
   az storage account create -n tfstatestorage001 -g rg-tfstate-demo -l "Germany West Central" --sku Standard_LRS
   az storage container create -n tfstate --account-name tfstatestorage001
   ```

2. **Update your Terraform backend configuration**:
   ```hcl
   terraform {
     backend "azurerm" {
       resource_group_name   = "rg-tfstate-demo"
       storage_account_name  = "tfstatestorage001"
       container_name        = "tfstate"
       key                   = "terraform.tfstate"
     }

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

   resource "azurerm_resource_group" "demo_rg" {
     name     = "rg-terraform-remote"
     location = "Germany West Central"
   }

   resource "azurerm_storage_account" "demo_sa" {
     name                     = "tfremotestorage001"
     resource_group_name      = azurerm_resource_group.demo_rg.name
     location                 = azurerm_resource_group.demo_rg.location
     account_tier             = "Standard"
     account_replication_type = "LRS"
   }
   ```

3. **Initialize and deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Verify remote state**:
   - Check your Azure Storage container — a `terraform.tfstate` blob should exist there.

---

## Summary

In **Lab 04**, you learned:
- How Terraform uses the state file to track resources  
- Why keeping state consistent is essential  
- The risks of local state and advantages of remote backends  
- How to configure Azure Blob Storage as a Terraform backend
