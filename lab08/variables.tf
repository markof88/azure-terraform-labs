variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "staging"
}

variable "storage_disk" {
  description = "The size of the VM's storage disk in GB"
  type        = number
  default     = 30
}

variable "is_delete_os_disk_on_termination" {
  description = "Flag to determine if the OS disk should be deleted upon VM termination"
  type        = bool
  default     = true
}

variable "allowed_locations" {
  description = "List of allowed Azure regions for resource deployment"
  type        = list(string)
  default     = ["West Europe", "North Europe", "Germany West Central", "Germany North"]
}

variable "allowed_tags" {
  description = "Map of allowed tags for resources"
  type        = map(string)
  default = {
    environment = "dev"
    managed_by  = "terraform"
    department  = "DevOps"
  }
}

variable "network_config" {
  description = "Tuple containing VNet address space, subnet base address, and subnet prefix length"
  type        = tuple([string, string, number])
  default     = ["10.0.0.0/16", "10.0.2.0", 24]
}

variable "allowed_vm_sizes" {
  description = "List of allowed VM sizes"
  type        = set(string)
  default     = ["Standard_B1s", "Standard_B2s", "Standard_DS1_v2", "Standard_DS2_v2"]
}

variable "vm_config" {
  type = object({
    size      = string
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    size      = "Standard_B1s_v2"
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

}

variable "sa_name" {
  description = "The name of the Storage Account"
  type        = set(string)
  default     = ["labsa463", "labsab464"]
}