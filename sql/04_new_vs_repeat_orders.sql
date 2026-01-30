USE ecommerce_clickstream;

# New vs repeat customer orders by day
# Demonstrates window functions + conditional aggregation

WITH flagged AS (
  SELECT
    order_id,
    customer_id,
    DATE(order_time) AS order_date,
    total_usd,

    CASE
      WHEN DENSE_RANK() OVER (
        PARTITION BY customer_id
        ORDER BY order_time
      ) = 1 THEN 1
      ELSE 0
    END AS is_new_customer_order

  FROM orders
)

SELECT
  order_date,
  COUNT(*) AS total_orders,
  SUM(total_usd) AS total_revenue_usd,

  SUM(is_new_customer_order) AS new_customer_orders,
  COUNT(*) - SUM(is_new_customer_order) AS repeat_customer_orders,

  1.0 * SUM(is_new_customer_order) / NULLIF(COUNT(*), 0)
    AS pct_orders_from_new_customers

FROM flagged
GROUP BY order_date
ORDER BY order_date;
