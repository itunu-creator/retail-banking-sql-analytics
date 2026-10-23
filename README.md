# Retail Banking Data Modeling & SQL Data Quality Suite

## Overview
This repository implements a relational data model for commercial retail banking operations. It simulates daily transactional pipelines, implements rigorous data quality checks to enforce integrity benchmarks, and computes core financial KPIs using optimized SQL.

## Architecture & Relational Schema
The database schema consists of three interconnected entities:
* **Branches:** Branch metadata, physical regions, and establishment dates.
* **Accounts:** Customer accounts with validation on account status (`Active`, `Dormant`, `Suspended`).
* **Transactions:** Granular records of financial flow (`Deposit`, `Withdrawal`, `Transfer`).

## Repository Structure
* `01_schema_and_seed.sql`: Data Definition Language (DDL) and sample seed data.
* `02_data_quality_validation.sql`: Automated QA queries identifying data anomalies (negative amounts, orphaned transactions).
* `03_analytical_kpis.sql`: Analytical queries utilizing aggregations and SQL window functions to determine net cash flow and customer running balances.

## Key SQL Techniques Demonstrated
* Referential integrity and foreign key constraints.
* Data quality audits and anomaly isolation using `LEFT JOIN` and condition filtering.
* Analytical window functions (`SUM() OVER (PARTITION BY ... ORDER BY ...)`).
* Conditional aggregation using `CASE WHEN` statements for financial variance modeling.
