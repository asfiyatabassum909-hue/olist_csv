/*
Question 5: What payment methods and installment patterns are most common, and do they correlate with review scores?
Aggregated payment data with CASE WHEN and joins to correlate payment method/installments with review scores
*/

SELECT 
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(AVG(payment_installments),2) AS avg_payments,
    ROUND(AVG(order_reviews.review_score), 2) AS avg_score
FROM order_payments
INNER JOIN order_reviews ON order_payments.order_id = order_reviews.order_id
GROUP BY payment_type
ORDER BY payment_count DESC

/*
OUTPUT:
[
  {
    "payment_type": "credit_card",
    "payment_count": "76600",
    "avg_payments": "3.51",
    "avg_score": "4.09"
  },
  {
    "payment_type": "boleto",
    "payment_count": "19762",
    "avg_payments": "1.00",
    "avg_score": "4.09"
  },
  {
    "payment_type": "voucher",
    "payment_count": "5783",
    "avg_payments": "1.00",
    "avg_score": "4.00"
  },
  {
    "payment_type": "debit_card",
    "payment_count": "1529",
    "avg_payments": "1.00",
    "avg_score": "4.17"
  },
  {
    "payment_type": "not_defined",
    "payment_count": "3",
    "avg_payments": "1.00",
    "avg_score": "1.67"
  }
]
*/