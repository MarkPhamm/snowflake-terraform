-- Run in Snowsight after terraform apply. Role: SYSADMIN.
-- A warehouse (trial COMPUTE_WH is fine) is only needed for the INSERT / SELECT.

SHOW DATABASES LIKE 'TF_LEARN_DB';
SHOW SCHEMAS IN DATABASE TF_LEARN_DB;
SHOW TABLES IN SCHEMA TF_LEARN_DB.RAW;
SHOW VIEWS IN SCHEMA TF_LEARN_DB.RAW;

-- Optional: put a couple of rows in so the view returns something.
-- USE WAREHOUSE COMPUTE_WH;

-- INSERT INTO TF_LEARN_DB.RAW.CUSTOMERS (ID, CUSTOMER_NAME, SIGNUP_DATE, IS_ACTIVE)
-- VALUES
--     (1, 'Ada Lovelace', '2024-01-10', TRUE),
--     (2, 'Alan Turing',  '2024-02-14', FALSE);

-- SELECT * FROM TF_LEARN_DB.RAW.CUSTOMERS;
-- SELECT * FROM TF_LEARN_DB.RAW.ACTIVE_CUSTOMERS;
