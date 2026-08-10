# Brazilian E-Commerce Analysis (Olist) | SQL + Power BI
## Project Overview
This project analyzes the Brazilian Olist e-commerce dataset using PostgreSQL and Power BI. The goal was to explore sales performance, customer behaviour, product-category performance, delivery experience, and payment preferences.

I used SQL to clean, join, aggregate, and analyze the data, then built interactive Power BI dashboards to present the key findings in a clear, business-focused format.

## Background
The dataset contains real, anonymized order data from Olist, spanning 11 linked tables covering orders, order items, payments, reviews, products, customers, sellers, and geolocation. 

The questions I wanted to answer through my SQL queries were:

1. What is the monthly revenue trend, including running total and month-over-month growth?
2. Which product categories generate the most revenue, and how do they compare on review scores?
3. Who are the top 5 spending customers per state, and which states drive the most revenue?
4. How does delivery speed (Fast/Normal/Slow) relate to customer satisfaction?
5. What are the most common payment methods and installment patterns, and how do they correlate with review scores?

## Tools I Used
For my deep dive into the Olist e-commerce dataset, I harnessed the power of several key tools:

- **PostgreSQL:** The chosen database management system, ideal for handling the e-commerce dataset across 11 linked tables.
- **Power BI:** Used to build an interactive 2-page dashboard (Revenue & Customers, Delivery & Payments) connected directly to PostgreSQL via custom SQL queries.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis.

## The Analysis
Each query for this project aimed at investigating specific aspects of the e-commerce business. Here's how I approached each question:

### 1. Monthly Revenue Trend
To understand how revenue moved over time, I aggregated total order value by month and used a CTE to build a running total alongside it. I then applied the LAG() window function to calculate month-over-month growth percentage, making it easy to spot which months saw acceleration or decline in sales.

```
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
```
### OUTPUT

<img width="1000" height="500" alt="image" src="https://github.com/user-attachments/assets/f413bf85-057b-4d50-b8b2-a0b0bea31a3f" />

**Insights:** 
- Revenue grew from approximately 120K in January 2017 to a peak of 1.01M in November 2017.
- Monthly revenue remained comparatively strong throughout 2018, generally ranging from about 845K to 997K between February and August.
- Total cumulative revenue reached 13.59M over the dataset period.
- The extremely large growth rates at the beginning and end of the dataset are caused by partial or very low-volume months, so they should not be treated as normal business performance.

### 2. Top Revenue Categories & Review Scores
Joined the orders, order_items, and products tables to calculate total revenue per product category, then brought in average review scores for each category from order_reviews. The goal was to see whether the categories bringing in the most money were also the ones customers were happiest with — or whether high revenue and high satisfaction didn't necessarily go together.

```
SELECT 
    pc.product_category_name_english,
    SUM(o.price) AS total,
    AVG(ors.review_score) AS review_score
FROM
    order_items o
INNER JOIN products p ON o.product_id = p.product_id
INNER JOIN product_category_name_translation pc ON p.product_category_name = pc.product_category_name
INNER JOIN order_reviews ors ON o.order_id = ors.order_id

GROUP BY pc.product_category_name_english
ORDER BY total DESC
```
### OUTPUT
<img width="1000" height="560" alt="image" src="https://github.com/user-attachments/assets/66948f1d-3014-4307-a4a7-4151fbf62164" />

**Insights:**
- Health & Beauty was the highest-revenue category, generating approximately 1.25M, followed closely by Watches & Gifts at 1.20M.
- The three leading categories—Health & Beauty, Watches & Gifts, and Bed Bath & Table—generated approximately 3.49M combined, around 26% of total revenue.
- High revenue did not always correspond to the highest customer satisfaction. For example, Bed Bath & Table generated 1.04M in revenue but had an average review score of 3.90, while Cool Stuff had a higher score of 4.15 with 630K in revenue.
- Most of the ten highest-revenue categories maintained average review scores close to or above 4 out of 5.

### 3. Top 5 Spending Customers Per State
Joined the customers and orders/order_items tables to calculate total spend per customer, then used RANK() PARTITION BY state to identify the top 5 highest-spending customers within each state. The goal was to see which states generate the most revenue and whether that revenue comes from a broad customer base or is concentrated among a handful of big spenders.

```
WITH total_spend AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        SUM(oi.price) AS total_amt,
        RANK() OVER (PARTITION BY c.customer_state ORDER BY SUM(oi.price) DESC) AS customer_rank
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.customer_id
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id, c.customer_state
)
SELECT *
FROM total_spend
WHERE customer_rank <= 5
ORDER BY customer_state, customer_rank
```
### OUTPUT
<img width="1000" height="560" alt="image" src="https://github.com/user-attachments/assets/8afaa2c0-0728-420b-a89f-94d46d55eef3" />

**Insights:**
- São Paulo (SP) generated the most revenue at approximately 5.07M, far ahead of every other state.
- Rio de Janeiro (RJ) and Minas Gerais (MG) followed with approximately 1.76M and 1.55M in revenue, respectively.
- Together, SP, RJ, and MG generated approximately 8.38M, representing about 62% of total revenue.
- The highest-spending individual customer was from RJ, with total spending of 13.44K.

