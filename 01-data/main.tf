# Wire objects in nest order: database → schema → table → view.
# Read each subdirectory README, then come back here to see how they connect.

module "database" {
  source = "./database"
}

module "schema" {
  source        = "./schema"
  database_name = module.database.name
}

module "table" {
  source        = "./table"
  database_name = module.database.name
  schema_name   = module.schema.name
}

module "view" {
  source        = "./view"
  database_name = module.database.name
  schema_name   = module.schema.name
  table_fqn     = module.table.fully_qualified_name
}
