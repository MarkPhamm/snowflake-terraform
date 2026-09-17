# Wire access objects. Warehouse is SYSADMIN (default provider).
# Roles, users, and grants are SECURITYADMIN (alias passed down).

module "warehouse" {
  source = "./warehouse"
}

module "roles" {
  source = "./roles"

  providers = {
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "users" {
  source = "./users"

  providers = {
    snowflake.securityadmin = snowflake.securityadmin
  }

  role_name      = module.roles.name
  warehouse_name = module.warehouse.name
}

module "grants" {
  source = "./grants"

  providers = {
    snowflake.securityadmin = snowflake.securityadmin
  }

  role_name      = module.roles.name
  user_name      = module.users.name
  warehouse_name = module.warehouse.name
  database_name  = var.database_name
  schema_fqn     = var.schema_fqn
  table_fqn      = var.table_fqn
  view_fqn       = var.view_fqn
}
