USE ecommerce_clickstream;

# Top 25 products by revenue
# Demonstrates joins + grouping + profitability metric

SELECT
  p.product_id,
  p.name,
  p.category,
  SUM(oi.quantity) AS units_sold,
  SUM(oi.line_total_usd) AS revenue_usd,
  SUM(oi.quantity * p.margin_usd) AS gross_margin_usd
FROM order_items oi
JOIN products p
  ON p.product_id = oi.product_id
GROUP BY
  p.product_id,
  p.name,
  p.category
ORDER BY revenue_usd DESC
LIMIT 25;
