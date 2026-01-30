USE ecommerce_clickstream;

# Revenue and units sold by product category
# Demonstrates joins + aggregation

SELECT
  p.category,
  COUNT(DISTINCT oi.order_id) AS total_orders,
  SUM(oi.quantity) AS total_units_sold,
  SUM(oi.line_total_usd) AS total_revenue_usd
FROM order_items oi
JOIN products p
  ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue_usd DESC;
