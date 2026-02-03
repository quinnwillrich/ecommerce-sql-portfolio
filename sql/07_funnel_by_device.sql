USE ecommerce_clickstream;

# Funnel conversion breakdown by device
# Shows where conversion differs across device types

WITH session_flags AS (
  SELECT
    e.session_id,
    MAX(CASE WHEN e.event_type = 'page_view'   THEN 1 ELSE 0 END) AS viewed,
    MAX(CASE WHEN e.event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS carted,
    MAX(CASE WHEN e.event_type = 'checkout'    THEN 1 ELSE 0 END) AS checked_out,
    MAX(CASE WHEN e.event_type = 'purchase'    THEN 1 ELSE 0 END) AS purchased
  FROM events e
  GROUP BY e.session_id
)
SELECT
  s.device,
  COUNT(*) AS total_sessions,
  SUM(viewed) AS page_view_sessions,
  SUM(carted) AS add_to_cart_sessions,
  SUM(checked_out) AS checkout_sessions,
  SUM(purchased) AS purchase_sessions,

  1.0 * SUM(carted) / NULLIF(SUM(viewed), 0) AS view_to_cart_rate,
  1.0 * SUM(checked_out) / NULLIF(SUM(carted), 0) AS cart_to_checkout_rate,
  1.0 * SUM(purchased) / NULLIF(SUM(checked_out), 0) AS checkout_to_purchase_rate,
  1.0 * SUM(purchased) / NULLIF(COUNT(*), 0) AS overall_conversion_rate
FROM session_flags f
JOIN sessions s
  ON s.session_id = f.session_id
GROUP BY s.device
ORDER BY overall_conversion_rate DESC;