-- ==========================================
-- Script: 03_analysis.sql
-- Description: Core Analysis - Aggregation, Joins, CTEs, and Window Functions. (Fulfills SQL Depth requirement)
-- Goals: Calculate per-capita sales, rank states, and analyze income/regional trends.
-- CRITICAL: All revenue calculation correctly uses the 'oi.qty' column.
-- ==========================================

USE dwsql_course;

-- Analysis 1: Total Sales per State
-- Basic aggregation showing raw revenue, precursor to per-capita analysis.
SELECT 
    o.shipping_state,
    COUNT(DISTINCT o.id) AS total_orders,
    SUM(oi.qty * oi.unit_price) AS total_revenue
FROM
    orders o
        JOIN
    order_items oi ON o.id = oi.order_id
GROUP BY o.shipping_state
ORDER BY total_revenue DESC;

-- Analysis 2: CTE and Window Function - Rank States by Per-Capita Sales
-- Fulfills requirements for CTEs, Window Functions, and per-capita metric calculation.
WITH StateSales AS (
    -- CTE: Calculates total revenue per state
    SELECT 
        o.shipping_state,
        SUM(oi.qty * oi.unit_price) as state_revenue
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY o.shipping_state
)
SELECT 
    s.shipping_state,
    p.region,
    s.state_revenue,
    p.population,
    -- Calculate sales per capita
    ROUND((s.state_revenue / p.population), 4) as sales_per_capita,
    -- Window Function: Ranks states based on per-capita performance
    DENSE_RANK() OVER (ORDER BY (s.state_revenue / p.population) DESC) as per_capita_rank
FROM StateSales s
JOIN state_population p ON s.shipping_state = p.state
ORDER BY per_capita_rank;

-- Analysis 3: Advanced Aggregation - Revenue vs. Population Segments
-- Grouping states by population size to test correlation hypothesis.
SELECT 
    CASE
        WHEN p.population > 10000000 THEN 'High Pop (>10M)'
        WHEN p.population > 5000000 THEN 'Med Pop (5M-10M)'
        ELSE 'Small Pop (<5M)'
    END AS population_segment,
    COUNT(DISTINCT s.shipping_state) AS state_count,
    ROUND(AVG(s.state_revenue), 2) AS avg_revenue_per_state,
    ROUND(AVG(p.urban_pct), 1) AS avg_urban_pct
FROM
    (SELECT 
        o.shipping_state,
            SUM(oi.qty * oi.unit_price) AS state_revenue
    FROM
        orders o
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY o.shipping_state) s
        JOIN
    state_population p ON s.shipping_state = p.state
GROUP BY 1
ORDER BY avg_revenue_per_state DESC;

-- Analysis 4: Rolling Average Analysis - Using Window Function AVG
-- Calculates monthly sales trends smoothed with a 3-month moving average.
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') as sales_month,
    SUM(oi.qty * oi.unit_price) as monthly_sales,
    -- Window Function: 3-month centered moving average
    AVG(SUM(oi.qty * oi.unit_price)) OVER (
        ORDER BY DATE_FORMAT(o.order_date, '%Y-%m') 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as 3_month_moving_avg
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY 1
ORDER BY 1;

-- Analysis 5: Regional Performance Comparison
-- Fulfills requirement to compare regional trends. Focuses on Average Order Value (AOV).
SELECT 
    p.region,
    COUNT(DISTINCT o.id) AS total_orders,
    SUM(oi.qty * oi.unit_price) AS total_revenue,
    ROUND(SUM(oi.qty * oi.unit_price) / COUNT(DISTINCT o.id),
            2) AS avg_order_value
FROM
    orders o
        JOIN
    order_items oi ON o.id = oi.order_id
        JOIN
    state_population p ON o.shipping_state = p.state
GROUP BY p.region
ORDER BY total_revenue DESC;

-- Analysis 6: Impact of Income on Spending
-- Directly tests the correlation between median income and customer spending habits (AOV).
WITH OrderValues AS (
    -- CTE: Calculates the total value for each order
    SELECT o.id, o.shipping_state, SUM(oi.qty * oi.unit_price) as order_total
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY o.id, o.shipping_state
)
SELECT 
    CASE 
        WHEN p.median_income > 75000 THEN 'High Income (>75k)'
        WHEN p.median_income BETWEEN 60000 AND 75000 THEN 'Middle Income (60k-75k)'
        ELSE 'Lower Income (<60k)'
    END as income_tier,
    COUNT(ov.id) as num_orders,
    ROUND(AVG(ov.order_total), 2) as avg_order_value
FROM OrderValues ov
JOIN state_population p ON ov.shipping_state = p.state
GROUP BY 1
ORDER BY avg_order_value DESC;