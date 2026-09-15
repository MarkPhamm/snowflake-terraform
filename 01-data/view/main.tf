# Template
# resource "snowflake_view" "this" {
#   database = var.database_name
#   schema   = var.schema_name
#   name     = "A"
#   comment  = "B"
#
#   statement = <<-SQL
#     SELECT ...
#     FROM ${var.table_fqn}
#   SQL
# }

# The provider inspects view metadata and needs a warehouse on the session.
# The root provider uses COMPUTE_WH (or provider_warehouse in tfvars).
# Changing statement recreates the view.

resource "snowflake_view" "this" {
  database = var.database_name
  schema   = var.schema_name
  name     = "ACTIVE_CUSTOMERS"
  comment  = "Lesson 01 — active customers only"

  statement = <<-SQL
    SELECT
        ID,
        CUSTOMER_NAME,
        SIGNUP_DATE
    FROM ${var.table_fqn}
    WHERE IS_ACTIVE = TRUE
  SQL
}
