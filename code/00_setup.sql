-- ==========================================
-- Script: 00_setup.sql
-- Description: Master setup script - Initializes course schema and loads external population data.
-- Author: Final Project Team
-- Status: Core table structures match professor's original files for full data compatibility.
-- ==========================================

-- 1. Initialize Database Environment
SET FOREIGN_KEY_CHECKS=0;
DROP DATABASE IF EXISTS dwsql_course;
CREATE DATABASE dwsql_course;
USE dwsql_course;

-- ==========================================
-- [Step 2] Create Core Table Structures
-- ==========================================

-- DROP ORDER: Must drop child tables first to avoid FK constraints preventing deletion
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS regional_sales;
DROP VIEW IF EXISTS v_employees_public;

-- 1. Customers Table
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120),
    state CHAR(2) NOT NULL,
    region VARCHAR(20) NOT NULL,
    created_at DATE NOT NULL,
    UNIQUE KEY uq_customers_email (email)
)  ENGINE=INNODB;

-- 2. Products Table
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10 , 2 ) NOT NULL
)  ENGINE=INNODB;

-- 3. Orders Table
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    delivered_date DATE,
    status VARCHAR(20) NOT NULL,
    shipping_state CHAR(2) NOT NULL,
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
        REFERENCES customers (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
)  ENGINE=INNODB;

