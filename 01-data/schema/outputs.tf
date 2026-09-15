output "name" {
  description = "Schema name (not qualified)."
  value       = snowflake_schema.this.name
}

output "fully_qualified_name" {
  description = "DATABASE.SCHEMA — use this for grants."
  value       = snowflake_schema.this.fully_qualified_name
}
