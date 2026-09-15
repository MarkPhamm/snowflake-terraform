output "database_name" {
  value = module.database.name
}

output "schema_name" {
  value = module.schema.name
}

output "schema_fqn" {
  value = module.schema.fully_qualified_name
}

output "table_fqn" {
  value = module.table.fully_qualified_name
}

output "view_fqn" {
  value = module.view.fully_qualified_name
}