-- 4. Order_Items Table (Uses 'qty' column name and composite primary key as per original structure)
CREATE TABLE order_items (
    order_id INT NOT NULL,
    line_no INT NOT NULL,
    product_id INT NOT NULL,
    qty INT NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    CONSTRAINT pk_order_items PRIMARY KEY (order_id , line_no),
    CONSTRAINT fk_oi_order FOREIGN KEY (order_id)
        REFERENCES orders (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_oi_product FOREIGN KEY (product_id)
        REFERENCES products (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
)  ENGINE=INNODB;

-- 5. Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(12 , 2 ) NOT NULL,
    hire_date DATE NOT NULL
)  ENGINE=INNODB;

-- 6. Regional_Sales Table
CREATE TABLE regional_sales (
    id INT PRIMARY KEY AUTO_INCREMENT,
    region VARCHAR(20) NOT NULL,
    order_month DATE NOT NULL,
    order_total DECIMAL(12 , 2 ) NOT NULL
)  ENGINE=INNODB;

-- Helpful Indexes (Used for core relationships and faster lookups)
CREATE INDEX idx_customers_state ON customers(state);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_oi_product ON order_items(product_id);
CREATE INDEX idx_products_category ON products(category);

-- 7. Employee View
CREATE OR REPLACE VIEW v_employees_public AS
    SELECT 
        employee_id, name, department, hire_date
    FROM
        employees;


-- ==========================================
-- [Step 3] Load Course Raw Data
-- ⚠️ CRITICAL STEP: Paste INSERT statements from setup_and_data.sql here ⚠️
-- ==========================================

-- Insert customers
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (1, 'Kim', 'Gray', 'kim.gray1@example.com', 'IL', 'Midwest', '2024-01-19');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (2, 'Donald', 'Codd', 'donald.codd2@example.com', 'PA', 'Northeast', '2023-07-24');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (3, 'Grace', 'Chen', 'grace.chen3@example.com', 'NY', 'Northeast', '2023-05-25');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (4, 'Jim', 'Nguyen', 'jim.nguyen4@example.com', 'WA', 'West', '2023-06-01');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (5, 'Avery', 'Kim', 'avery.kim5@example.com', 'MA', 'Northeast', '2024-04-02');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (6, 'Edgar', 'Kim', 'edgar.kim6@example.com', 'NY', 'Northeast', '2022-10-14');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (7, 'Avery', 'Garcia', 'avery.garcia7@example.com', 'FL', 'South', '2022-11-06');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (8, 'Casey', 'Patel', 'casey.patel8@example.com', 'PA', 'Northeast', '2023-03-07');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (9, 'Barbara', 'Kim', 'barbara.kim9@example.com', 'CA', 'West', '2022-05-22');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (10, 'Donald', 'Gray', 'donald.gray10@example.com', 'CA', 'West', '2024-11-04');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (11, 'Avery', 'Selinger', 'avery.selinger11@example.com', 'AZ', 'West', '2022-10-18');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (12, 'Morgan', 'Garcia', 'morgan.garcia12@example.com', 'WA', 'West', '2024-11-02');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (13, 'Casey', 'Liskov', 'casey.liskov13@example.com', 'NY', 'Northeast', '2024-06-05');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (14, 'Barbara', 'Taylor', 'barbara.taylor14@example.com', 'NY', 'Northeast', '2023-12-28');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (15, 'Ada', 'Selinger', 'ada.selinger15@example.com', 'MA', 'Northeast', '2022-01-11');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (16, 'Avery', 'Gray', 'avery.gray16@example.com', 'FL', 'South', '2022-08-28');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (17, 'Kim', 'Dijkstra', 'kim.dijkstra17@example.com', 'FL', 'South', '2024-12-15');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (18, 'Barbara', 'Lovelace', 'barbara.lovelace18@example.com', 'IL', 'Midwest', '2022-05-12');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (19, 'Jordan', 'Knuth', 'jordan.knuth19@example.com', 'FL', 'South', '2024-12-27');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (20, 'Kim', 'Chen', 'kim.chen20@example.com', 'TX', 'South', '2023-05-28');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (21, 'Morgan', 'Knuth', 'morgan.knuth21@example.com', 'MA', 'Northeast', '2023-10-16');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (22, 'Edgar', 'Liskov', 'edgar.liskov22@example.com', 'CA', 'West', '2023-07-13');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (23, 'Barbara', 'Lovelace', 'barbara.lovelace23@example.com', 'NY', 'Northeast', '2023-12-14');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (24, 'Ada', 'Selinger', 'ada.selinger24@example.com', 'IL', 'Midwest', '2024-08-28');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (25, 'Morgan', 'Lovelace', 'morgan.lovelace25@example.com', 'FL', 'South', '2023-09-27');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (26, 'Donald', 'Hopper', 'donald.hopper26@example.com', 'GA', 'South', '2022-02-12');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (27, 'Taylor', 'Taylor', 'taylor.taylor27@example.com', 'PA', 'Northeast', '2022-10-11');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (28, 'Jim', 'Selinger', 'jim.selinger28@example.com', 'AZ', 'West', '2024-03-12');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (29, 'Edgar', 'Dijkstra', 'edgar.dijkstra29@example.com', 'IL', 'Midwest', '2022-11-05');
INSERT INTO customers(id, first_name, last_name, email, state, region, created_at) VALUES (30, 'Morgan', 'Hopper', 'morgan.hopper30@example.com', 'FL', 'South', '2022-04-13');
-- Insert products
INSERT INTO products(id, name, category, price) VALUES (1, 'Widget A', 'Grocery', 77.4);
INSERT INTO products(id, name, category, price) VALUES (2, 'Widget B', 'Books', 195.72);
INSERT INTO products(id, name, category, price) VALUES (3, 'Gizmo C', 'Electronics', 43.78);
INSERT INTO products(id, name, category, price) VALUES (4, 'Gizmo D', 'Toys', 27.71);
INSERT INTO products(id, name, category, price) VALUES (5, 'Doohickey E', 'Books', 202.31);
INSERT INTO products(id, name, category, price) VALUES (6, 'Book SQL', 'Clothing', 239.32);
INSERT INTO products(id, name, category, price) VALUES (7, 'Toy Bot', 'Toys', 23.55);
INSERT INTO products(id, name, category, price) VALUES (8, 'Coffee Beans', 'Electronics', 133.07);
INSERT INTO products(id, name, category, price) VALUES (9, 'T-Shirt', 'Home', 58.64);
INSERT INTO products(id, name, category, price) VALUES (10, 'Laptop Stand', 'Books', 140.78);
INSERT INTO products(id, name, category, price) VALUES (11, 'USB-C Hub', 'Books', 17.52);
INSERT INTO products(id, name, category, price) VALUES (12, 'Notebook', 'Toys', 143.22);
INSERT INTO products(id, name, category, price) VALUES (13, 'Data Mug', 'Toys', 58.06);
INSERT INTO products(id, name, category, price) VALUES (14, 'Desk Mat', 'Toys', 126.67);
-- Insert orders
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (1, 15, '2022-06-08', '2022-06-16', 'PLACED', 'MA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (2, 1, '2024-11-29', '2024-12-06', 'PLACED', 'IL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (3, 25, '2023-03-09', '2023-03-14', 'SHIPPED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (4, 19, '2023-01-02', '2023-01-10', 'SHIPPED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (5, 6, '2022-01-17', '2022-01-25', 'SHIPPED', 'NY');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (6, 1, '2022-08-20', '2022-08-28', 'DELIVERED', 'IL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (7, 27, '2023-03-31', '2023-04-01', 'SHIPPED', 'PA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (8, 2, '2023-01-21', '2023-01-30', 'SHIPPED', 'PA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (9, 17, '2023-11-26', '2023-11-28', 'DELIVERED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (10, 11, '2023-10-21', '2023-10-23', 'SHIPPED', 'AZ');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (11, 9, '2023-05-27', '2023-05-29', 'DELIVERED', 'CA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (12, 5, '2023-08-25', '2023-08-27', 'SHIPPED', 'MA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (13, 19, '2023-10-12', '2023-10-20', 'SHIPPED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (14, 11, '2024-06-26', '2024-07-05', 'PLACED', 'AZ');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (15, 4, '2023-11-18', '2023-11-26', 'PLACED', 'WA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (16, 30, '2024-08-05', '2024-08-11', 'PLACED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (17, 30, '2024-11-18', '2024-11-21', 'SHIPPED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (18, 8, '2023-03-20', '2023-03-24', 'DELIVERED', 'PA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (19, 30, '2023-02-21', '2023-02-27', 'PLACED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (20, 12, '2024-10-04', '2024-10-11', 'SHIPPED', 'WA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (21, 7, '2024-01-13', '2024-01-17', 'PLACED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (22, 24, '2024-06-23', '2024-06-25', 'PLACED', 'IL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (23, 16, '2023-11-17', '2023-11-21', 'SHIPPED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (24, 6, '2024-10-14', '2024-10-15', 'SHIPPED', 'NY');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (25, 2, '2022-06-29', '2022-07-04', 'DELIVERED', 'PA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (26, 2, '2022-03-05', '2022-03-14', 'SHIPPED', 'PA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (27, 20, '2023-12-21', '2023-12-29', 'PLACED', 'TX');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (28, 15, '2023-11-06', '2023-11-14', 'SHIPPED', 'MA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (29, 26, '2022-11-01', '2022-11-08', 'PLACED', 'GA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (30, 22, '2024-08-02', '2024-08-05', 'DELIVERED', 'CA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (31, 1, '2022-08-06', '2022-08-08', 'PLACED', 'IL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (32, 14, '2022-07-01', '2022-07-08', 'PLACED', 'NY');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (33, 3, '2024-08-16', '2024-08-21', 'DELIVERED', 'NY');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (34, 5, '2022-05-26', '2022-06-01', 'DELIVERED', 'MA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (35, 22, '2023-02-15', '2023-02-20', 'DELIVERED', 'CA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (36, 26, '2023-06-24', '2023-07-04', 'PLACED', 'GA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (37, 16, '2023-10-07', '2023-10-11', 'DELIVERED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (38, 15, '2023-03-03', '2023-03-11', 'SHIPPED', 'MA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (39, 9, '2022-04-15', '2022-04-20', 'DELIVERED', 'CA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (40, 25, '2022-02-01', '2022-02-02', 'DELIVERED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (41, 22, '2023-10-12', '2023-10-22', 'PLACED', 'CA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (42, 17, '2022-11-10', '2022-11-18', 'DELIVERED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (43, 22, '2024-03-27', '2024-03-29', 'SHIPPED', 'CA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (44, 11, '2022-11-04', '2022-11-12', 'PLACED', 'AZ');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (45, 8, '2024-10-17', '2024-10-21', 'SHIPPED', 'PA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (46, 9, '2023-10-24', '2023-11-01', 'SHIPPED', 'CA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (47, 2, '2024-01-03', '2024-01-05', 'DELIVERED', 'PA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (48, 8, '2023-03-06', '2023-03-15', 'PLACED', 'PA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (49, 30, '2022-03-08', '2022-03-16', 'SHIPPED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (50, 6, '2023-08-05', '2023-08-15', 'SHIPPED', 'NY');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (51, 27, '2022-12-02', '2022-12-08', 'SHIPPED', 'PA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (52, 6, '2024-05-25', '2024-05-30', 'SHIPPED', 'NY');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (53, 2, '2022-01-10', '2022-01-15', 'PLACED', 'PA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (54, 7, '2022-06-28', '2022-07-04', 'PLACED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (55, 8, '2024-05-07', '2024-05-08', 'PLACED', 'PA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (56, 8, '2024-08-26', '2024-08-31', 'DELIVERED', 'PA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (57, 9, '2022-05-12', '2022-05-20', 'SHIPPED', 'CA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (58, 7, '2022-04-28', '2022-05-06', 'SHIPPED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (59, 30, '2023-06-13', '2023-06-22', 'SHIPPED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (60, 27, '2022-03-08', '2022-03-15', 'DELIVERED', 'PA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (61, 9, '2024-11-03', '2024-11-08', 'DELIVERED', 'CA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (62, 1, '2023-04-02', '2023-04-11', 'PLACED', 'IL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (63, 17, '2023-06-11', '2023-06-20', 'DELIVERED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (64, 25, '2023-07-28', '2023-08-06', 'DELIVERED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (65, 15, '2023-09-20', '2023-09-22', 'PLACED', 'MA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (66, 12, '2024-12-03', '2024-12-08', 'SHIPPED', 'WA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (67, 19, '2022-12-06', '2022-12-08', 'DELIVERED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (68, 7, '2022-03-02', '2022-03-04', 'PLACED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (69, 20, '2023-02-12', '2023-02-19', 'DELIVERED', 'TX');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (70, 7, '2023-02-19', '2023-02-24', 'PLACED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (71, 16, '2023-09-07', '2023-09-16', 'SHIPPED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (72, 10, '2022-12-07', '2022-12-11', 'DELIVERED', 'CA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (73, 22, '2023-08-27', '2023-09-04', 'SHIPPED', 'CA');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (74, 19, '2024-04-13', '2024-04-19', 'PLACED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (75, 6, '2023-01-31', '2023-02-04', 'PLACED', 'NY');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (76, 23, '2022-05-06', '2022-05-10', 'PLACED', 'NY');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (77, 19, '2022-07-09', '2022-07-14', 'SHIPPED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (78, 7, '2023-10-22', '2023-10-25', 'DELIVERED', 'FL');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (79, 3, '2023-12-01', '2023-12-10', 'SHIPPED', 'NY');
INSERT INTO orders(id, customer_id, order_date, delivered_date, status, shipping_state) VALUES (80, 1, '2024-06-09', '2024-06-17', 'DELIVERED', 'IL');
-- Insert order_items
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (1, 1, 8, 3, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (1, 2, 14, 2, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (1, 3, 6, 5, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (2, 1, 10, 2, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (2, 2, 9, 2, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (2, 3, 10, 3, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (2, 4, 6, 2, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (3, 1, 8, 5, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (3, 2, 2, 5, 195.72);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (3, 3, 2, 5, 195.72);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (3, 4, 1, 2, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (4, 1, 14, 5, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (4, 2, 3, 5, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (4, 3, 9, 4, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (4, 4, 8, 1, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (4, 5, 5, 3, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (5, 1, 4, 1, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (5, 2, 5, 1, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (5, 3, 9, 6, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (5, 4, 12, 1, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (6, 1, 10, 2, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (6, 2, 13, 1, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (6, 3, 13, 1, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (6, 4, 8, 5, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (7, 1, 7, 1, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (7, 2, 12, 5, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (8, 1, 6, 3, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (8, 2, 9, 5, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (8, 3, 14, 4, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (8, 4, 7, 1, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (9, 1, 11, 6, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (9, 2, 14, 3, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (10, 1, 9, 2, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (10, 2, 8, 3, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (10, 3, 8, 1, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (11, 1, 5, 6, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (11, 2, 4, 4, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (11, 3, 6, 2, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (11, 4, 4, 5, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (11, 5, 13, 5, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (12, 1, 9, 4, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (12, 2, 13, 5, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (12, 3, 10, 2, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (12, 4, 11, 5, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (12, 5, 3, 2, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (13, 1, 2, 5, 195.72);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (13, 2, 4, 2, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (13, 3, 12, 2, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (13, 4, 13, 2, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (13, 5, 7, 5, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (14, 1, 4, 4, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (14, 2, 5, 5, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (14, 3, 4, 3, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (14, 4, 1, 6, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (15, 1, 2, 5, 195.72);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (15, 2, 7, 2, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (15, 3, 3, 1, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (15, 4, 5, 1, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (15, 5, 5, 3, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (16, 1, 12, 3, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (16, 2, 5, 4, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (16, 3, 14, 3, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (17, 1, 14, 6, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (17, 2, 11, 3, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (18, 1, 14, 6, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (18, 2, 7, 4, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (18, 3, 5, 1, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (18, 4, 5, 4, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (19, 1, 14, 5, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (19, 2, 10, 1, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (20, 1, 12, 3, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (20, 2, 8, 2, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (20, 3, 13, 4, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (20, 4, 4, 2, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (21, 1, 2, 4, 195.72);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (21, 2, 11, 2, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (21, 3, 6, 6, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (21, 4, 9, 2, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (21, 5, 10, 4, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (22, 1, 7, 4, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (22, 2, 4, 6, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (22, 3, 7, 4, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (23, 1, 4, 2, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (23, 2, 8, 1, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (23, 3, 8, 1, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (23, 4, 7, 6, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (23, 5, 8, 1, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (24, 1, 3, 2, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (24, 2, 3, 3, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (24, 3, 3, 1, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (24, 4, 14, 1, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (24, 5, 5, 4, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (25, 1, 9, 3, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (25, 2, 11, 4, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (25, 3, 9, 3, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (25, 4, 13, 5, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (26, 1, 12, 1, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (26, 2, 5, 3, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (27, 1, 1, 3, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (27, 2, 6, 4, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (28, 1, 1, 5, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (28, 2, 13, 1, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (28, 3, 6, 5, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (29, 1, 1, 6, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (29, 2, 7, 1, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (30, 1, 9, 4, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (30, 2, 1, 6, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (30, 3, 14, 3, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (31, 1, 4, 3, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (31, 2, 13, 6, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (31, 3, 5, 3, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (31, 4, 10, 3, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (31, 5, 9, 1, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (32, 1, 2, 3, 195.72);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (32, 2, 9, 3, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (32, 3, 12, 4, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (32, 4, 13, 1, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (32, 5, 14, 4, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (33, 1, 12, 5, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (33, 2, 14, 6, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (34, 1, 14, 2, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (34, 2, 14, 5, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (35, 1, 13, 1, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (35, 2, 2, 4, 195.72);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (35, 3, 13, 1, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (35, 4, 8, 5, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (35, 5, 7, 4, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (36, 1, 10, 2, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (36, 2, 13, 6, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (36, 3, 4, 3, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (36, 4, 14, 2, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (36, 5, 11, 3, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (37, 1, 14, 2, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (37, 2, 13, 5, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (38, 1, 14, 4, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (38, 2, 10, 1, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (38, 3, 4, 1, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (38, 4, 4, 1, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (39, 1, 14, 4, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (39, 2, 7, 6, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (39, 3, 1, 5, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (39, 4, 9, 5, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (40, 1, 12, 5, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (40, 2, 6, 6, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (40, 3, 3, 3, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (40, 4, 10, 5, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (41, 1, 10, 4, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (41, 2, 8, 1, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (41, 3, 3, 1, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (41, 4, 3, 4, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (42, 1, 1, 2, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (42, 2, 7, 4, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (43, 1, 4, 2, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (43, 2, 12, 1, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (43, 3, 10, 4, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (44, 1, 12, 3, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (44, 2, 5, 6, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (44, 3, 12, 4, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (44, 4, 8, 1, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (44, 5, 3, 1, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (45, 1, 5, 5, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (45, 2, 12, 5, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (46, 1, 1, 4, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (46, 2, 13, 3, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (46, 3, 12, 2, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (46, 4, 9, 2, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (46, 5, 4, 1, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (47, 1, 4, 3, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (47, 2, 13, 3, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (48, 1, 14, 5, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (48, 2, 10, 5, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (48, 3, 1, 4, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (49, 1, 6, 5, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (49, 2, 9, 4, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (49, 3, 10, 1, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (49, 4, 1, 1, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (49, 5, 2, 5, 195.72);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (50, 1, 3, 3, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (50, 2, 3, 3, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (51, 1, 4, 5, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (51, 2, 8, 3, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (51, 3, 11, 6, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (51, 4, 11, 6, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (51, 5, 7, 2, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (52, 1, 11, 1, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (52, 2, 12, 5, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (52, 3, 12, 3, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (52, 4, 3, 3, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (53, 1, 6, 5, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (53, 2, 2, 5, 195.72);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (54, 1, 14, 5, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (54, 2, 8, 3, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (54, 3, 3, 4, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (54, 4, 14, 4, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (54, 5, 4, 5, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (55, 1, 13, 5, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (55, 2, 11, 1, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (55, 3, 7, 5, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (56, 1, 9, 2, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (56, 2, 6, 4, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (56, 3, 3, 6, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (56, 4, 6, 3, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (57, 1, 7, 6, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (57, 2, 1, 5, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (57, 3, 13, 2, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (57, 4, 7, 6, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (57, 5, 6, 1, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (58, 1, 10, 6, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (58, 2, 11, 3, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (59, 1, 12, 2, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (59, 2, 1, 2, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (59, 3, 1, 4, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (59, 4, 2, 4, 195.72);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (60, 1, 14, 5, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (60, 2, 14, 2, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (60, 3, 13, 5, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (60, 4, 11, 3, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (61, 1, 1, 3, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (61, 2, 11, 3, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (62, 1, 1, 3, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (62, 2, 13, 1, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (62, 3, 10, 5, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (62, 4, 6, 1, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (62, 5, 4, 3, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (63, 1, 9, 1, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (63, 2, 6, 4, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (63, 3, 2, 3, 195.72);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (64, 1, 9, 5, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (64, 2, 4, 5, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (64, 3, 3, 3, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (64, 4, 1, 5, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (64, 5, 12, 2, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (65, 1, 1, 2, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (65, 2, 4, 2, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (66, 1, 2, 4, 195.72);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (66, 2, 9, 4, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (67, 1, 8, 4, 133.07);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (67, 2, 12, 5, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (67, 3, 1, 5, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (67, 4, 7, 4, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (68, 1, 6, 5, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (68, 2, 14, 2, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (68, 3, 3, 6, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (68, 4, 13, 5, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (69, 1, 14, 3, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (69, 2, 14, 6, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (70, 1, 9, 6, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (70, 2, 3, 5, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (70, 3, 5, 1, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (70, 4, 2, 6, 195.72);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (71, 1, 6, 5, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (71, 2, 4, 5, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (71, 3, 12, 2, 143.22);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (71, 4, 4, 3, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (71, 5, 5, 4, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (72, 1, 11, 5, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (72, 2, 6, 2, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (72, 3, 5, 1, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (72, 4, 4, 3, 27.71);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (72, 5, 9, 3, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (73, 1, 9, 4, 58.64);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (73, 2, 5, 6, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (73, 3, 3, 2, 43.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (73, 4, 1, 5, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (73, 5, 5, 5, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (74, 1, 6, 5, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (74, 2, 13, 4, 58.06);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (74, 3, 1, 2, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (75, 1, 14, 5, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (75, 2, 7, 3, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (76, 1, 6, 3, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (76, 2, 1, 2, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (76, 3, 6, 4, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (77, 1, 7, 3, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (77, 2, 6, 2, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (78, 1, 7, 1, 23.55);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (78, 2, 1, 2, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (78, 3, 14, 4, 126.67);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (78, 4, 11, 1, 17.52);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (78, 5, 1, 5, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (79, 1, 10, 5, 140.78);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (79, 2, 6, 3, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (79, 3, 5, 1, 202.31);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (80, 1, 1, 6, 77.4);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (80, 2, 6, 2, 239.32);
INSERT INTO order_items(order_id, line_no, product_id, qty, unit_price) VALUES (80, 3, 3, 5, 43.78);
-- Insert employees
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (1, 'Grace Codd', 'Finance', 137957.43, '2021-10-25');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (2, 'Pat Garcia', 'Finance', 80024.59, '2020-09-06');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (3, 'Grace Dijkstra', 'Sales', 54451.27, '2017-01-30');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (4, 'Casey Chen', 'Finance', 68131.87, '2018-01-05');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (5, 'Barbara Lee', 'Engineering', 89063.43, '2023-01-21');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (6, 'Riley Lovelace', 'Sales', 159301.12, '2023-09-28');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (7, 'Edgar Codd', 'Engineering', 148499.83, '2021-09-29');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (8, 'Jordan Hopper', 'Finance', 58246.14, '2020-10-08');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (9, 'Jordan Dijkstra', 'Support', 74610.77, '2023-06-02');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (10, 'Pat Garcia', 'Finance', 126839.46, '2019-02-20');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (11, 'Kim Patel', 'Engineering', 79900.59, '2018-07-10');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (12, 'Edgar Gray', 'HR', 164334.83, '2021-07-20');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (13, 'Grace Lee', 'Sales', 123847.57, '2018-12-03');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (14, 'Riley Lee', 'Finance', 128850.45, '2020-01-17');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (15, 'Donald Hopper', 'Sales', 74477.08, '2018-10-10');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (16, 'Casey Kim', 'Sales', 149045.4, '2018-10-13');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (17, 'Jordan Codd', 'Engineering', 138808.15, '2018-10-12');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (18, 'Barbara Liskov', 'Sales', 86669.0, '2024-01-09');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (19, 'Riley Chen', 'Support', 55549.02, '2024-02-22');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (20, 'Donald Taylor', 'HR', 86029.0, '2019-01-12');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (21, 'Kim Patel', 'Engineering', 109442.21, '2017-06-01');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (22, 'Taylor Taylor', 'Finance', 146900.8, '2021-01-09');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (23, 'Morgan Selinger', 'HR', 98689.94, '2017-08-26');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (24, 'Edsger Garcia', 'HR', 150772.7, '2017-06-27');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (25, 'Pat Knuth', 'Sales', 61329.0, '2023-03-24');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (26, 'Kim Gray', 'Engineering', 159449.4, '2024-04-20');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (27, 'Donald Lovelace', 'Sales', 154520.64, '2022-12-25');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (28, 'Pat Nguyen', 'Engineering', 134011.71, '2022-11-20');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (29, 'Kim Gray', 'Support', 87620.48, '2021-01-24');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (30, 'Barbara Nguyen', 'HR', 125050.04, '2017-01-10');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (31, 'Jordan Nguyen', 'Support', 163725.66, '2021-04-24');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (32, 'Taylor Garcia', 'Support', 66048.72, '2019-10-29');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (33, 'Riley Chen', 'Finance', 77086.78, '2021-04-05');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (34, 'Kim Liskov', 'Engineering', 68666.45, '2017-12-10');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (35, 'Grace Liskov', 'Engineering', 126829.43, '2020-10-24');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (36, 'Kim Knuth', 'HR', 119660.8, '2019-04-04');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (37, 'Morgan Dijkstra', 'HR', 121705.07, '2018-02-06');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (38, 'Avery Gray', 'Sales', 154424.61, '2022-03-04');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (39, 'Casey Nguyen', 'Finance', 156154.71, '2021-07-04');
INSERT INTO employees(employee_id, name, department, salary, hire_date) VALUES (40, 'Casey Selinger', 'Engineering', 139316.04, '2020-05-08');
-- Insert regional sales summaries
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (1, 'Midwest', '2022-08-01', 2582.43);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (2, 'Midwest', '2023-04-01', 1316.61);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (3, 'Midwest', '2024-06-01', 1516.6);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (4, 'Midwest', '2024-11-01', 1299.82);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (5, 'Northeast', '2022-01-01', 2900.28);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (6, 'Northeast', '2022-03-01', 1979.7);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (7, 'Northeast', '2022-05-01', 2716.73);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (8, 'Northeast', '2022-06-01', 2561.37);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (9, 'Northeast', '2022-07-01', 1900.7);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (10, 'Northeast', '2022-12-01', 795.1);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (11, 'Northeast', '2023-01-01', 2245.39);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (12, 'Northeast', '2023-03-01', 4955.15);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (13, 'Northeast', '2023-08-01', 1244.26);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (14, 'Northeast', '2023-09-01', 210.22);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (15, 'Northeast', '2023-11-01', 1641.66);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (16, 'Northeast', '2023-12-01', 1624.17);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (17, 'Northeast', '2024-01-01', 257.31);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (18, 'Northeast', '2024-05-01', 1720.19);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (19, 'Northeast', '2024-08-01', 3531.32);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (20, 'Northeast', '2024-10-01', 2926.24);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (21, 'South', '2022-02-01', 2987.26);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (22, 'South', '2022-03-01', 4630.86);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (23, 'South', '2022-04-01', 897.24);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (24, 'South', '2022-06-01', 1852.91);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (25, 'South', '2022-07-01', 549.29);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (26, 'South', '2022-11-01', 736.95);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (27, 'South', '2022-12-01', 1729.58);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (28, 'South', '2023-01-01', 1826.81);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (29, 'South', '2023-02-01', 3861.53);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (30, 'South', '2023-03-01', 2777.35);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (31, 'South', '2023-06-01', 4155.75);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (32, 'South', '2023-07-01', 1236.53);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (33, 'South', '2023-09-01', 2513.96);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (34, 'South', '2023-10-01', 3187.52);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (35, 'South', '2023-11-01', 1081.06);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (36, 'South', '2023-12-01', 1189.48);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (37, 'South', '2024-01-01', 2934.24);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (38, 'South', '2024-04-01', 1583.64);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (39, 'South', '2024-08-01', 1618.91);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (40, 'South', '2024-11-01', 812.58);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (41, 'West', '2022-04-01', 1328.18);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (42, 'West', '2022-05-01', 1025.04);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (43, 'West', '2022-11-01', 2393.25);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (44, 'West', '2022-12-01', 1027.6);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (45, 'West', '2023-02-01', 1658.55);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (46, 'West', '2023-05-01', 2232.19);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (47, 'West', '2023-08-01', 2934.53);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (48, 'West', '2023-10-01', 2479.86);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (49, 'West', '2023-11-01', 1878.72);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (50, 'West', '2024-03-01', 761.76);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (51, 'West', '2024-06-01', 1669.92);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (52, 'West', '2024-08-01', 1078.97);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (53, 'West', '2024-10-01', 983.46);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (54, 'West', '2024-11-01', 284.76);
INSERT INTO regional_sales(id, region, order_month, order_total) VALUES (55, 'West', '2024-12-01', 1017.44);

-- >>>>> END PASTE <<<<<


-- ==========================================
-- [Step 4] Load External Data: State Population
-- (Fulfills "External CSV Enrichment" requirement)
-- ==========================================

DROP TABLE IF EXISTS state_population;

CREATE TABLE state_population (
    state CHAR(2) PRIMARY KEY,
    population INT,
    median_income INT,
    region VARCHAR(20),
    urban_pct DECIMAL(5,1)
);

-- Insert complete 50-state data (derived from state_population.csv)
-- Ensures successful JOINs regardless of shipping state in orders
INSERT INTO state_population (state, population, median_income, region, urban_pct) VALUES
('AL', 5039877, 54200, 'South', 59.0),
('AK', 733583, 77640, 'West', 66.0),
('AZ', 7276316, 62000, 'West', 89.8),
('AR', 3025891, 52000, 'South', 56.2),
('CA', 39538223, 75000, 'West', 94.2),
('CO', 5773714, 72000, 'West', 86.2),
('CT', 3605944, 83000, 'Northeast', 88.0),
('DE', 989948, 70000, 'South', 83.3),
('DC', 689545, 92000, 'South', 100.0),
('FL', 21538187, 62000, 'South', 91.2),
('GA', 10711908, 60000, 'South', 77.0),
('HI', 1455271, 83000, 'West', 92.0),
('ID', 1839106, 58000, 'West', 70.6),
('IL', 12812508, 72000, 'Midwest', 88.5),
('IN', 6785528, 62000, 'Midwest', 72.4),
('IA', 3190369, 60000, 'Midwest', 64.0),
('KS', 2937880, 61000, 'Midwest', 74.2),
('KY', 4505836, 52000, 'South', 58.4),
('LA', 4657757, 50000, 'South', 73.2),
('ME', 1362359, 59000, 'Northeast', 38.7),
('MD', 6177224, 87000, 'South', 87.2),
('MA', 7029917, 85000, 'Northeast', 92.0),
('MI', 10077331, 59000, 'Midwest', 74.6),
('MN', 5706494, 73000, 'Midwest', 73.3),
('MS', 2961279, 45000, 'South', 49.3),
('MO', 6154913, 57000, 'Midwest', 70.4),
('MT', 1084225, 56000, 'West', 55.9),
('NE', 1961504, 63000, 'Midwest', 73.1),
('NV', 3104614, 62000, 'West', 94.2),
('NH', 1377529, 78000, 'Northeast', 60.3),
('NJ', 9288994, 85000, 'Northeast', 94.7),
('NM', 2117522, 51000, 'West', 77.4),
('NY', 19835913, 72000, 'Northeast', 87.9),
('NC', 10439388, 56000, 'South', 66.1),
('ND', 779094, 65000, 'Midwest', 59.9),
('OH', 11799448, 58000, 'Midwest', 77.9),
('OK', 3959353, 54000, 'South', 66.2),
('OR', 4237256, 67000, 'West', 81.0),
('PA', 13002700, 63000, 'Northeast', 78.7),
('RI', 1097379, 70000, 'Northeast', 90.7),
('SC', 5118425, 56000, 'South', 66.3),
('SD', 886667, 59000, 'Midwest', 56.7),
('TN', 6910840, 56000, 'South', 66.4),
('TX', 29145505, 64000, 'South', 84.7),
('UT', 3271616, 74000, 'West', 90.6),
('VT', 643077, 63000, 'Northeast', 38.9),
('VA', 8631393, 76000, 'South', 75.5),
('WA', 7705281, 77000, 'West', 84.0),
('WV', 1793716, 48000, 'South', 48.7),
('WI', 5893718, 63000, 'Midwest', 70.2),
('WY', 576851, 65000, 'West', 64.8);

SET FOREIGN_KEY_CHECKS=1;

SELECT 'Setup Complete. Tables created, Population data loaded. Please ensure you pasted the INSERTs from setup_and_data.sql!' AS status_message;