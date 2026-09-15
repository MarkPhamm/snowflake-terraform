output "database_name" {
  value = module.data.database_name
}

output "schema_name" {
  value = module.data.schema_name
}

output "warehouse_name" {
  value = module.access.warehouse_name
}

output "analyst_role_name" {
  value = module.access.analyst_role_name
}

output "stage_fqn" {
  value = module.ingestion.stage_fqn
}
