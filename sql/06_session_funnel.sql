USE ecommerce_clickstream;

WITH session_flags AS (
  SELECT
    session_id,
    DATE(MIN(event_time)) AS session_date,
    MAX(CASE WHEN event_type = 'page_view'   THEN 1 ELSE 0 END) AS has_page_view,
    MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS has_add_to_cart,
    MAX(CASE WHEN event_type = 'checkout'    THEN 1 ELSE 0 END) AS has_checkout,
    MAX(CASE WHEN event_type = 'purchase'    THEN 1 ELSE 0 END) AS has_purchase
  FROM events
  GROUP BY session_id
)
SELECT
  session_date,
  COUNT(*) AS total_sessions,
  SUM(has_page_view) AS page_view_sessions,
  SUM(has_add_to_cart) AS add_to_cart_sessions,
  SUM(has_checkout) AS checkout_sessions,
  SUM(has_purchase) AS purchase_sessions,
  1.0 * SUM(has_purchase) / NULLIF(SUM(has_page_view), 0) AS overall_conversion_rate
FROM session_flags
GROUP BY session_date
ORDER BY session_date;