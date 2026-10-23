-- ====================================================================
-- BUSINESS INTELLIGENCE & BRANCH PERFORMANCE KPIS
-- Demonstrates aggregations, window functions, and business reporting.
-- ====================================================================

-- 1. Branch Liquidity & Net Cash Flow Summary
SELECT 
    b.branch_id,
    b.branch_name,
    b.region,
    COUNT(DISTINCT a.account_id) AS total_accounts,
    SUM(CASE WHEN t.transaction_type = 'Deposit' AND t.status = 'Success' AND t.amount > 0 THEN t.amount ELSE 0 END) AS total_deposits,
    SUM(CASE WHEN t.transaction_type = 'Withdrawal' AND t.status = 'Success' AND t.amount > 0 THEN t.amount ELSE 0 END) AS total_withdrawals,
    (SUM(CASE WHEN t.transaction_type = 'Deposit' AND t.status = 'Success' AND t.amount > 0 THEN t.amount ELSE 0 END) -
     SUM(CASE WHEN t.transaction_type = 'Withdrawal' AND t.status = 'Success' AND t.amount > 0 THEN t.amount ELSE 0 END)) AS net_cash_flow
FROM branches b
LEFT JOIN accounts a ON b.branch_id = a.branch_id
LEFT JOIN transactions t ON a.account_id = t.account_id
GROUP BY b.branch_id, b.branch_name, b.region
ORDER BY net_cash_flow DESC;

-- 2. Customer Running Balances Using Window Functions
SELECT 
    t.transaction_id,
    t.account_id,
    a.customer_name,
    t.transaction_date,
    t.transaction_type,
    t.amount,
    SUM(CASE 
            WHEN t.transaction_type = 'Deposit' THEN t.amount 
            WHEN t.transaction_type = 'Withdrawal' THEN -t.amount 
            ELSE 0 
        END) OVER (
            PARTITION BY t.account_id 
            ORDER BY t.transaction_date 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_balance
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE t.status = 'Success' AND t.amount > 0
ORDER BY t.account_id, t.transaction_date;
