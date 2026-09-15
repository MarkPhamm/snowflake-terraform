# snowflake-terraform

Hands-on lessons for managing Snowflake with Terraform. The repo is ordered the way you actually meet objects — data first, then who can use it, then how files get in and how spend is capped.

```text
00-setup/
01-data/
      database/  schema/  table/  view/
02-access/
      warehouse/  roles/  users/  grants/
03-ingestion/
      file-format/  stage/  resource-monitor/
```

Each lesson folder has one subdirectory per object, with its own README and Terraform. The lesson `main.tf` wires those folders together. Apply from the **repo root**.

Official references:

- [Terraforming Snowflake](https://www.snowflake.com/en/developers/guides/terraforming-snowflake/)
- [Snowflake Terraform provider](https://registry.terraform.io/providers/snowflakedb/snowflake/latest/docs)
- [Snowsight](https://docs.snowflake.com/en/user-guide/ui-snowsight/)


## Lesson map

| Order | Lesson | Objects | Why this position |
| --- | --- | --- | --- |
| 00 | [Setup](00-setup/README.md) | key pair, `TERRAFORM_SVC` | Terraform cannot create the user it logs in as |
| 01 | [Data](01-data/README.md) | database, schema, table, view | The tree you open first in Snowsight |
| 02 | [Access](02-access/README.md) | warehouse, roles, users, grants | Who can see the data, and which compute runs it |
| 03 | [Ingestion](03-ingestion/README.md) | file format, stage, resource monitor | How files get in, and how spend is capped |

```text
account
  ├── database TF_LEARN_DB
  │     └── schema RAW
  │           ├── table          CUSTOMERS
  │           ├── view           ACTIVE_CUSTOMERS
  │           ├── file format    TF_LEARN_CSV
  │           └── stage          TF_LEARN_INT_STAGE
  ├── warehouse TF_LEARN_WH
  ├── role      TF_LEARN_ANALYST
  └── user      TF_LEARN_ANALYST_SVC
```


## Two ways to talk to Snowflake

| Tool | What it is | How you sign in |
| --- | --- | --- |
| **Snowsight** | Web UI at [app.snowflake.com](https://app.snowflake.com) | Your trial user + MFA |
| **Terraform** | API / IaC | `TERRAFORM_SVC` + JWT from `.ssh/snowflake_tf_snow_key.p8` |

Use Snowsight to bootstrap and to inspect. Use Terraform to declare objects in files.

![Snowflake trial signup](assets/freetrial.png)


## Follow along

1. [00-setup](00-setup/README.md) — trial account, key pair, `initial_setup.sql`, `terraform.tfvars`.
2. Copy variables:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

   Fill in `organization_name` and `account_name` from the Snowsight URL:

   ```text
   https://app.snowflake.com/<organization_name>/<account_name>/...
   ```

3. From the repo root:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. In Snowsight, run each lesson's `check.sql`. Read the lesson README before you skip ahead — later modules take outputs from earlier ones.


## Repo layout

```text
.
├── README.md
├── providers.tf
├── main.tf                      wires lessons 01 → 02 → 03
├── 00-setup/
├── 01-data/
│   ├── database/
│   ├── schema/
│   ├── table/
│   └── view/
├── 02-access/
│   ├── warehouse/
│   ├── roles/
│   ├── users/
│   └── grants/
├── 03-ingestion/
│   ├── file-format/
│   ├── stage/
│   └── resource-monitor/
└── .ssh/                        gitignored key pair
```


## Provider roles

| Provider | Role | Used for |
| --- | --- | --- |
| default | `SYSADMIN` | database, schema, table, view, warehouse, file format, stage |
| `securityadmin` | `SECURITYADMIN` | users, roles, grants |

`ACCOUNTADMIN` stays on your human user. The optional resource monitor in lesson 03 is Snowsight SQL for that reason.


## Destroy

```bash
terraform destroy
```

That removes objects from lessons 01–03. It does **not** drop `TERRAFORM_SVC`. That user was created in Snowsight. Drop it there if you want a clean account:

```sql
DROP USER IF EXISTS TERRAFORM_SVC;
```


## Security

- Never commit `.ssh/`, `*.tfvars`, or `*.tfstate`.
- `SYSADMIN` + `SECURITYADMIN` on one service user is for learning. In a real account, split those and grant only what the pipeline owns.
- Trial credits are real. Warehouses in this repo auto-suspend in 60 seconds and are created suspended.
