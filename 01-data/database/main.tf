# Template
# resource "snowflake_database" "this" {
#   name = "A"
#   comment = "B"
#   is_transient = false/true
#   drop_public_schema_on_creation = true/false
# }

resource "snowflake_database" "this" {
  name = "A"
  comment = "B"
  is_transient = false
  drop_public_schema_on_creation = true
}