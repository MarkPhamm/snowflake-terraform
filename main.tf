# Lessons are modules so the repo folder order matches the object tree
# you actually encounter. Apply from this directory, not from a lesson folder.

module "data" {
  source = "./01-data"
}

module "access" {
  source = "./02-access"

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }

  database_name = module.data.database_name
  schema_fqn    = module.data.schema_fqn
  table_fqn     = module.data.table_fqn
  view_fqn      = module.data.view_fqn
}

module "ingestion" {
  source = "./03-ingestion"

  database_name = module.data.database_name
  schema_name   = module.data.schema_name
}
