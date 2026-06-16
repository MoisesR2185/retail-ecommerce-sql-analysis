-- ============================================================
--  RETAIL E-COMMERCE ANALYSIS PROJECT
--  MySQL 8.0 Compatible Version
--  Skills: JOINs, CTEs, Window Functions, Aggregations,
--          Subqueries, CASE, Date Logic, Deduplication
-- ============================================================

-- Run this first!
CREATE DATABASE IF NOT EXISTS retail_analysis;
USE retail_analysis;


-- ============================================================
--  SCHEMA SETUP
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id     INT PRIMARY KEY,
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    email           VARCHAR(100),
    state           VARCHAR(2),
    signup_date     DATE,
    loyalty_tier    VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS products (
    product_id      INT PRIMARY KEY,
    product_name    VARCHAR(100),
    category        VARCHAR(50),
    brand           VARCHAR(50),
    unit_price      DECIMAL(10,2),
    cost_price      DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id        INT PRIMARY KEY,
    customer_id     INT,
    order_date      DATE,
    status          VARCHAR(20),
    shipping_state  VARCHAR(2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE IF NOT EXISTS order_items (
    item_id         INT PRIMARY KEY,
    order_id        INT,
    product_id      INT,
    quantity        INT,
    unit_price      DECIMAL(10,2),
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- ============================================================
--  SAMPLE DATA
-- ============================================================

INSERT INTO customers VALUES
(1,  'Maya',    'Patel',    'maya@email.com',    'IL', '2022-01-15', 'Gold'),
(2,  'James',   'Carter',   'james@email.com',   'TX', '2022-03-08', 'Silver'),
(3,  'Sofia',   'Reyes',    'sofia@email.com',   'CA', '2022-05-22', 'Bronze'),
(4,  'Derek',   'Kim',      'derek@email.com',   'NY', '2023-01-10', 'Silver'),
(5,  'Aisha',   'Moore',    'aisha@email.com',   'FL', '2023-03-30', 'Bronze'),
(6,  'Liam',    'Brooks',   'liam@email.com',    'IL', '2021-11-01', 'Gold'),
(7,  'Priya',   'Singh',    'priya@email.com',   'CA', '2023-07-18', 'Bronze'),
(8,  'Marcus',  'Davis',    'marcus@email.com',  'TX', '2022-09-05', 'Silver'),
(9,  'Elena',   'Torres',   'elena@email.com',   'WA', '2021-06-20', 'Gold'),
(10, 'Noah',    'White',    'noah@email.com',    'NY', '2023-10-01', 'Bronze');

INSERT INTO products VALUES
(1,  'Wireless Earbuds Pro',   'Electronics',  'SoundWave',  89.99,  32.00),
(2,  'USB-C Hub 7-Port',       'Electronics',  'TechCore',   49.99,  15.00),
(3,  'Yoga Mat Premium',       'Fitness',      'FlexFit',    44.99,  12.00),
(4,  'Stainless Water Bottle', 'Fitness',      'HydroLife',  29.99,   7.00),
(5,  'Scented Candle Set',     'Home',         'GlowHome',   34.99,   9.00),
(6,  'Mechanical Keyboard',    'Electronics',  'TechCore',  119.99,  48.00),
(7,  'Resistance Bands Set',   'Fitness',      'FlexFit',    19.99,   5.00),
(8,  'Bamboo Cutting Board',   'Home',         'KitchenCo',  24.99,   8.00),
(9,  'Blue Light Glasses',     'Accessories',  'VisionX',    39.99,  11.00),
(10, 'Portable Charger 20K',   'Electronics',  'SoundWave',  59.99,  22.00);

INSERT INTO orders VALUES
(101, 1,  '2024-01-05', 'Completed', 'IL'),
(102, 2,  '2024-01-12', 'Completed', 'TX'),
(103, 3,  '2024-01-20', 'Returned',  'CA'),
(104, 4,  '2024-02-03', 'Completed', 'NY'),
(105, 5,  '2024-02-14', 'Completed', 'FL'),
(106, 1,  '2024-02-28', 'Completed', 'IL'),
(107, 6,  '2024-03-07', 'Completed', 'IL'),
(108, 7,  '2024-03-15', 'Pending',   'CA'),
(109, 8,  '2024-03-22', 'Completed', 'TX'),
(110, 9,  '2024-04-01', 'Completed', 'WA'),
(111, 10, '2024-04-10', 'Completed', 'NY'),
(112, 2,  '2024-04-18', 'Completed', 'TX'),
(113, 3,  '2024-05-02', 'Completed', 'CA'),
(114, 6,  '2024-05-20', 'Returned',  'IL'),
(115, 9,  '2024-06-01', 'Completed', 'WA');

INSERT INTO order_items VALUES
(1,  101, 1,  1, 89.99),
(2,  101, 9,  2, 39.99),
(3,  102, 6,  1, 119.99),
(4,  103, 3,  1, 44.99),
(5,  104, 2,  1, 49.99),
(6,  104, 10, 1, 59.99),
(7,  105, 4,  3, 29.99),
(8,  105, 7,  2, 19.99),
(9,  106, 1,  1, 89.99),
(10, 106, 5,  2, 34.99),
(11, 107, 6,  1, 119.99),
(12, 107, 2,  2, 49.99),
(13, 108, 3,  1, 44.99),
(14, 109, 9,  1, 39.99),
(15, 109, 4,  2, 29.99),
(16, 110, 1,  2, 89.99),
(17, 110, 10, 1, 59.99),
(18, 111, 8,  1, 24.99),
(19, 112, 5,  3, 34.99),
(20, 113, 7,  4, 19.99),
(21, 114, 6,  1, 119.99),
(22, 115, 1,  1, 89.99),
(23, 115, 2,  1, 49.99);


-- ============================================================
--  QUERY 1: Total Revenue by Category
--  Skills: JOIN, GROUP BY, SUM, COUNT, ORDER BY
-- ============================================================

SELECT
    p.category,
    COUNT(DISTINCT o.order_id)                 AS total_orders,
    SUM(oi.quantity * oi.unit_price)           AS total_revenue,
    ROUND(AVG(oi.quantity * oi.unit_price), 2) AS avg_item_revenue
FROM order_items oi
JOIN orders o   ON oi.order_id   = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY total_revenue DESC;


-- ============================================================
--  QUERY 2: Top 5 Best-Selling Products by Units Sold
--  Skills: JOIN, GROUP BY, ORDER BY, LIMIT
-- ============================================================

SELECT
    p.product_name,
    p.category,
    p.brand,
    SUM(oi.quantity)                  AS units_sold,
    SUM(oi.quantity * oi.unit_price)  AS total_revenue
FROM order_items oi
JOIN orders o   ON oi.order_id   = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name, p.category, p.brand
ORDER BY units_sold DESC
LIMIT 5;


-- ============================================================
--  QUERY 3: Customer Lifetime Value with Ranking
--  Skills: CTE, JOIN, RANK(), CASE, GROUP BY
-- ============================================================

WITH customer_spend AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.loyalty_tier,
        c.state,
        COUNT(DISTINCT o.order_id)              AS total_orders,
        SUM(oi.quantity * oi.unit_price)        AS lifetime_value
    FROM customers c
    JOIN orders o       ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id    = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, c.first_name, c.last_name, c.loyalty_tier, c.state
)
SELECT
    customer_name,
    loyalty_tier,
    state,
    total_orders,
    lifetime_value,
    RANK() OVER (ORDER BY lifetime_value DESC) AS clv_rank,
    CASE
        WHEN lifetime_value >= 300 THEN 'High Value'
        WHEN lifetime_value >= 150 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS value_segment
FROM customer_spend
ORDER BY clv_rank;


-- ============================================================
--  QUERY 4: Month-over-Month Revenue Growth
--  Skills: CTE, DATE_FORMAT, LAG(), NULLIF, ROUND
-- ============================================================

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS month,
        SUM(oi.quantity * oi.unit_price)       AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
)
SELECT
    DATE_FORMAT(month, '%Y-%m')                          AS month,
    revenue,
    LAG(revenue) OVER (ORDER BY month)                   AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100
    , 1)                                                 AS mom_growth_pct
