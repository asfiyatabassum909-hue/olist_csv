/* 
Question 4: How does delivery speed affect customer satisfaction - comparing Fast/Normal/Slow delivery buckets?
Built a CTE with date subtraction and CASE WHEN to bucket delivery speed, then compared against review scores
*/

WITH delivery_days AS (
    SELECT 
        o.order_delivered_customer_date::date - o.order_purchase_timestamp::date AS total_days,
        ors.review_score
    FROM
        orders o
    INNER JOIN order_reviews ors ON o.order_id = ors.order_id
    WHERE order_status = 'delivered'
        AND order_delivered_customer_date IS NOT NULL
        AND order_purchase_timestamp IS NOT NULL
),
delivery_buckets AS (
SELECT
    total_days, 
    review_score,
    CASE
        WHEN total_days <= 7 THEN 'Fast'
        WHEN total_days <=14 THEN 'Normal'
        ELSE 'Slow'
    END AS delivery_speed
FROM delivery_days
)

SELECT 
    delivery_speed,
    COUNT(*) AS total_orders,
    ROUND(AVG(total_days),2) AS avg_delivery_days,
    ROUND(AVG(review_score),2) AS avg_review_score
FROM delivery_buckets
GROUP BY delivery_speed
ORDER BY avg_delivery_days

/*
OUTPUT:
[
  {
    "delivery_speed": "Fast",
    "total_orders": "30679",
    "avg_delivery_days": "4.96",
    "avg_review_score": "4.41"
  },
  {
    "delivery_speed": "Normal",
    "total_orders": "37985",
    "avg_delivery_days": "10.65",
    "avg_review_score": "4.30"
  },
  {
    "delivery_speed": "Slow",
    "total_orders": "27689",
    "avg_delivery_days": "23.26",
    "avg_review_score": "3.68"
  }
]
*/