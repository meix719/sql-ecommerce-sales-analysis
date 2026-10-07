-- ==========================================
-- Script: 02_cleaning.sql
-- Description: Fix data quality issues, handle NULLs, trim whitespace, and add targeted indexes. (Fulfills Data Cleaning & Optimization requirements)
-- ==========================================

USE dwsql_course;

-- 1. Disable Safe Update mode to allow bulk updates
SET SQL_SAFE_UPDATES = 0;

-- 2. Standardize Data: Trim potential whitespace from State fields
UPDATE customers 
SET 
    state = TRIM(state);
UPDATE orders 
SET 
    shipping_state = TRIM(shipping_state);

-- 3. Handle NULL Values
-- Fix: Impute missing delivered_date for orders marked 'COMPLETED' by setting it to 5 days after order_date.
UPDATE orders 
SET 
    delivered_date = DATE_ADD(order_date, INTERVAL 5 DAY)
WHERE
    delivered_date IS NULL
        AND status = 'COMPLETED';

-- 4. Optimization: Create Targeted Indexes 
-- These indexes support efficient joins/filters for the Analysis phase, particularly with the external data.
-- Core FK indexes are already handled in 00_setup.sql.
CREATE INDEX idx_orders_state ON orders(shipping_state);
CREATE INDEX idx_pop_state ON state_population(state);

-- 5. Verify Cleaning
SELECT 'Cleaning completed and targeted indexes created for external data joins.' AS message;

SET SQL_SAFE_UPDATES = 1;