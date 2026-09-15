-- =============================================================================
-- 00-setup / initial_setup.sql
--
-- One-time Snowflake bootstrap. Run this in Snowsight as ACCOUNTADMIN before
-- any Terraform lesson. Terraform cannot create the first user it logs in as.
--
-- How to run
-- ----------
-- 1. Open https://app.snowflake.com and sign in with your trial / admin user.
-- 2. Create a new SQL worksheet.
-- 3. Set the role to ACCOUNTADMIN.
-- 4. Generate a key pair (see 00-setup/README.md). Paste the PUBLIC key body
--    into RSA_PUBLIC_KEY below. Do not paste BEGIN/END header lines.
-- 5. Run the statements in order.
--
-- What this does
-- --------------
-- - Creates TERRAFORM_SVC, a SERVICE user (no password, no MFA).
-- - Attaches your public key so Terraform can sign JWTs with the private key.
-- - Grants SYSADMIN  (lessons 01 and 03: databases, warehouses, stages)
-- - Grants SECURITYADMIN (lesson 02: users, roles, grants)
-- - Grants USAGE on the trial COMPUTE_WH to those roles (the warehouse
--   exists; SYSADMIN is not authorized to use it until this grant)
-- - Leaves ACCOUNTADMIN on your human user. Lesson 03's resource monitor is
--   optional and needs that role; see the commented grant at the bottom.
-- =============================================================================

USE ROLE ACCOUNTADMIN;


-- -----------------------------------------------------------------------------
-- Confirm the account identifiers the Terraform provider needs.
-- You can also read them from the Snowsight URL:
--   https://app.snowflake.com/<organization_name>/<account_name>/...
-- -----------------------------------------------------------------------------
SELECT
    CURRENT_USER()                       AS current_user,
    CURRENT_ROLE()                       AS current_role,
    LOWER(CURRENT_ORGANIZATION_NAME())   AS organization_name,
    LOWER(CURRENT_ACCOUNT_NAME())        AS account_name;


-- -----------------------------------------------------------------------------
-- Service user Terraform will log in as.
--
-- TYPE = SERVICE
--   Human users (TYPE = PERSON) are expected to use MFA. Terraform cannot
--   tap an authenticator app, so a service user is the right pattern.
--
-- RSA_PUBLIC_KEY
--   Snowflake stores only the public half. The matching private key stays
--   on your machine in .ssh/ (gitignored).
--
-- Paste .ssh/snowflake_tf_snow_key.pub WITHOUT:
--   -----BEGIN PUBLIC KEY-----
--   -----END PUBLIC KEY-----
-- Newlines inside the key body are fine.
-- -----------------------------------------------------------------------------
CREATE USER IF NOT EXISTS TERRAFORM_SVC
    TYPE = SERVICE
    COMMENT = 'Service user for Terraform lessons in this repo'
    RSA_PUBLIC_KEY = '<PASTE_PUBLIC_KEY_BODY_HERE>';


-- If the user already exists and you only need to attach / rotate the key:
-- ALTER USER TERRAFORM_SVC SET RSA_PUBLIC_KEY = '<PASTE_PUBLIC_KEY_BODY_HERE>';


-- -----------------------------------------------------------------------------
-- Roles the service user may assume. GRANT ROLE ... TO USER does not make
-- that role the session default; Terraform sets `role` on each provider.
--
-- SYSADMIN        create and manage databases, schemas, warehouses, objects
-- SECURITYADMIN   create and manage users, roles, and grants
-- ACCOUNTADMIN    intentionally not granted (see optional block below)
-- -----------------------------------------------------------------------------
GRANT ROLE SYSADMIN TO USER TERRAFORM_SVC;
GRANT ROLE SECURITYADMIN TO USER TERRAFORM_SVC;

ALTER USER TERRAFORM_SVC SET DEFAULT_ROLE = SYSADMIN;


-- -----------------------------------------------------------------------------
-- Trial warehouses (COMPUTE_WH) are created for you and owned by
-- ACCOUNTADMIN. Snowflake's error is "does not exist or not authorized" —
-- the warehouse is there; SYSADMIN just cannot USE it yet.
-- Both Terraform provider aliases set warehouse on the session, so both
-- roles need USAGE. Without this, terraform plan fails before any resource.
-- -----------------------------------------------------------------------------
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE SYSADMIN;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE SECURITYADMIN;


-- -----------------------------------------------------------------------------
-- Sanity checks
-- SHOW USERS: TYPE = SERVICE, HAS_RSA_PUBLIC_KEY = true
-- DESC USER:  RSA_PUBLIC_KEY_FP has a fingerprint
-- -----------------------------------------------------------------------------
SHOW USERS LIKE 'TERRAFORM_SVC';
DESC USER TERRAFORM_SVC;
SHOW GRANTS TO USER TERRAFORM_SVC;
SHOW GRANTS ON WAREHOUSE COMPUTE_WH;


-- =============================================================================
-- Optional: lesson 03 resource monitor
-- Creating / assigning a resource monitor requires ACCOUNTADMIN. Only run
-- this if you set enable_resource_monitor = true in terraform.tfvars.
-- =============================================================================
-- GRANT ROLE ACCOUNTADMIN TO USER TERRAFORM_SVC;


-- =============================================================================
-- Tear down (only if you want to start setup over)
-- =============================================================================
-- DROP USER IF EXISTS TERRAFORM_SVC;
