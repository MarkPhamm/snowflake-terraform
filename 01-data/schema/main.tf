# Template
# resource "snowflake_schema" "this" {
#   database = var.database_name
#   name     = "A"
#   comment  = "B"
# }

resource "snowflake_schema" "this" {
  database = var.database_name
  name     = "RAW"
  comment  = "Lesson 01 — landing schema for tables and views"
}
