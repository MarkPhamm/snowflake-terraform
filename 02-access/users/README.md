# User

An identity that assumes a role. Do not grant table privileges directly to a user.

This is a **service** user (`snowflake_service_user`), same type as `TERRAFORM_SVC`. No key is attached, so it cannot log in — it only exists so grants have a target.


## `versions.tf`

```hcl
terraform {
  required_providers {
    snowflake = {
      source                = "snowflakedb/snowflake"
      configuration_aliases = [snowflake.securityadmin]
    }
  }
}
```

Same as `roles/`: needs the `securityadmin` alias passed in from `02-access/main.tf`. `SYSADMIN` cannot create users.


## `variables.tf`

```hcl
variable "role_name"      { type = string }
variable "warehouse_name" { type = string }
```

Parent sets these from `module.roles.name` and `module.warehouse.name`.


## `main.tf`

```hcl
resource "snowflake_service_user" "this" {
  provider          = snowflake.securityadmin
  name              = "TF_LEARN_ANALYST_SVC"
  comment           = "Lesson 02 — sample analyst identity (no login key on purpose)"
  default_role      = var.role_name
  default_warehouse = var.warehouse_name
}
```

`this` is the Terraform label. Snowflake object is `TF_LEARN_ANALYST_SVC`. State: `module.access.module.users.snowflake_service_user.this`.

Use `snowflake_service_user` (`TYPE = SERVICE`), not `snowflake_user` (`TYPE = PERSON`). Person users expect MFA and a password.

| Argument | Meaning |
| --- | --- |
| `name` | Login / identifier. |
| `default_role` | Role assumed if the session does not pick one. |
| `default_warehouse` | Warehouse used if the session does not pick one. |


## Snowsight SQL

```sql
USE ROLE SECURITYADMIN;

CREATE USER TF_LEARN_ANALYST_SVC
    TYPE = SERVICE
    DEFAULT_ROLE = TF_LEARN_ANALYST
    DEFAULT_WAREHOUSE = TF_LEARN_WH
    COMMENT = 'Lesson 02 — sample analyst identity (no login key on purpose)';
```

`TYPE = SERVICE` is why Terraform uses `snowflake_service_user`, not `snowflake_user`.


## `outputs.tf`

```hcl
output "name" {
  value = snowflake_service_user.this.name
}
```

| Output | Example | Use |
| --- | --- | --- |
| `name` | `TF_LEARN_ANALYST_SVC` | `snowflake_grant_account_role.user_name` |

Next: [grants](../grants/README.md)
