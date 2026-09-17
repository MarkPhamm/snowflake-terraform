# 02 — Access

These four belong together. Each object is its own folder.

```text
02-access/
  warehouse/    TF_LEARN_WH
  roles/        TF_LEARN_ANALYST
  users/        TF_LEARN_ANALYST_SVC
  grants/       role-to-user + USAGE / SELECT
  main.tf       wires the four together
```

```text
user TF_LEARN_ANALYST_SVC
  └── role TF_LEARN_ANALYST
        ├── USAGE  warehouse TF_LEARN_WH
        ├── USAGE  database  TF_LEARN_DB
        ├── USAGE  schema    TF_LEARN_DB.RAW
        ├── SELECT table     CUSTOMERS
        └── SELECT view      ACTIVE_CUSTOMERS
```


## Read in this order

1. [warehouse](warehouse/README.md) — compute
2. [roles](roles/README.md) — privilege bundle
3. [users](users/README.md) — identity that assumes the role
4. [grants](grants/README.md) — how they connect
5. `main.tf` — parent wiring, including the `SECURITYADMIN` alias


## Two provider roles

| Folder | Provider role |
| --- | --- |
| `warehouse/` | `SYSADMIN` (default) |
| `roles/`, `users/`, `grants/` | `SECURITYADMIN` |

The root `providers.tf` defines both. This lesson's `versions.tf` declares the `securityadmin` alias and `main.tf` passes it into the three SECURITYADMIN folders.


## Apply

From the repo root:

```bash
terraform apply
```

Then run `check.sql`.


## Next

[03 — Ingestion](../03-ingestion/README.md)
