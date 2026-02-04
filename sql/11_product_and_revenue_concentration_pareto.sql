USE ecommerce_clickstream;

WITH product_rev AS (
  SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.line_total_usd) AS revenue_usd
  FROM order_items oi
  JOIN products p
    ON p.product_id = oi.product_id
  GROUP BY p.product_id, p.product_name, p.category
),
tot AS (
  SELECT SUM(revenue_usd) AS total_revenue_usd
  FROM product_rev
),
ranked AS (
  SELECT
    pr.*,
    ROW_NUMBER() OVER (ORDER BY pr.revenue_usd DESC) AS revenue_rank,
    pr.revenue_usd / NULLIF(t.total_revenue_usd, 0) AS share_of_total,
    SUM(pr.revenue_usd) OVER (ORDER BY pr.revenue_usd DESC) / NULLIF(t.total_revenue_usd, 0) AS cumulative_share
  FROM product_rev pr
  CROSS JOIN tot t
)

SELECT
  revenue_rank,
  product_id,
  product_name,
  category,
  ROUND(revenue_usd, 2) AS revenue_usd,
  ROUND(share_of_total, 6) AS share_of_total,
  ROUND(cumulative_share, 6) AS cumulative_share
FROM ranked
ORDER BY revenue_rank;