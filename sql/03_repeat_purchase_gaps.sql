USE ecommerce_clickstream;

# Repeat purchase behavior:
# For each customer, calculate the number of days until their next order.
# Demonstrates window functions (LEAD) + lifecycle analysis.

WITH ordered AS (
  SELECT
    customer_id,
    order_id,
    order_time,
    LEAD(order_time) OVER (
      PARTITION BY customer_id
      ORDER BY order_time, order_id
    ) AS next_order_time
  FROM orders
)
SELECT
  customer_id,
  order_id,
  order_time,
  next_order_time,
  TIMESTAMPDIFF(DAY, order_time, next_order_time) AS days_until_next_order
FROM ordered
ORDER BY customer_id, order_time;
