# Template
# resource "snowflake_table" "this" {
#   database = var.database_name
#   schema   = var.schema_name
#   name     = "A"
#   comment  = "B"
#
#   column {
#     name     = "C"
#     type     = "NUMBER/VARCHAR/DATE/BOOLEAN"
#     nullable = false/true
#   }
# }

# snowflake_table is a provider preview feature. The root providers.tf
# enables snowflake_table_resource. Without that flag, apply fails closed.

resource "snowflake_table" "this" {
  database = var.database_name
  schema   = var.schema_name
  name     = "CUSTOMERS"
  comment  = "Lesson 01 — sample customer dimension"

  column {
    name     = "ID"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "CUSTOMER_NAME"
    type     = "VARCHAR"
    nullable = false
  }

  column {
    name     = "SIGNUP_DATE"
    type     = "DATE"
    nullable = true
  }

  column {
    name     = "IS_ACTIVE"
    type     = "BOOLEAN"
    nullable = false
  }
}
