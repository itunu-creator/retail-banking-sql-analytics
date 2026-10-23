-- ====================================================================
-- DATA QUALITY & AUDIT VALIDATION SUITE
-- Identifies transactional anomalies, corrupted fields, and orphaned records.
-- ====================================================================

-- 1. Identify Non-Positive Transaction Amounts (Business Logic Violation)
SELECT 
    transaction_id,
    account_id,
    transaction_type,
    amount,
    'Negative or Zero Amount Error' AS issue_description
FROM transactions
WHERE amount <= 0;

-- 2. Detect Orphaned Transactions (Referential Integrity Check)
-- Finds transactions pointing to account numbers that do not exist in accounts master
SELECT 
    t.transaction_id,
    t.account_id,
    t.amount,
    t.transaction_date,
    'Orphaned Record: Account Not Found' AS issue_description
FROM transactions t
LEFT JOIN accounts a ON t.account_id = a.account_id
WHERE a.account_id IS NULL;

-- 3. Detect Inactive or Suspended Accounts Transacting Successfully
SELECT 
    t.transaction_id,
    a.account_id,
    a.customer_name,
    a.status AS account_status,
    t.amount,
    'Transaction on Inactive/Suspended Account' AS issue_description
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE a.status <> 'Active' AND t.status = 'Success';