### 4. Delivery Speed vs Customer Satisfaction
Built a CTE that calculated the gap between estimated and actual delivery dates, then used CASE WHEN to bucket each order into Fast, Normal, or Slow delivery. Compared average review scores across the three buckets to test whether delayed deliveries were actually linked to lower customer satisfaction.

```
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
```

### OUTPUT
| Delivery Speed | Total Orders | Average Delivery Days | Average Review Score |
|----------------|--------------|-----------------------|----------------------|
| Fast            | 30,679        | 4.96                       | 4.41                       |
| Normal          | 37,985        | 10.65                      | 4.30                       |
| Slow            | 27,689        | 23.26                      | 3.68                       |

**Insights:**
- Fast deliveries received the highest average review score of 4.41 out of 5, while slow deliveries received the lowest score of 3.68.
- Slow delivery orders took an average of 23.26 days, compared with 4.96 days for fast deliveries.
- The 0.73-point gap between Fast and Slow delivery reviews suggests a strong relationship between delivery experience and customer satisfaction.
- Normal deliveries represented the largest delivery group, with 37,985 orders and an average delivery time of 10.65 days.

### 5. Payment Methods & Review Score Correlation
Aggregated orders by payment method and installment count, then joined in review scores to see whether how customers paid — single payment vs. installments, credit card vs. other methods — was related to satisfaction.

```
SELECT 
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(AVG(payment_installments),2) AS avg_payments,
    ROUND(AVG(order_reviews.review_score), 2) AS avg_score
FROM order_payments
INNER JOIN order_reviews ON order_payments.order_id = order_reviews.order_id
GROUP BY payment_type
ORDER BY payment_count DESC
```
### OUTPUT
| Payment Type | Payment Count | Avg Installments | Avg Review Score |
|----------------|-----------------|----------------------|----------------------|
| credit_card    | 76,600          | 3.51                  | 4.09                  |
| boleto         | 19,762          | 1.00                  | 4.09                  |
| voucher        | 5,783           | 1.00                  | 4.00                  |
| debit_card     | 1,529           | 1.00                  | 4.17                  |
| not_defined    | 3               | 1.00                  | 1.67                  |

**Insights:**
- Credit cards were the dominant payment method, accounting for 76,600 payment records—approximately 74% of all recorded payments.
- Credit-card purchases used an average of 3.51 installments, while boleto, voucher, and debit-card payments averaged one installment.
- Average review scores were very similar across the main payment methods, ranging from 4.00 to 4.17 out of 5. This suggests payment method was not strongly associated with customer satisfaction in this dataset.
- The `not_defined` payment category had only three records, so its 1.67 average review score should not be interpreted as a meaningful pattern.

## Dashboard
### Revenue & Customer Performance
The business generated 13.59M in revenue from 99.4K delivered orders, showing substantial marketplace activity during the analysis period.
Revenue grew strongly through 2017, peaking at 1.01M in November 2017, before remaining relatively stable at a higher level throughout 2018.
Health & Beauty and Watches & Gifts were the leading revenue-generating categories, while most major categories maintained review scores near 4 out of 5.
São Paulo was the strongest revenue-driving state, followed by Rio de Janeiro and Minas Gerais, showing a clear concentration of sales in these key markets.

<img width="1312" height="739" alt="Report1" src="https://github.com/user-attachments/assets/503ad167-4d28-4f12-bfcc-079e43d04a11" />

### Delivery Experience & Payment Behavior

Normal-speed deliveries represented the largest order group; however, customer satisfaction fell as delivery time increased.
Fast deliveries received an average review score of 4.41, compared with 3.68 for slow deliveries—highlighting delivery speed as an important factor associated with customer experience.
Credit cards were the dominant payment method, accounting for approximately 74% of payment records and using more installments on average than other methods.
Review scores were broadly similar across the main payment methods, suggesting that delivery experience had a stronger relationship with satisfaction than payment choice.

<img width="1304" height="732" alt="Report2" src="https://github.com/user-attachments/assets/0e36ed7e-bfbf-4032-b8c2-22689051220a" />

## What I Learned
Through this project, I strengthened my PostgreSQL skills by using joins, CTEs, aggregations, window functions, RANK(), LAG(), and CASE WHEN statements to answer business questions. I learned how to turn raw e-commerce data into meaningful insights about revenue, customers, delivery performance, and payment behavior. I also developed Power BI skills by creating dashboards that present trends and comparisons clearly. Most importantly, I learned to interpret results carefully and connect technical analysis to practical business decisions.

## Conclusions
This project transformed raw Olist e-commerce data into clear business insights using PostgreSQL and Power BI. The analysis showed strong revenue growth, identified high-performing product categories and key customer markets, and highlighted the relationship between delivery speed and customer satisfaction. It also revealed that credit cards were the preferred payment method, while payment choice had little effect on review scores compared with delivery experience. Overall, the project demonstrates how SQL-driven analysis and effective dashboards can support data-informed business decisions.
