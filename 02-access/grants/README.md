# Grants

Connects the other three folders. A table without a grant is invisible.

```text
user TF_LEARN_ANALYST_SVC
  └── role TF_LEARN_ANALYST
        ├── USAGE  warehouse / database / schema
        └── SELECT table / view
```


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

Needs `SECURITYADMIN` (same alias pattern as roles/users). There is no `outputs.tf` — nothing downstream reads a grant id.


## `variables.tf`

Inputs from siblings and from lesson 01:

| Variable | Example | Why FQN or not |
| --- | --- | --- |
| `role_name` | `TF_LEARN_ANALYST` | Account object |
| `user_name` | `TF_LEARN_ANALYST_SVC` | Account object |
| `warehouse_name` | `TF_LEARN_WH` | Account object |
| `database_name` | `TF_LEARN_DB` | Account object |
| `schema_fqn` | `"TF_LEARN_DB"."RAW"` | Schema lives in a database |
| `table_fqn` / `view_fqn` | `"TF_LEARN_DB"."RAW"."CUSTOMERS"` | Schema objects |


## `main.tf`

Two resource types. Labels are descriptive (`analyst_to_user`, `table`) instead of `this`, because this folder owns several resources.

**Role to user** — “this identity may assume this role”:

```hcl
resource "snowflake_grant_account_role" "analyst_to_user" {
  provider  = snowflake.securityadmin
  role_name = var.role_name
  user_name = var.user_name
}
```

**Privileges to role** — “this role may do X on object Y”:

```hcl
resource "snowflake_grant_privileges_to_account_role" "table" {
  provider          = snowflake.securityadmin
  privileges        = ["SELECT"]
  account_role_name = var.role_name

  on_schema_object {
    object_type = "TABLE"
    object_name = var.table_fqn
  }
}
```

The other four blocks are the same shape: `USAGE` on warehouse, database, and schema; `SELECT` on the view.

`SELECT` on a table does nothing without `USAGE` on the schema and database first.


## Snowsight SQL

```sql
USE ROLE SECURITYADMIN;

GRANT ROLE TF_LEARN_ANALYST TO USER TF_LEARN_ANALYST_SVC;

GRANT USAGE ON WAREHOUSE TF_LEARN_WH TO ROLE TF_LEARN_ANALYST;
GRANT USAGE ON DATABASE TF_LEARN_DB TO ROLE TF_LEARN_ANALYST;
GRANT USAGE ON SCHEMA TF_LEARN_DB.RAW TO ROLE TF_LEARN_ANALYST;
GRANT SELECT ON TABLE TF_LEARN_DB.RAW.CUSTOMERS TO ROLE TF_LEARN_ANALYST;
GRANT SELECT ON VIEW TF_LEARN_DB.RAW.ACTIVE_CUSTOMERS TO ROLE TF_LEARN_ANALYST;
```

Next: [03 — Ingestion](../../03-ingestion/README.md)
