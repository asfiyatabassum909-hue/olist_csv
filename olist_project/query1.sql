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

/*
OUTPUT:
[
  {
    "month": "2016-09",
    "total_revenue": "267.36",
    "running_total": "267.36",
    "previous_month_revenue": null,
    "growth_pct": null
  },
  {
    "month": "2016-10",
    "total_revenue": "49507.66",
    "running_total": "49775.02",
    "previous_month_revenue": "267.36",
    "growth_pct": "18417.23"
  },
  {
    "month": "2016-12",
    "total_revenue": "10.9",
    "running_total": "49785.92",
    "previous_month_revenue": "49507.66",
    "growth_pct": "-99.98"
  },
  {
    "month": "2017-01",
    "total_revenue": "120312.87",
    "running_total": "170098.79",
    "previous_month_revenue": "10.9",
    "growth_pct": "1103687.80"
  },
  {
    "month": "2017-02",
    "total_revenue": "247303.02",
    "running_total": "417401.81",
    "previous_month_revenue": "120312.87",
    "growth_pct": "105.55"
  },
  {
    "month": "2017-03",
    "total_revenue": "374344.30",
    "running_total": "791746.11",
    "previous_month_revenue": "247303.02",
    "growth_pct": "51.37"
  },
  {
    "month": "2017-04",
    "total_revenue": "359927.23",
    "running_total": "1151673.34",
    "previous_month_revenue": "374344.30",
    "growth_pct": "-3.85"
  },
  {
    "month": "2017-05",
    "total_revenue": "506071.14",
    "running_total": "1657744.48",
    "previous_month_revenue": "359927.23",
    "growth_pct": "40.60"
  },
  {
    "month": "2017-06",
    "total_revenue": "433038.60",
    "running_total": "2090783.08",
    "previous_month_revenue": "506071.14",
    "growth_pct": "-14.43"
  },
  {
    "month": "2017-07",
    "total_revenue": "498031.48",
    "running_total": "2588814.56",
    "previous_month_revenue": "433038.60",
    "growth_pct": "15.01"
  },
  {
    "month": "2017-08",
    "total_revenue": "573971.68",
    "running_total": "3162786.24",
    "previous_month_revenue": "498031.48",
    "growth_pct": "15.25"
  },
  {
    "month": "2017-09",
    "total_revenue": "624401.69",
    "running_total": "3787187.93",
    "previous_month_revenue": "573971.68",
    "growth_pct": "8.79"
  },
  {
    "month": "2017-10",
    "total_revenue": "664219.43",
    "running_total": "4451407.36",
    "previous_month_revenue": "624401.69",
    "growth_pct": "6.38"
  },
  {
    "month": "2017-11",
    "total_revenue": "1010271.37",
    "running_total": "5461678.73",
    "previous_month_revenue": "664219.43",
    "growth_pct": "52.10"
  },
  {
    "month": "2017-12",
    "total_revenue": "743914.17",
    "running_total": "6205592.90",
    "previous_month_revenue": "1010271.37",
    "growth_pct": "-26.36"
  },
  {
    "month": "2018-01",
    "total_revenue": "950030.36",
    "running_total": "7155623.26",
    "previous_month_revenue": "743914.17",
    "growth_pct": "27.71"
  },
  {
    "month": "2018-02",
    "total_revenue": "844178.71",
    "running_total": "7999801.97",
    "previous_month_revenue": "950030.36",
    "growth_pct": "-11.14"
  },
  {
    "month": "2018-03",
    "total_revenue": "983213.44",
    "running_total": "8983015.41",
    "previous_month_revenue": "844178.71",
    "growth_pct": "16.47"
  },
  {
    "month": "2018-04",
    "total_revenue": "996647.75",
    "running_total": "9979663.16",
    "previous_month_revenue": "983213.44",
    "growth_pct": "1.37"
  },
  {
    "month": "2018-05",
    "total_revenue": "996517.68",
    "running_total": "10976180.84",
    "previous_month_revenue": "996647.75",
    "growth_pct": "-0.01"
  },
  {
    "month": "2018-06",
    "total_revenue": "865124.31",
    "running_total": "11841305.15",
    "previous_month_revenue": "996517.68",
    "growth_pct": "-13.19"
  },
  {
    "month": "2018-07",
    "total_revenue": "895507.22",
    "running_total": "12736812.37",
    "previous_month_revenue": "865124.31",
    "growth_pct": "3.51"
  },
  {
    "month": "2018-08",
    "total_revenue": "854686.33",
    "running_total": "13591498.70",
    "previous_month_revenue": "895507.22",
    "growth_pct": "-4.56"
  },
  {
    "month": "2018-09",
    "total_revenue": "145.0",
    "running_total": "13591643.70",
    "previous_month_revenue": "854686.33",
    "growth_pct": "-99.98"
  }
]
*/