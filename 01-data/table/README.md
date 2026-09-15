# Table

Stored rows. Creating the table is metadata (no warehouse credits). `INSERT` / `SELECT` burn credits.

`snowflake_table` is a provider **preview** feature. Root `providers.tf` must list `snowflake_table_resource`.


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
```

Parent sets these from `module.database.name` and `module.schema.name` (`TF_LEARN_DB` and `RAW`).


## `main.tf`

```hcl
resource "snowflake_table" "this" {
  database = var.database_name
  schema   = var.schema_name
  name     = "CUSTOMERS"
  comment  = "Lesson 01 — sample customer dimension"

  column { name = "ID"            type = "NUMBER(38,0)" nullable = false }
  column { name = "CUSTOMER_NAME" type = "VARCHAR"      nullable = false }
  column { name = "SIGNUP_DATE"   type = "DATE"         nullable = true }
  column { name = "IS_ACTIVE"     type = "BOOLEAN"      nullable = false }
}
```

`this` is the Terraform label. Snowflake object is `CUSTOMERS`. State: `module.data.module.table.snowflake_table.this`.

| Argument | Meaning |
| --- | --- |
| `database` / `schema` | Parents from variables. |
| `name` | Snowflake identifier (`CUSTOMERS`). Unique in that schema. |
| `column` | One block per column. `type` is a Snowflake data type. |


## Snowsight SQL

```sql
USE ROLE SYSADMIN;

CREATE TABLE TF_LEARN_DB.RAW.CUSTOMERS (
    ID            NUMBER(38,0) NOT NULL,
    CUSTOMER_NAME VARCHAR      NOT NULL,
    SIGNUP_DATE   DATE,
    IS_ACTIVE     BOOLEAN      NOT NULL
)
COMMENT = 'Lesson 01 — sample customer dimension';
```


## `outputs.tf`

```hcl
output "name" {
  value = snowflake_table.this.name
}

output "fully_qualified_name" {
  value = snowflake_table.this.fully_qualified_name
}
```

| Output | Example | Use |
| --- | --- | --- |
| `name` | `CUSTOMERS` | Rarely needed downstream |
| `fully_qualified_name` | `"TF_LEARN_DB"."RAW"."CUSTOMERS"` | View `FROM`; `GRANT SELECT` |

The view interpolates the FQN so a rename of the database or schema does not break the SQL.


## Creates

`snowflake_table.this` → `TF_LEARN_DB.RAW.CUSTOMERS`

Next: [view](../view/README.md)
