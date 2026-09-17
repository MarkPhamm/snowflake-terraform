# Templates

Copy the HCL into each object's `main.tf`, or run the SQL in Snowsight. Replace `A` / `B` / `C` and pick one value where you see `false/true` or `X/Y`.

The same HCL block is commented at the top of each service `main.tf`.


## 01 — Data

### Database

[`01-data/database/main.tf`](../01-data/database/main.tf)

```hcl
resource "snowflake_database" "this" {
  name                           = "A"
  comment                        = "B"
  is_transient                   = false/true
  drop_public_schema_on_creation = true/false
}
```

```sql
USE ROLE SYSADMIN;

CREATE DATABASE A
    COMMENT = 'B';
-- or: CREATE TRANSIENT DATABASE A COMMENT = 'B';

DROP SCHEMA IF EXISTS A.PUBLIC;
```

### Schema

[`01-data/schema/main.tf`](../01-data/schema/main.tf)

```hcl
resource "snowflake_schema" "this" {
  database = var.database_name
  name     = "A"
  comment  = "B"
}
```

```sql
USE ROLE SYSADMIN;

CREATE SCHEMA <database>.A
    COMMENT = 'B';
```

### Table

[`01-data/table/main.tf`](../01-data/table/main.tf)

```hcl
resource "snowflake_table" "this" {
  database = var.database_name
  schema   = var.schema_name
  name     = "A"
  comment  = "B"

  column {
    name     = "C"
    type     = "NUMBER/VARCHAR/DATE/BOOLEAN"
    nullable = false/true
  }
}
```

```sql
USE ROLE SYSADMIN;

CREATE TABLE <database>.<schema>.A (
    C NUMBER/VARCHAR/DATE/BOOLEAN [NOT NULL]
)
COMMENT = 'B';
```

### View

[`01-data/view/main.tf`](../01-data/view/main.tf)

```hcl
resource "snowflake_view" "this" {
  database = var.database_name
  schema   = var.schema_name
  name     = "A"
  comment  = "B"

  statement = <<-SQL
    SELECT ...
    FROM ${var.table_fqn}
  SQL
}
```

```sql
USE ROLE SYSADMIN;

CREATE VIEW <database>.<schema>.A
    COMMENT = 'B'
AS
SELECT ...
FROM <table>;
```


## 02 — Access

### Warehouse

[`02-access/warehouse/main.tf`](../02-access/warehouse/main.tf)

```hcl
resource "snowflake_warehouse" "this" {
  name                = "A"
  comment             = "B"
  warehouse_type      = "STANDARD/SNOWPARK-OPTIMIZED"
  warehouse_size      = "XSMALL/SMALL/MEDIUM/..."
  auto_suspend        = 60
  auto_resume         = true/false
  initially_suspended = true/false
  max_cluster_count   = 1
  min_cluster_count   = 1
}
```

```sql
USE ROLE SYSADMIN;

CREATE WAREHOUSE A
    WAREHOUSE_TYPE = STANDARD/SNOWPARK-OPTIMIZED
    WAREHOUSE_SIZE = XSMALL/SMALL/MEDIUM/...
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE/FALSE
    INITIALLY_SUSPENDED = TRUE/FALSE
    MIN_CLUSTER_COUNT = 1
    MAX_CLUSTER_COUNT = 1
    COMMENT = 'B';
```

### Role

[`02-access/roles/main.tf`](../02-access/roles/main.tf)

```hcl
resource "snowflake_account_role" "this" {
  provider = snowflake.securityadmin
  name     = "A"
  comment  = "B"
}
```

```sql
USE ROLE SECURITYADMIN;

CREATE ROLE A
    COMMENT = 'B';
```

### User

[`02-access/users/main.tf`](../02-access/users/main.tf)

```hcl
resource "snowflake_service_user" "this" {
  provider          = snowflake.securityadmin
  name              = "A"
  comment           = "B"
  default_role      = var.role_name
  default_warehouse = var.warehouse_name
}
```

