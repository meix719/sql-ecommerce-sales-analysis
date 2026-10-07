# U.S. E-Commerce Sales Analysis with SQL

## Overview
This academic team project uses MySQL to explore sales across U.S. states. It combines transaction records with state population, median income, region, and urbanization data to compare sales performance.

## Business Question
Which states generate the highest sales per capita in this dataset, and how do sales patterns differ across regions and state demographic groups?

## Tools and Skills
- MySQL
- Multi-table joins and aggregate functions
- Common table expressions (CTEs)
- Window functions: DENSE_RANK and AVG OVER
- Data quality checks and cleaning
- Indexes and SQL views
- Data preparation for charts

## Analysis
The project examines:
1. Total revenue and order counts by state
2. State rankings by sales per capita
3. Revenue by state population group
4. Monthly sales and a trailing three-month moving average
5. Regional revenue and average order value
6. Average order value by shipping states’ median-income tiers

## Key Findings
- Florida generated the highest revenue in the sample: $38,327.04 across 25 orders.
- The South accounted for approximately 40% of sample revenue.
- Monthly sales fluctuated, with the moving average smoothing short-term changes.

These findings suggest areas for further investigation and marketing experiments. They do not establish broader market demand or explain what caused sales differences.

## Project Files
The `code` folder contains five scripts:
- `00_setup.sql`: Creates the database and loads data.
- `01_profile.sql`: Checks missing values, formatting, pricing, and state matches.
- `02_cleaning.sql`: Standardizes state fields, applies a delivery-date imputation rule, and adds indexes.
- `03_analysis.sql`: Runs the six analyses.
- `04_viz_prep.sql`: Creates a consolidated view and chart-ready summaries.

## How to Run
Use MySQL 8.0 or later. Open the scripts in MySQL Workbench and run them in numbered order, starting with `00_setup.sql`.

**Important:** The setup script drops and recreates the `dwsql_course` database. Run it only in a dedicated practice environment.

## Limitations
- The course dataset contains 30 customers and 80 orders.
- Sample sales divided by state population are comparison metrics, not estimates of statewide spending.
- State median income does not represent individual customers’ incomes.
- The analysis is descriptive and does not establish causation.
- The moving average uses the current and two preceding observed monthly rows; missing months would need explicit handling.

## Team
Mei Qiong Xue, Yufei Cai, and Weimin Wu.
