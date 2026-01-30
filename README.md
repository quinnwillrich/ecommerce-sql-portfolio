# Ecommerce SQL Portfolio Project

This project analyzes an ecommerce transactions dataset using **MySQL**.

Dataset: *Ecommerce Transactions and Clickstream* (Kaggle)

## Goals
Demonstrate core analytics SQL skills including:

- Multi-table joins
- Aggregations and grouping
- Window functions (LEAD, DENSE_RANK)
- Customer lifecycle metrics
- Cohort retention analysis

---

## Schema Overview

Main tables used:

- `orders` — customer purchases with timestamps and revenue
- `order_items` — product-level line items per order
- `products` — product metadata including category and margin

---

## Key Analyses

### 1. Revenue by Product Category
**File:** `sql/01_revenue_by_category.sql`

Calculates total revenue and units sold by category.

---

### 2. Top Products by Revenue + Margin
**File:** `sql/02_top_products_by_revenue.sql`

Identifies best-performing products and gross margin contribution.

---

### 3. Repeat Purchase Behavior
**File:** `sql/03_repeat_purchase_gaps.sql`

Uses `LEAD()` to measure days between customer purchases.

---

### 4. New vs Repeat Customer Orders
**File:** `sql/04_new_vs_repeat_orders.sql`

Tracks the share of orders coming from first-time vs returning customers.

---

### 5. Cohort Retention Table
**File:** `sql/05_cohort_retention.sql`

Builds a Month 0 / Month 1 / Month 2 retention matrix using cohort analysis.

---

## Next Steps
Future improvements:

- Add clickstream funnel analysis using sessions + events
- Visualize retention curves in Python/Tableau
- Package results into a dashboard
