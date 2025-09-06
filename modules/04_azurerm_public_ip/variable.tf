variable "public_ip_name" {
  description = "The name of the public IP"
  type        = string

}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string  
  
}

variable "location" {
  description = "The location where the public IP will be created"
  type        = string

}

variable "allocation_method" {
  description = "The allocation method for the public IP"
  type        = string

}   