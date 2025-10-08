# Lab 09 – Terraform Lifecycle & Preconditions

## Goal
Using the resources from earlier labs, practice Terraform **lifecycle** meta-arguments and **preconditions**:

- `create_before_destroy`
- `prevent_destroy`
- `ignore_changes`
- `precondition` to block disallowed locations

---

## Files you’ll touch
- `storage-account.tf`
- `resource-group.tf`
- (optional) `variables.tf` if you parameterize names/locations

---

## 1) `create_before_destroy` on Storage Account

When a change **forces replacement** (e.g., changing the storage account **name**), Terraform by default destroys the old then creates the new.  
To **avoid downtime**, create the new first:

```hcl
resource "azurerm_storage_account" "demo_sa" {
  name                     = var.storage_account_name       # e.g., "tfstoragedemo001"
  resource_group_name      = azurerm_resource_group.demo_rg.name
  location                 = azurerm_resource_group.demo_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    lab = "09"
  }
}
````

### Test

1. Change `var.storage_account_name` to a **new** unique value (Azure requires globally unique names).
2. Run:

   ```bash
   terraform plan
   terraform apply
   ```
3. **Observe:** Plan shows **Create** new → then **Destroy** old. Apply respects that order.

---

## 2) `prevent_destroy` on Storage Account

Block accidental deletions of critical resources:

```hcl
resource "azurerm_storage_account" "demo_sa" {
  # … same arguments as above …

  lifecycle {
    prevent_destroy = true
  }
}
```

### Test

1. Try to `terraform destroy` (or plan a change that forces replacement, like changing `name`).
2. **Observe:** Terraform errors with a message that the resource has `prevent_destroy = true`.
3. Remove or set `prevent_destroy = false` only when you intentionally want to allow deletion.

> 💡 You can **combine** `create_before_destroy` and `prevent_destroy`, but be aware:
>
> * Replacements will **fail** if the old instance must be destroyed (due to uniqueness constraints) and `prevent_destroy` blocks it.

---

## 3) `ignore_changes` on Resource Group

Tell Terraform to **ignore drifts** for specific arguments.
(Useful when something is managed externally or cannot be updated in place.)

```hcl
resource "azurerm_resource_group" "demo_rg" {
  name     = var.resource_group_name        # e.g., "rg-terraform-demo"
  location = var.location                   # e.g., "Germany West Central"

  lifecycle {
    ignore_changes = [
      name,       # Ignore config changes to name (suppresses replacement)
      # tags,     # Example: ignore tag drift if changed outside Terraform
    ]
  }
}
```

### Test

1. Change `var.resource_group_name` in your config to a different value.
2. Run:

   ```bash
   terraform plan
   ```
3. **Observe:** Plan shows **no change** to the RG (Terraform ignores the difference).
   The real RG name **does not change**—Terraform keeps managing the existing one.

> ⚠️ Renaming an Azure Resource Group isn’t supported in-place. `ignore_changes = [name]` only suppresses Terraform’s urge to replace; it **won’t rename** the RG in Azure.

---

## 4) Block “Canada Central” with `precondition`

Use a **resource precondition** to prevent creating resources in a disallowed region.

```hcl
resource "azurerm_resource_group" "demo_rg" {
  name     = var.resource_group_name
  location = var.location

  # Fail early if location is disallowed
  precondition {
    condition     = lower(var.location) != "canada central"
    error_message = "Location 'Canada Central' is not allowed for this lab."
  }
}
```

You can also add the same kind of `precondition` to the storage account to enforce the rule across resources.

### Test

1. Set `var.location = "Canada Central"` (or any case variant).
2. Run:

   ```bash
   terraform plan
   ```
3. **Observe:** Plan fails with the custom error message.

---

## Commands

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Use `terraform destroy` to test `prevent_destroy` behavior (expect a failure).