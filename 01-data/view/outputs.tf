output "name" {
  value = snowflake_view.this.name
}

output "fully_qualified_name" {
  description = "Use this in SELECT grants."
  value       = snowflake_view.this.fully_qualified_name
}
