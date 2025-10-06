# Lab 02 – Understanding Terraform Providers

## Overview

In this lab, you’ll explore **Terraform Providers** — the building blocks that let Terraform talk to cloud platforms and external services. You’ll learn what providers are, how versioning works, and why version constraints matter for reliable automation.

---

## What is a Terraform Provider?

A **provider** in Terraform is a **plugin** that lets Terraform communicate with a service’s **API**. Each provider exposes resources and data sources for that service.

Examples:
- **AzureRM Provider** → Azure resources
- **AWS Provider** → AWS infrastructure
- **Kubernetes Provider** → Kubernetes objects
- **Random Provider** → Demo-friendly random IDs/strings

Terraform uses providers to **translate HCL into real API calls** that create/manage infrastructure.

---

## Provider Structure Example

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

- **required_providers**: declares providers Terraform should use  
- **source**: origin (HashiCorp, community, custom)  
- **version**: which version to install  
- **provider block**: provider-specific settings (e.g., credentials, region)

---

## Provider Version vs Terraform Core Version

Terraform has two separate version tracks:

| Component            | Description                                  |
|---------------------|----------------------------------------------|
| **Terraform Core**  | CLI + engine that runs plans/applies         |
| **Provider Plugin** | Extension that talks to a specific service   |

They evolve independently. Compatibility depends on both versions.

---

## Why Provider Versioning Matters

Pinning provider versions ensures **stability and reproducibility**. Without constraints, auto-upgrades can:
- Introduce breaking changes  
- Alter resource behavior  
- Cause unexpected diffs during `terraform plan`

Locking versions keeps behavior consistent across machines and time.

---

## Version Constraints and Operators

| Operator | Example       | Meaning                                         |
|---------:|---------------|-------------------------------------------------|
| `=`      | `= 4.2.0`     | Exactly version 4.2.0                           |
| `!=`     | `!= 4.0.0`    | Any version except 4.0.0                        |
| `>`      | `> 3.0.0`     | Greater than 3.0.0                              |
| `<`      | `< 5.0.0`     | Less than 5.0.0                                 |
| `>=`     | `>= 3.5.0`    | 3.5.0 or higher                                 |
| `<=`     | `<= 4.0.0`    | 4.0.0 or lower                                  |
| `~>`     | `~> 4.2`      | Patch/minor updates allowed (e.g., 4.2.x), no major bump |

**Tip:** Use `~>` for safe minor/patch updates; pin exact versions for strict reproducibility.

---

## Summary

After **Lab 02**, you should understand:
- What providers are and how they interact with APIs  
- The difference between Terraform core and provider versions  
- Why and how to constrain provider versions

---

## Optional Diagram

Add a diagram (e.g., `terraform ↔ provider ↔ cloud API`) as `diagram.png` or `diagram.mmd` and link it here.
