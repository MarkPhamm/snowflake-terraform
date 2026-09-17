# Warehouse

Compute. Tables store data; this runs SQL. Credits burn only while it is **running**.

`SYSADMIN` can create it. Attaching a resource monitor is `ACCOUNTADMIN` (lesson 03).


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

Declares the Snowflake provider. Version pin is at the repo root. Creates nothing. Uses the default (`SYSADMIN`) provider — no alias.


## `main.tf`

```hcl
resource "snowflake_warehouse" "this" {
  name                = "TF_LEARN_WH"
  comment             = "Lesson 02 — X-Small warehouse for learning queries"
  warehouse_type      = "STANDARD"
  warehouse_size      = "XSMALL"
  auto_suspend        = 60
  auto_resume         = "true"
  initially_suspended = true
  max_cluster_count   = 1
  min_cluster_count   = 1
}
```

`this` is the Terraform label. Snowflake object is `TF_LEARN_WH`. State: `module.access.module.warehouse.snowflake_warehouse.this`.

| Argument | Meaning |
| --- | --- |
| `name` | Account-unique identifier. |
| `warehouse_size` | `XSMALL` — cheapest size. |
| `auto_suspend` | Stop after 60 seconds idle. |
| `auto_resume` | Start on the first query. |
| `initially_suspended` | Created stopped so apply does not burn credits. |
| `min/max_cluster_count` | `1` / `1` — not multi-cluster. |


## Snowsight SQL

```sql
USE ROLE SYSADMIN;

CREATE WAREHOUSE TF_LEARN_WH
    WAREHOUSE_TYPE = STANDARD
    WAREHOUSE_SIZE = XSMALL
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    MIN_CLUSTER_COUNT = 1
    MAX_CLUSTER_COUNT = 1
    COMMENT = 'Lesson 02 — X-Small warehouse for learning queries';
```


## `outputs.tf`

```hcl
output "name" {
  value = snowflake_warehouse.this.name
}
```

| Output | Example | Use |
| --- | --- | --- |
| `name` | `TF_LEARN_WH` | User `default_warehouse`; `GRANT USAGE` |

A warehouse is an account object, so `name` and `fully_qualified_name` are the same. We only export `name`.

Next: [roles](../roles/README.md)
