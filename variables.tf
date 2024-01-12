variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "secure_rg"
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "UK South"
}
variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "secure_vnet"
}

variable "vnet_address_space" {
  description = "The address space of the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}