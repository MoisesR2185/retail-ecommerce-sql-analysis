# Retail E-Commerce SQL Analysis

A SQL project analyzing consumer purchase behavior across a simulated retail dataset — built to demonstrate intermediate-to-advanced MySQL skills and real-world business thinking.

---

## Project Overview

This project explores a fictional retail company's sales data to answer the kinds of questions a data or business analyst would face on the job: Who are our most valuable customers? Which products drive the most revenue? Are we growing month over month? Where are we losing customers?

The dataset consists of 4 related tables — customers, orders, order items, and products — with 10 analytical queries written in MySQL 8.0.

---

## Business Questions Answered

| # | Business Question | SQL Concepts Used |
|---|---|---|
| 1 | Which product categories drive the most revenue? | JOIN, GROUP BY, SUM, COUNT |
| 2 | What are our top 5 best-selling products? | JOIN, GROUP BY, ORDER BY, LIMIT |
| 3 | Who are our highest lifetime value customers? | CTE, RANK(), CASE, JOIN |
| 4 | Are we growing month over month? | CTE, DATE_FORMAT, LAG(), NULLIF |
| 5 | How many customers come back vs buy once? | Subquery, CASE, SUM() OVER() |
| 6 | Which products have the healthiest profit margins? | Computed columns, CASE, ROUND |
| 7 | Which customers are at risk of churning? | JOIN, DATEDIFF, HAVING, MAX |
| 8 | What does our cumulative revenue look like over time? | CTE, DATE_FORMAT, SUM() OVER() |
| 9 | Which categories have the highest return rates? | JOIN, CASE inside aggregation |
| 10 | Which loyalty tier drives the most revenue? | Multi-CTE, CROSS JOIN, RANK() |

---

## Database Schema

```
customers         orders              order_items        products
-----------       -----------         -----------        -----------
customer_id PK    order_id PK         item_id PK         product_id PK
first_name        customer_id FK      order_id FK        product_name
last_name         order_date          product_id FK      category
email             status              quantity           brand
state             shipping_state      unit_price         unit_price
signup_date                                              cost_price
loyalty_tier
```

---

## Key Business Insights

**Electronics dominate revenue but carry return risk**
Electronics is the highest revenue category but also shows the highest return rate. This suggests a potential product quality or expectation mismatch worth investigating — especially for a company focused on customer satisfaction scores.

**Gold tier customers punch above their weight**
Gold loyalty members represent a small share of total customers but contribute a disproportionate share of total revenue. Retention efforts and personalized offers should be prioritized for this segment before any expansion spend.

**Most customers only buy once**
The repeat vs one-time buyer analysis shows the majority of customers do not return after their first purchase. This points to a significant retention opportunity — even a small improvement in repeat purchase rate would have a material impact on revenue.

**Revenue growth is uneven month over month**
Month-over-month revenue shows inconsistency, with some months declining from the prior period. This warrants deeper investigation into whether dips correlate with seasonality, marketing spend, or product availability.

**A large portion of customers are lapsed**
The churn risk query identifies customers who haven't purchased in 90+ days. For a company like Numerator that tracks household purchase behavior, identifying and re-engaging lapsed buyers is a core use case.

---

## SQL Skills Demonstrated

- **CTEs** — single and chained multi-step CTEs for readable, modular queries
- **Window functions** — RANK(), LAG(), SUM() OVER() for ranking and time-series analysis
- **Multi-table JOINs** — combining up to 3 tables with INNER and LEFT JOINs
- **Conditional aggregation** — CASE statements inside COUNT and SUM
- **Date logic** — DATE_FORMAT, DATEDIFF, CURDATE() for time-based analysis
- **Subqueries** — nested SELECT for segmentation logic
- **Business metrics** — CLV, MoM growth, return rate, revenue share, profit margin

---

## How to Run

1. Open MySQL Workbench and connect to your local server
2. Open `retail_analysis_mysql.sql`
3. Click the ⚡ lightning bolt to run the full script
4. The script will create the database, tables, insert data, and execute all 10 queries

**Requirements:** MySQL 8.0 or higher (CTEs and window functions require 8.0+)

---

## About This Project

Built as a portfolio project to demonstrate SQL proficiency at the intermediate-to-advanced level, with a focus on the types of consumer purchase analysis used at data-driven retail and market research companies.
