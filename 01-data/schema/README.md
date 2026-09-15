# Schema

Namespace inside a database. Fully qualified names are `DATABASE.SCHEMA.OBJECT`.

```text
TF_LEARN_DB → schema RAW   <-- this folder
```


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

Same job as `database/versions.tf`: this module uses the Snowflake provider. No version pin here — that lives at the repo root. Creates nothing in Snowflake.


## `variables.tf`

```hcl
variable "database_name" {
  type        = string
  description = "Parent database from ../database."
}
```

An input the parent must set. `01-data/main.tf` does `database_name = module.database.name`, so this is `"TF_LEARN_DB"` after the database apply. The schema folder never hard-codes the database.


## `main.tf`

```hcl
resource "snowflake_schema" "this" {
  database = var.database_name
  name     = "RAW"
  comment  = "Lesson 01 — landing schema for tables and views"
}
```

`this` is the Terraform label. Snowflake object is `RAW` inside `var.database_name`. State: `module.data.module.schema.snowflake_schema.this`.

| Argument | Meaning |
| --- | --- |
| `database` | Parent database (`var.database_name`). |
| `name` | Snowflake identifier (`RAW`). Unique inside that database. |
| `comment` | Metadata. |


## Snowsight SQL

```sql
USE ROLE SYSADMIN;

CREATE SCHEMA TF_LEARN_DB.RAW
    COMMENT = 'Lesson 01 — landing schema for tables and views';
```


## `outputs.tf`

```hcl
output "name" {
  value = snowflake_schema.this.name
}

output "fully_qualified_name" {
  value = snowflake_schema.this.fully_qualified_name
}
```

| Output | Example | Use |
| --- | --- | --- |
| `name` | `RAW` | Table/view `schema = module.schema.name` |
| `fully_qualified_name` | `"TF_LEARN_DB"."RAW"` | Grants: `on_schema { schema_name = ... }` |

`name` is the last part. `fully_qualified_name` is quoted `DATABASE.SCHEMA`. `CREATE TABLE` takes `database` + `schema` separately, so it wants `name`. Grants have one field, so they want the FQN.


## Creates

`snowflake_schema.this` → `TF_LEARN_DB.RAW`

Next: [table](../table/README.md)
