variable "svc_name" {
  type = string
  default = "azvm4reasearch"
}

variable "rg_location" {
  type = string
  default = "brazilsouth"
}

variable "vnet_address_space" {
  description = "The address space to use for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "vm_size" {
  description = "The size of the virtual machine."
  default     = "Standard_B4ms" # Standard_B4ms Standard_B2s
}

variable "vm_disk_type" {
  description = "The disk type."
  default     = "Standard_LRS"
}

variable "vm_disk_size_gb" {
  description = "The disk size."
  default     = "128"
}

variable "vm_admin_username" {
  description = "The username for the virtual machine."
  default     = "useradmin"
}

variable "vm_computer_name" {
  description = "The name of the computer for the virtual machine."
  default     = "researchvm"
}

variable "key_vault_secret" {
  description = "The name of the computer for the virtual machine."
  default     = "mysecret"
}
