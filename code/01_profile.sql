-- ==========================================
-- Script: 01_profile.sql
-- Description: Inspect data quality, identify NULLs, outliers, and formatting inconsistencies. (Fulfills Data Profiling requirement)
-- ==========================================

USE dwsql_course;

-- 1. Check for NULL values in Orders table
SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE
        WHEN delivered_date IS NULL THEN 1
        ELSE 0
    END) AS pending_delivery_count,
    SUM(CASE
        WHEN
            shipping_state IS NULL
                OR shipping_state = ''
        THEN
            1
        ELSE 0
    END) AS missing_state_count,
    SUM(CASE
        WHEN status IS NULL THEN 1
        ELSE 0
    END) AS missing_status_count
FROM
    orders;

-- 2. Check for Format Inconsistency in 'State' field
-- Identifies state codes with trailing spaces that need to be trimmed.
SELECT 
    shipping_state,
    LENGTH(shipping_state) AS len,
    COUNT(*) AS count
FROM
    orders
GROUP BY shipping_state
HAVING LENGTH(shipping_state) > 2;

-- 3. Check for Pricing Anomalies in Order Items (Uses 'qty')
-- Verifies that unit price and quantity are positive, as required by business logic.
SELECT 
    *
FROM
    order_items
WHERE
    unit_price <= 0 OR qty <= 0;

-- 4. Verify Data Integrity with External Data
-- Checks for states in 'orders' that don't exist in the 'state_population' table, indicating missing data.
SELECT DISTINCT
    o.shipping_state
FROM
    orders o
        LEFT JOIN
    state_population p ON o.shipping_state = p.state
WHERE
    p.state IS NULL;

-- 5. Inspect Order Status Distribution
SELECT 
    status, COUNT(*) AS cnt
FROM
    orders
GROUP BY status;