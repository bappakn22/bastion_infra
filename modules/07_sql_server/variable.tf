variable "sql_server_name" {
  description = "The name of the SQL Server."
  type        = string
  
}   

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string  
}

variable "location" {
  description = "The Azure region where the SQL Server will be created."
  type        = string
}

variable "administrator_login" {
  description = "The administrator username for the SQL Server."
  type        = string
  
}

variable "administrator_login_password" {
  description = "The administrator password for the SQL Server."
  type        = string
  sensitive   = true
  
}

variable "sql_database_name" {
  description = "The name of the SQL Database."
  type        = string
}