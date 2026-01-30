USE ecommerce_clickstream;

# Cohort retention table:
# cohort_month = customer's first order month
# months_since_cohort = month offset from cohort start (Month 0 = first month)
# retention_rate = active_customers / cohort_size

WITH cohorts AS (
  SELECT
    customer_id,
    DATE_FORMAT(MIN(order_time), '%Y-%m-01') AS cohort_month
  FROM orders
  GROUP BY customer_id
),

activity AS (
  SELECT
    c.cohort_month,

    TIMESTAMPDIFF(
      MONTH,
      STR_TO_DATE(c.cohort_month, '%Y-%m-%d'),
      STR_TO_DATE(DATE_FORMAT(o.order_time, '%Y-%m-01'), '%Y-%m-%d')
    ) AS months_since_cohort,

    COUNT(DISTINCT o.customer_id) AS active_customers

  FROM orders o
  JOIN cohorts c
    ON c.customer_id = o.customer_id
  GROUP BY c.cohort_month, months_since_cohort
),

cohort_sizes AS (
  SELECT
    cohort_month,
    COUNT(*) AS cohort_size
  FROM cohorts
  GROUP BY cohort_month
)

SELECT
  a.cohort_month,
  a.months_since_cohort,
  a.active_customers,
  s.cohort_size,
  1.0 * a.active_customers / NULLIF(s.cohort_size, 0) AS retention_rate
FROM activity a
JOIN cohort_sizes s
  ON s.cohort_month = a.cohort_month
ORDER BY a.cohort_month, a.months_since_cohort;
