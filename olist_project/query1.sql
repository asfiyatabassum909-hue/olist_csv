/*
Question: What is the monthly revenue trend, including running total and month-over-month growth?
Used CTEs to aggregate monthly revenue, then LAG() to calculate month-over-month growth %
*/

WITH monthly_revenue AS (
    SELECT
        TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month,
        SUM(oi.price) AS total_revenue
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')
)
SELECT
    month,
    total_revenue,
    SUM(total_revenue) OVER (ORDER BY month) AS running_total,
    LAG(total_revenue) OVER (ORDER BY month) AS previous_month_revenue,
ROUND(
    (total_revenue - LAG(total_revenue) OVER (ORDER BY month)) 
    / LAG(total_revenue) OVER (ORDER BY month) * 100
, 2) AS growth_pct
FROM monthly_revenue
ORDER BY month
