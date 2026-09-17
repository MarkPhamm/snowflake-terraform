# Template
# resource "snowflake_grant_account_role" "analyst_to_user" {
#   provider  = snowflake.securityadmin
#   role_name = var.role_name
#   user_name = var.user_name
# }
#
# resource "snowflake_grant_privileges_to_account_role" "this" {
#   provider          = snowflake.securityadmin
#   privileges        = ["USAGE/SELECT"]
#   account_role_name = var.role_name
#
#   on_account_object {
#     object_type = "WAREHOUSE/DATABASE"
#     object_name = "A"
#   }
#   # or
#   on_schema {
#     schema_name = var.schema_fqn
#   }
#   # or
#   on_schema_object {
#     object_type = "TABLE/VIEW"
#     object_name = "A"
#   }
# }

# Two grant resources, easy to mix up:
#
# snowflake_grant_account_role
#   GRANT ROLE ... TO USER
#   "this identity may assume this role"
#
# snowflake_grant_privileges_to_account_role
#   GRANT SELECT ON TABLE ... TO ROLE
#   "this role may do X on object Y"
#
# Privilege grants walk the object tree. USAGE on the database and schema
# is required before SELECT on the table is usable.

resource "snowflake_grant_account_role" "analyst_to_user" {
  provider  = snowflake.securityadmin
  role_name = var.role_name
  user_name = var.user_name
}

resource "snowflake_grant_privileges_to_account_role" "warehouse" {
  provider          = snowflake.securityadmin
  privileges        = ["USAGE"]
  account_role_name = var.role_name

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = var.warehouse_name
  }
}

resource "snowflake_grant_privileges_to_account_role" "database" {
  provider          = snowflake.securityadmin
  privileges        = ["USAGE"]
  account_role_name = var.role_name

  on_account_object {
    object_type = "DATABASE"
    object_name = var.database_name
  }
}

resource "snowflake_grant_privileges_to_account_role" "schema" {
  provider          = snowflake.securityadmin
  privileges        = ["USAGE"]
  account_role_name = var.role_name

  on_schema {
    schema_name = var.schema_fqn
  }
}

resource "snowflake_grant_privileges_to_account_role" "table" {
  provider          = snowflake.securityadmin
  privileges        = ["SELECT"]
  account_role_name = var.role_name

  on_schema_object {
    object_type = "TABLE"
    object_name = var.table_fqn
  }
}

resource "snowflake_grant_privileges_to_account_role" "view" {
  provider          = snowflake.securityadmin
  privileges        = ["SELECT"]
  account_role_name = var.role_name

  on_schema_object {
    object_type = "VIEW"
    object_name = var.view_fqn
  }
}
