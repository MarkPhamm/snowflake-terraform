# Role

A named bundle of privileges. Grant privileges **to roles**, then grant the role to users.

Created with `SECURITYADMIN`.


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

Same provider source as other folders, plus `configuration_aliases`. That tells Terraform this module expects a provider named `snowflake.securityadmin` to be **passed in**. `02-access/main.tf` does that:

```hcl
module "roles" {
  source = "./roles"
  providers = {
    snowflake.securityadmin = snowflake.securityadmin
  }
}
```

Without the alias, `provider = snowflake.securityadmin` in `main.tf` would not resolve.


## `main.tf`

```hcl
resource "snowflake_account_role" "this" {
  provider = snowflake.securityadmin
  name     = "TF_LEARN_ANALYST"
  comment  = "Lesson 02 — can use the learning warehouse and SELECT lesson 01 data"
}
```

`this` is the Terraform label. Snowflake object is `TF_LEARN_ANALYST`. State: `module.access.module.roles.snowflake_account_role.this`.

`provider = snowflake.securityadmin` is required — `SYSADMIN` cannot `CREATE ROLE`.

| Argument | Meaning |
| --- | --- |
| `name` | Account-unique role name. |
| `comment` | Metadata. |

No privileges yet. [grants](../grants/README.md) attach those.


## Snowsight SQL

```sql
USE ROLE SECURITYADMIN;

CREATE ROLE TF_LEARN_ANALYST
    COMMENT = 'Lesson 02 — can use the learning warehouse and SELECT lesson 01 data';
```


## `outputs.tf`

```hcl
output "name" {
  value = snowflake_account_role.this.name
}
```

| Output | Example | Use |
| --- | --- | --- |
| `name` | `TF_LEARN_ANALYST` | User `default_role`; every grant's `account_role_name` |

Account roles are not nested under a database, so `name` is enough.

Next: [users](../users/README.md)
