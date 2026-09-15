output "name" {
  description = "Database name. Pass this into schema, table, view, grants, stages."
  value       = snowflake_database.this.name
}
