USE ecommerce_clickstream;

WITH session_cart AS (
  SELECT
    e.session_id,
    MAX(COALESCE(e.cart_size, 0)) AS cart_size
  FROM events e
  GROUP BY e.session_id
),
session_revenue AS (
  SELECT
    e.session_id,
    MAX(CASE WHEN e.event_type = 'purchase' THEN 1 ELSE 0 END) AS has_purchase,
    SUM(CASE WHEN e.event_type = 'purchase' THEN COALESCE(e.amount_usd, 0) ELSE 0 END) AS revenue_usd
  FROM events e
  GROUP BY e.session_id
)

SELECT
  CASE
    WHEN sc.cart_size IS NULL OR sc.cart_size = 0 THEN 'No cart'
    WHEN sc.cart_size = 1 THEN '1 item'
    WHEN sc.cart_size BETWEEN 2 AND 3 THEN '2–3 items'
    WHEN sc.cart_size BETWEEN 4 AND 5 THEN '4–5 items'
    ELSE '6+ items'
  END AS cart_bucket,

  COUNT(*) AS sessions,
  SUM(sr.has_purchase) AS purchase_sessions,
  ROUND(1.0 * SUM(sr.has_purchase) / NULLIF(COUNT(*), 0), 5) AS conversion_rate,

  ROUND(SUM(sr.revenue_usd), 2) AS total_revenue_usd,
  ROUND(SUM(sr.revenue_usd) / NULLIF(COUNT(*), 0), 6) AS revenue_per_session

FROM session_cart sc
JOIN session_revenue sr
  ON sr.session_id = sc.session_id
GROUP BY cart_bucket
ORDER BY
  CASE cart_bucket
    WHEN 'No cart' THEN 0
    WHEN '1 item' THEN 1
    WHEN '2–3 items' THEN 2
    WHEN '4–5 items' THEN 3
    WHEN '6+ items' THEN 4
    ELSE 9
  END;
