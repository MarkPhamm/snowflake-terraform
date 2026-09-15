# View

A stored `SELECT`. No extra copy of the data. Changing `statement` recreates the view.

The provider reads view metadata and needs a warehouse on the session (`provider_warehouse` in tfvars, after `USAGE` on `COMPUTE_WH`).


## `versions.tf`

```hcl
terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }
}
```

Declares the Snowflake provider. Version pin is at the repo root. Creates nothing.


## `variables.tf`

```hcl
variable "database_name" { type = string }
variable "schema_name"   { type = string }
variable "table_fqn"     { type = string }
```

`table_fqn` is `module.table.fully_qualified_name`, not `module.table.name`. The SQL `FROM` clause needs `"TF_LEARN_DB"."RAW"."CUSTOMERS"`.


## `main.tf`

```hcl
resource "snowflake_view" "this" {
  database = var.database_name
  schema   = var.schema_name
  name     = "ACTIVE_CUSTOMERS"
  comment  = "Lesson 01 — active customers only"

  statement = <<-SQL
    SELECT ID, CUSTOMER_NAME, SIGNUP_DATE
    FROM ${var.table_fqn}
    WHERE IS_ACTIVE = TRUE
  SQL
}
```

`this` is the Terraform label. Snowflake object is `ACTIVE_CUSTOMERS`. State: `module.data.module.view.snowflake_view.this`.

| Argument | Meaning |
| --- | --- |
| `database` / `schema` / `name` | Same nesting as the table. |
| `statement` | The query that *is* the view. Uses the table FQN. |


## Snowsight SQL

```sql
USE ROLE SYSADMIN;

CREATE VIEW TF_LEARN_DB.RAW.ACTIVE_CUSTOMERS
    COMMENT = 'Lesson 01 — active customers only'
AS
SELECT ID, CUSTOMER_NAME, SIGNUP_DATE
FROM TF_LEARN_DB.RAW.CUSTOMERS
WHERE IS_ACTIVE = TRUE;
```

A warehouse must be selected in the worksheet to `SELECT` from the view later. `CREATE VIEW` itself is metadata.


## `outputs.tf`

```hcl
output "name" {
  value = snowflake_view.this.name
}

output "fully_qualified_name" {
  value = snowflake_view.this.fully_qualified_name
}
```

| Output | Example | Use |
| --- | --- | --- |
| `name` | `ACTIVE_CUSTOMERS` | Display |
| `fully_qualified_name` | `"TF_LEARN_DB"."RAW"."ACTIVE_CUSTOMERS"` | Lesson 02 `GRANT SELECT` |

Next: [02 — Access](../../02-access/README.md)
