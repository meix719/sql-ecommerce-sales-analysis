-- ==========================================
-- Script: 04_viz_prep.sql
-- Description: Prepare final datasets for Visualization tools (Tableau/Excel). (Fulfills Visual Outputs requirement)
-- Output: Consolidated metrics for state ranking and regional comparison.
-- ==========================================

USE dwsql_course;

-- Create a master view integrating all analytical dimensions
-- This view consolidates sales, population, income, and AOV, providing a single data source 
-- for the required visualizations.
CREATE OR REPLACE VIEW v_final_state_metrics AS
WITH RawSales AS (
    -- CTE: Aggregate raw sales data by state
    SELECT 
        o.shipping_state,
        SUM(oi.qty * oi.unit_price) as total_sales,
        COUNT(DISTINCT o.id) as num_orders
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY o.shipping_state
)
SELECT 
    p.region,
    p.state,
    p.population,
    p.median_income,
    p.urban_pct,
    COALESCE(r.total_sales, 0) as total_sales,
    COALESCE(r.num_orders, 0) as num_orders,
    -- Key Metric 1: Sales Per Capita (Required for Bar Chart)
    ROUND(COALESCE(r.total_sales, 0) / p.population, 5) as sales_per_capita,
    -- Key Metric 2: Average Order Value (AOV)
    ROUND(COALESCE(r.total_sales, 0) / NULLIF(r.num_orders, 0), 2) as avg_order_value
FROM state_population p
LEFT JOIN RawSales r ON p.state = r.shipping_state;

-- Final Query 1: Top 10 States by Per Capita Sales
-- Output for the required "Bar chart: Top 10 states by per-capita sales."
SELECT 
    *
FROM
    v_final_state_metrics
ORDER BY sales_per_capita DESC
LIMIT 10;

-- Final Query 2: Regional Summary
-- Output for comparative analysis (e.g., Pie Chart or Table in the presentation).
SELECT 
    region,
    SUM(total_sales) AS region_total_sales,
    SUM(population) AS region_population,
    ROUND(SUM(total_sales) / SUM(population), 5) AS region_per_capita
FROM
    v_final_state_metrics
GROUP BY region
ORDER BY region_total_sales DESC;