USE ecommerce_clickstream;


SELECT
  s.country,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(o.total_usd), 2) AS total_revenue_usd,
  ROUND(AVG(o.total_usd), 2) AS avg_order_value_usd
FROM orders o
JOIN sessions s
  ON s.customer_id = o.customer_id
WHERE s.country IS NOT NULL AND s.country <> ''
GROUP BY s.country
HAVING COUNT(DISTINCT o.order_id) >= 500
ORDER BY total_revenue_usd DESC;