FROM monthly_revenue
ORDER BY month;


-- ============================================================
--  QUERY 5: Repeat vs One-Time Buyers
--  Skills: Subquery, CASE, GROUP BY, SUM() OVER()
-- ============================================================

SELECT
    buyer_type,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_customers
FROM (
    SELECT
        c.customer_id,
        CASE
            WHEN COUNT(DISTINCT o.order_id) = 1 THEN 'One-Time Buyer'
            ELSE 'Repeat Buyer'
        END AS buyer_type
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id
) buyer_segments
GROUP BY buyer_type;


-- ============================================================
--  QUERY 6: Product Profit Margin Analysis
--  Skills: Computed columns, ROUND, CASE
-- ============================================================

SELECT
    p.product_name,
    p.category,
    p.unit_price,
    p.cost_price,
    ROUND(p.unit_price - p.cost_price, 2)             AS gross_profit,
    ROUND((p.unit_price - p.cost_price)
          / p.unit_price * 100, 1)                    AS margin_pct,
    CASE
        WHEN (p.unit_price - p.cost_price) / p.unit_price >= 0.60 THEN 'High Margin'
        WHEN (p.unit_price - p.cost_price) / p.unit_price >= 0.40 THEN 'Mid Margin'
        ELSE 'Low Margin'
    END AS margin_tier
