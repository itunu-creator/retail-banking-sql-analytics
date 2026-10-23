-- ====================================================================
-- RETAIL BANKING RELATIONAL SCHEMA & SEED DATA
-- Purpose: Simulates core banking entities: Branches, Accounts, and Transactions.
-- Compatible with SQLite, PostgreSQL, and MySQL.
-- ====================================================================

-- 1. Branches Table
CREATE TABLE branches (
    branch_id VARCHAR(10) PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    opened_date DATE NOT NULL
);

-- 2. Accounts Table
CREATE TABLE accounts (
    account_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    branch_id VARCHAR(10) NOT NULL,
    account_type VARCHAR(20) CHECK (account_type IN ('Savings', 'Current', 'Corporate')),
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- 3. Transactions Table
CREATE TABLE transactions (
    transaction_id VARCHAR(15) PRIMARY KEY,
    account_id VARCHAR(10) NOT NULL,
    transaction_type VARCHAR(20) CHECK (transaction_type IN ('Deposit', 'Withdrawal', 'Transfer')),
    amount DECIMAL(12, 2) NOT NULL,
    transaction_date TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- ====================================================================
-- SEED DATA INSERTION
-- Includes clean records and deliberate anomalies for validation testing
-- ====================================================================

INSERT INTO branches (branch_id, branch_name, region, opened_date) VALUES
('BR001', 'Marina Island Branch', 'Lagos', '2018-03-15'),
('BR002', 'Ikeja Commercial Branch', 'Lagos', '2019-07-20'),
('BR003', 'Abuja Central Branch', 'Abuja', '2020-01-10');

INSERT INTO accounts (account_id, customer_name, branch_id, account_type, status) VALUES
('ACC1001', 'Aliko Adewale', 'BR001', 'Corporate', 'Active'),
('ACC1002', 'Fatima Bello', 'BR002', 'Savings', 'Active'),
('ACC1003', 'Chinedu Okeke', 'BR001', 'Current', 'Active'),
('ACC1004', 'Zainab Musa', 'BR003', 'Savings', 'Dormant'),
('ACC1005', 'Emeka Nwachukwu', 'BR002', 'Current', 'Suspended');

INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, transaction_date, status) VALUES
('TXN9001', 'ACC1001', 'Deposit', 2500000.00, '2026-09-01 09:30:00', 'Success'),
('TXN9002', 'ACC1001', 'Withdrawal', 450000.00, '2026-09-03 14:15:00', 'Success'),
('TXN9003', 'ACC1002', 'Deposit', 120000.00, '2026-09-05 11:00:00', 'Success'),
('TXN9004', 'ACC1003', 'Deposit', 800000.00, '2026-09-07 16:45:00', 'Success'),
('TXN9005', 'ACC1003', 'Withdrawal', 50000.00, '2026-09-10 10:20:00', 'Success'),
('TXN9006', 'ACC1002', 'Withdrawal', 15000.00, '2026-09-15 13:00:00', 'Success'),
('TXN9007', 'ACC1004', 'Deposit', 30000.00, '2026-09-18 12:00:00', 'Failed'),
-- Deliberate Anomaly Records for QA & Validation rules:
('TXN9008', 'ACC1001', 'Deposit', -5000.00, '2026-09-20 08:00:00', 'Success'), -- Negative amount bug
('TXN9009', 'ACC9999', 'Deposit', 200000.00, '2026-09-21 09:00:00', 'Success'); -- Orphan transaction (Unmapped account)