```sql
USE ROLE SECURITYADMIN;

CREATE USER A
    TYPE = SERVICE
    DEFAULT_ROLE = <role>
    DEFAULT_WAREHOUSE = <warehouse>
    COMMENT = 'B';
```

### Grants

[`02-access/grants/main.tf`](../02-access/grants/main.tf)

```hcl
resource "snowflake_grant_account_role" "analyst_to_user" {
  provider  = snowflake.securityadmin
  role_name = var.role_name
  user_name = var.user_name
}

resource "snowflake_grant_privileges_to_account_role" "this" {
  provider          = snowflake.securityadmin
  privileges        = ["USAGE/SELECT"]
  account_role_name = var.role_name

  on_account_object {
    object_type = "WAREHOUSE/DATABASE"
    object_name = "A"
  }
  # or
  on_schema {
    schema_name = var.schema_fqn
  }
  # or
  on_schema_object {
    object_type = "TABLE/VIEW"
    object_name = "A"
  }
}
```

```sql
USE ROLE SECURITYADMIN;

GRANT ROLE <role> TO USER <user>;

GRANT USAGE/SELECT ON WAREHOUSE/DATABASE A TO ROLE <role>;
GRANT USAGE ON SCHEMA <database>.<schema> TO ROLE <role>;
GRANT SELECT ON TABLE/VIEW <database>.<schema>.A TO ROLE <role>;
```


## 03 — Ingestion

### File format

[`03-ingestion/file-format/main.tf`](../03-ingestion/file-format/main.tf)

```hcl
resource "snowflake_file_format_csv" "this" {
  database = var.database_name
  schema   = var.schema_name
  name     = "A"
  comment  = "B"

  skip_header                  = 1
  field_delimiter              = ","
  field_optionally_enclosed_by = "\""
  trim_space                   = true/false
  empty_field_as_null          = true/false
  null_if                      = ["", "NULL"]
}
```

```sql
USE ROLE SYSADMIN;

CREATE FILE FORMAT <database>.<schema>.A
    TYPE = CSV
    SKIP_HEADER = 1
    FIELD_DELIMITER = ','
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    TRIM_SPACE = TRUE/FALSE
    EMPTY_FIELD_AS_NULL = TRUE/FALSE
    NULL_IF = ('', 'NULL')
    COMMENT = 'B';
```

### Stage

[`03-ingestion/stage/main.tf`](../03-ingestion/stage/main.tf)

```hcl
resource "snowflake_stage_internal" "this" {
  database = var.database_name
  schema   = var.schema_name
  name     = "A"
  comment  = "B"

  file_format {
    format_name = var.file_format_fqn
  }
}
```

```sql
USE ROLE SYSADMIN;

CREATE STAGE <database>.<schema>.A
    FILE_FORMAT = <database>.<schema>.<file_format>
    COMMENT = 'B';
```

### Resource monitor

[`03-ingestion/resource-monitor/main.tf`](../03-ingestion/resource-monitor/main.tf)

Not applied by Terraform. Needs `ACCOUNTADMIN`.

```hcl
resource "snowflake_resource_monitor" "this" {
  provider        = snowflake.accountadmin
  name            = "A"
  credit_quota    = 10
  frequency       = "MONTHLY/DAILY/WEEKLY/YEARLY/NEVER"
  start_timestamp = "IMMEDIATELY"
  notify_triggers = [50]
  suspend_trigger = 100
}
```

```sql
USE ROLE ACCOUNTADMIN;

CREATE RESOURCE MONITOR A
    CREDIT_QUOTA = 10
    FREQUENCY = MONTHLY/DAILY/WEEKLY/YEARLY/NEVER
    START_TIMESTAMP = IMMEDIATELY
    TRIGGERS
        ON 50 PERCENT DO NOTIFY
        ON 100 PERCENT DO SUSPEND;

ALTER WAREHOUSE <warehouse> SET RESOURCE_MONITOR = A;
```
