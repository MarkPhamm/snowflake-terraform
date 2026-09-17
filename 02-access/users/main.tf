# Template
# resource "snowflake_service_user" "this" {
#   provider          = snowflake.securityadmin
#   name              = "A"
#   comment           = "B"
#   default_role      = var.role_name
#   default_warehouse = var.warehouse_name
# }

# TERRAFORM_SVC (lesson 00) is the automation user. This is a second service
# user that represents an analyst. It has no key and cannot log in until you
# attach one — it exists so grants have a user to target.
#
# Use snowflake_service_user (TYPE = SERVICE), not snowflake_user
# (TYPE = PERSON). Person users expect MFA and a password.

resource "snowflake_service_user" "this" {
  provider = snowflake.securityadmin

  name              = "TF_LEARN_ANALYST_SVC"
  comment           = "Lesson 02 — sample analyst identity (no login key on purpose)"
  default_role      = var.role_name
  default_warehouse = var.warehouse_name
}
