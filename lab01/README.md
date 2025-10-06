# Lab 01 – Introduction to Infrastructure as Code (IaC) and Terraform

## Overview

This lab introduces the concept of **Infrastructure as Code (IaC)** and demonstrates how tools like **Terraform** enable automated infrastructure provisioning, management, and destruction across cloud environments.

---

## What is Infrastructure as Code?

Infrastructure as Code (IaC) allows you to **define, provision, and manage infrastructure using code** instead of manual configuration through a web console.  
This approach ensures that your environments are **consistent, repeatable, and version-controlled** — just like your application source code.

---

## Why Use Infrastructure as Code?

You could log in to the Azure (or any cloud) portal and create resources manually — click, drag, drop.  
That’s fine for small, personal setups. But in real-world scenarios:

| Scenario | Manual Setup Time | IaC Setup Time |
|-----------|------------------|----------------|
| Deploy a 3-tier app | ~2 hours | A few minutes |
| Four environments (dev, test, stage, prod) | ~8 hours | Reusable code |
| Hundreds of servers | Not scalable | Automated provisioning |

Challenges with manual provisioning:
- Cost control (idle resources running overnight)
- Environment drift (“works on my machine”)
- Human error and inconsistent configuration
- No automated cleanup or reusability

With IaC, you can:
- **Automate** provisioning and teardown  
- **Reuse** configurations across environments  
- **Version-control** changes  
- **Standardize** deployments across teams  

---

## Benefits of IaC

Consistent environments  
Version-controlled infrastructure  
Faster deployments  
Better cost visibility and automation  
Developers can focus on applications  
Reduced configuration errors  
Automated cleanup and destruction  
Easier troubleshooting with reproducible setups  

---

## What is Terraform?

Terraform is an open-source **Infrastructure as Code (IaC)** tool developed by **HashiCorp**.  
It enables you to describe your infrastructure using declarative configuration files (`.tf`) and deploy resources across multiple cloud providers (Azure, AWS, GCP, etc.).

---

## How Terraform Works

1. **Write** configuration files in HCL (`.tf`)  
2. **Initialize** to download necessary providers and modules  
3. **Validate** configuration syntax and structure  
4. **Plan** to preview what Terraform will create, update, or delete  
5. **Apply** changes by calling the target cloud provider’s API  
6. **Destroy** infrastructure when no longer needed  

---

## Terraform Command Lifecycle

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
