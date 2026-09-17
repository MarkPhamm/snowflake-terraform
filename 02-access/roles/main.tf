# Template
# resource "snowflake_account_role" "this" {
#   provider = snowflake.securityadmin
#   name     = "A"
#   comment  = "B"
# }

# snowflake_account_role is the current resource. snowflake_role is legacy.
# SECURITYADMIN creates roles.

resource "snowflake_account_role" "this" {
  provider = snowflake.securityadmin
  name     = "TF_LEARN_ANALYST"
  comment  = "Lesson 02 — can use the learning warehouse and SELECT lesson 01 data"
}
