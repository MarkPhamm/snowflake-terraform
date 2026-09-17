variable "role_name" {
  type        = string
  description = "Role from ../roles."
}

variable "user_name" {
  type        = string
  description = "User from ../users."
}

variable "warehouse_name" {
  type        = string
  description = "Warehouse from ../warehouse."
}

variable "database_name" {
  type        = string
  description = "Database from lesson 01."
}

variable "schema_fqn" {
  type        = string
  description = "Fully qualified schema name from lesson 01."
}

variable "table_fqn" {
  type        = string
  description = "Fully qualified table name from lesson 01."
}

variable "view_fqn" {
  type        = string
  description = "Fully qualified view name from lesson 01."
}
