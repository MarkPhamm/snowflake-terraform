output "name" {
  value = snowflake_table.this.name
}

output "fully_qualified_name" {
  description = "Use this in the view SELECT and in grants."
  value       = snowflake_table.this.fully_qualified_name
}
