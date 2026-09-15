variable "database_name" {
  type        = string
  description = "Parent database from ../database."
}

variable "schema_name" {
  type        = string
  description = "Parent schema from ../schema."
}

variable "table_fqn" {
  type        = string
  description = "Fully qualified table name from ../table."
}
