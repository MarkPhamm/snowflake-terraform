# Default provider = SYSADMIN: databases, schemas, tables, views, warehouses,
# file formats, stages.
#
# Alias securityadmin — lesson 02 users, roles, grants.
#
# preview_features_enabled is required for snowflake_table. It cannot be set
# from an environment variable.

provider "snowflake" {
  organization_name = var.organization_name
  account_name      = var.account_name
  user              = var.user
  role              = "SYSADMIN"
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(pathexpand(var.private_key_path))
  warehouse         = var.provider_warehouse

  preview_features_enabled = [
    "snowflake_table_resource",
  ]
}

provider "snowflake" {
  alias = "securityadmin"

  organization_name = var.organization_name
  account_name      = var.account_name
  user              = var.user
  role              = "SECURITYADMIN"
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(pathexpand(var.private_key_path))
  warehouse         = var.provider_warehouse != "" ? var.provider_warehouse : null
}
