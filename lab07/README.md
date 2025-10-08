# Lab 07 – Variable Type Constraints in Terraform

## Goal

Using the configuration from **Lab 06**, this lab introduces **type constraints** for variables in Terraform.  
You’ll define multiple variable types — strings, numbers, booleans, lists, maps, tuples, and objects — to make your configuration more predictable and type-safe.

> **Note:** Terraform variable names **cannot include hyphens (`-`)**.  
> Use underscores (`_`) instead, e.g., `storage_disk`, `allowed_locations`.

---

## Files Used in This Lab

- `variables.tf` – defines variables and their type constraints  
- `terraform.tfvars` – contains example values  
- other files from **Lab 06** – reused to test and apply variable usage  

---

## `variables.tf` – define variables with type constraints

```hcl
variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "staging"

  validation {
    condition     = can(regex("^(dev|staging|prod)$", var.environment))
    error_message = "Environment must be one of: dev, staging, or prod."
  }
}

variable "storage_disk" {
  description = "Storage or VM disk size (GB)"
  type        = number
  default     = 64
}

variable "is_delete" {
  description = "If true, resources are destroyed fully during terraform destroy"
  type        = bool
  default     = true
}

variable "allowed_locations" {
  description = "Permitted Azure regions"
  type        = list(string)
  default     = ["Germany West Central", "West Europe", "North Europe"]
}

variable "resource_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {
    lob   = "banking"
    stage = "alpha"
  }
}

variable "network_config" {
  description = "Tuple with VNet CIDR, subnet CIDR, and SSH port"
  type        = tuple([string, string, number])
  default     = ["10.10.0.0/16", "10.10.1.0/24", 22]
}

variable "allowed_vm_sizes" {
  description = "List of allowed VM sizes"
  type        = list(string)
  default     = ["Standard_B2s", "Standard_D2s_v5"]
}

variable "vm_config" {
  description = "Virtual machine configuration object"
  type = object({
    size      = string
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    size      = "Standard_B2s"
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  validation {
    condition     = contains(var.allowed_vm_sizes, var.vm_config.size)
    error_message = "vm_config.size must be one of the values in allowed_vm_sizes."
  }
}
````

## `terraform.tfvars – example values`
```hcl
environment       = "demo"
storage_disk      = 128
is_delete         = true
allowed_locations = ["Germany West Central", "West Europe"]

resource_tags = {
  lob   = "payments"
  stage = "beta"
  env   = "demo"
}

network_config = ["10.20.0.0/16", "10.20.1.0/24", 2222]

allowed_vm_sizes = ["Standard_B2s", "Standard_D2s_v5"]

vm_config = {
  size      = "Standard_D2s_v5"
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts"
  version   = "latest"
}
````

## `Example Usage in Resources`
resource Group – Validate Location
```hcl
locals {
  chosen_location_is_allowed = contains(var.allowed_locations, "Germany West Central")
}

resource "azurerm_resource_group" "demo_rg" {
  name     = "rg-terraform-demo"
  location = "Germany West Central"

  tags = merge(var.resource_tags, {
    environment = var.environment
  })

  lifecycle {
    precondition {
      condition     = local.chosen_location_is_allowed
      error_message = "Selected location is not in allowed_locations."
    }
  }
}
````

## `Storage Account – Apply Tags and Environment`
```hcl
resource "azurerm_storage_account" "demo_sa" {
  name                     = "tfstoragedemo001"
  resource_group_name      = azurerm_resource_group.demo_rg.name
  location                 = azurerm_resource_group.demo_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = merge(var.resource_tags, {
    environment = var.environment
  })
}
````

## `Example (Optional) – Using the vm_config Object`
For future labs when you add a VM resource:

```hcl
locals {
  ssh_port = var.network_config[2]
}

# Example for azurerm_linux_virtual_machine:
# size = var.vm_config.size
# source_image_reference {
#   publisher = var.vm_config.publisher
#   offer     = var.vm_config.offer
#   sku       = var.vm_config.sku
#   version   = var.vm_config.version
# }
````

## `Run Commands`
```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
````
If a wrong type is provided (e.g., a string instead of a number in storage_disk),
terraform validate or terraform plan will fail — demonstrating type constraints in action.