FROM products p
ORDER BY margin_pct DESC;


-- ============================================================
--  QUERY 7: Customers Who Haven't Ordered in 90+ Days
--  Skills: JOIN, DATEDIFF, HAVING, MAX()
-- ============================================================

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.loyalty_tier,
    MAX(o.order_date)                       AS last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date))  AS days_since_last_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.loyalty_tier
HAVING DATEDIFF(CURDATE(), MAX(o.order_date)) >= 90
ORDER BY days_since_last_order DESC;


-- ============================================================
--  QUERY 8: Running Total Revenue by Month
--  Skills: CTE, DATE_FORMAT, SUM() OVER()
-- ============================================================

WITH monthly AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS month,
        SUM(oi.quantity * oi.unit_price)       AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
)
SELECT
    DATE_FORMAT(month, '%Y-%m')                        AS month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY month)         AS running_total
FROM monthly
ORDER BY month;


-- ============================================================
--  QUERY 9: Return Rate by Product Category
--  Skills: JOIN, CASE inside aggregation, ROUND
-- ============================================================

SELECT
    p.category,
    COUNT(DISTINCT o.order_id)                              AS total_orders,
    COUNT(DISTINCT CASE WHEN o.status = 'Returned'
                        THEN o.order_id END)                AS returned_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN o.status = 'Returned'
                            THEN o.order_id END)
        * 100.0 / COUNT(DISTINCT o.order_id), 1
    )                                                       AS return_rate_pct
FROM orders o
JOIN order_items oi ON o.order_id    = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY return_rate_pct DESC;


-- ============================================================
--  QUERY 10: Revenue Share by Loyalty Tier
--  Skills: Multi-CTE, CROSS JOIN, RANK(), Revenue share %
-- ============================================================

WITH tier_revenue AS (
    SELECT
        c.loyalty_tier,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM customers c
    JOIN orders o       ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id    = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY c.loyalty_tier
),
totals AS (
    SELECT SUM(revenue) AS grand_total FROM tier_revenue
)
SELECT
    t.loyalty_tier,
    t.revenue,
    ROUND(t.revenue / tt.grand_total * 100, 1) AS revenue_share_pct,
    RANK() OVER (ORDER BY t.revenue DESC)       AS tier_rank
FROM tier_revenue t
CROSS JOIN totals tt
ORDER BY tier_rank;

