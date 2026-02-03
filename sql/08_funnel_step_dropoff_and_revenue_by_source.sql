USE ecommerce_clickstream;

# Funnel step conversion and revenue per session by traffic source
# Combines behavioral drop-off analysis with monetization impact

WITH session_flags AS (
  SELECT
    e.session_id,

    MAX(CASE WHEN e.event_type = 'page_view'   THEN 1 ELSE 0 END) AS viewed,
    MAX(CASE WHEN e.event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS carted,
    MAX(CASE WHEN e.event_type = 'checkout'    THEN 1 ELSE 0 END) AS checked_out,
    MAX(CASE WHEN e.event_type = 'purchase'    THEN 1 ELSE 0 END) AS purchased

  FROM events e
  GROUP BY e.session_id
),

session_revenue AS (
  SELECT
    session_id,
    SUM(amount_usd) AS revenue_usd
  FROM events
  WHERE event_type = 'purchase'
  GROUP BY session_id
)

SELECT
  s.source,
  COUNT(*) AS total_sessions,

  -- Funnel step conversion rates
  1.0 * SUM(carted) / NULLIF(SUM(viewed), 0) AS view_to_cart_rate,
  1.0 * SUM(checked_out) / NULLIF(SUM(carted), 0) AS cart_to_checkout_rate,
  1.0 * SUM(purchased) / NULLIF(SUM(checked_out), 0) AS checkout_to_purchase_rate,

  -- Overall purchase conversion
  1.0 * SUM(purchased) / NULLIF(COUNT(*), 0) AS overall_conversion_rate,

  -- Revenue metrics
  COALESCE(SUM(r.revenue_usd), 0) AS total_revenue_usd,
  COALESCE(SUM(r.revenue_usd), 0) / COUNT(*) AS revenue_per_session

FROM session_flags f
JOIN sessions s
  ON s.session_id = f.session_id
LEFT JOIN session_revenue r
  ON r.session_id = f.session_id

GROUP BY s.source
ORDER BY revenue_per_session DESC;