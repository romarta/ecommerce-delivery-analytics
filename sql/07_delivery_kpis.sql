-- Calculate key delivery performance indicators
SELECT
    COUNT(is_late_delivery) AS evaluated_orders,

    COUNT(*) FILTER (
        WHERE is_late_delivery = TRUE
    ) AS late_orders,

    COUNT(*) FILTER (
        WHERE is_late_delivery = FALSE
    ) AS on_time_orders,

    -- Calculate the percentage of delayed deliveries
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE is_late_delivery = TRUE
        ) / NULLIF(COUNT(is_late_delivery), 0),
        2
    ) AS late_delivery_rate_pct

FROM vw_order_delivery;

-- Calculate the number of days each late order was delayed
WITH late_deliveries AS (
    SELECT
        order_delivered_customer_date::DATE
        - order_estimated_delivery_date::DATE AS days_late
    FROM vw_order_delivery
    WHERE is_late_delivery = TRUE
)

-- Summarize the severity of delivery delays
SELECT
    COUNT(*) AS late_orders,
    ROUND(AVG(days_late), 2) AS avg_days_late,
    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY days_late
    ) AS median_days_late,
    MAX(days_late) AS max_days_late
FROM late_deliveries;

-- Calculate delay duration for late orders
WITH delays AS (
    SELECT
        order_delivered_customer_date::DATE
        - order_estimated_delivery_date::DATE AS days_late
    FROM vw_order_delivery
    WHERE is_late_delivery = TRUE
)

-- Group late deliveries by delay duration
SELECT
    CASE
        WHEN days_late BETWEEN 1 AND 3 THEN '1-3 days'
        WHEN days_late BETWEEN 4 AND 7 THEN '4-7 days'
        WHEN days_late BETWEEN 8 AND 14 THEN '8-14 days'
        WHEN days_late BETWEEN 15 AND 30 THEN '15-30 days'
        ELSE '31+ days'
    END AS delay_group,

    COUNT(*) AS orders

FROM delays
GROUP BY delay_group
ORDER BY MIN(days_late);


-- Identify the five most delayed orders
SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    -- Calculate the number of days past the estimated delivery date
    order_delivered_customer_date::DATE
        - order_estimated_delivery_date::DATE AS days_late,

    has_date_sequence_issue

FROM vw_order_delivery
WHERE is_late_delivery = TRUE
ORDER BY days_late DESC
LIMIT 5;

-- Identify delivery dates with the highest number of extreme delays
SELECT
    order_delivered_customer_date::DATE AS delivery_date,
    COUNT(*) AS extremely_late_orders
FROM vw_order_delivery
WHERE is_late_delivery = TRUE
    AND order_delivered_customer_date::DATE
        - order_estimated_delivery_date::DATE > 90
GROUP BY delivery_date
ORDER BY extremely_late_orders DESC
LIMIT 10;

-- Examine deliveries recorded on September 19, 2017
SELECT
    COUNT(*) AS total_deliveries,

    -- Count deliveries delayed by more than 90 days
    COUNT(*) FILTER (
        WHERE order_delivered_customer_date::DATE
            - order_estimated_delivery_date::DATE > 90
    ) AS extreme_delays,

    -- Check the earliest and latest delivery timestamps
    MIN(order_delivered_customer_date) AS first_delivery,
    MAX(order_delivered_customer_date) AS last_delivery

FROM vw_order_delivery
WHERE order_delivered_customer_date::DATE = '2017-09-19';

-- Calculate daily delivery volumes and extreme delays in September 2017
WITH daily_deliveries AS (
    SELECT
        order_delivered_customer_date::DATE AS delivery_date,
        COUNT(*) AS deliveries,

        -- Count deliveries delayed by more than 90 days
        COUNT(*) FILTER (
            WHERE order_delivered_customer_date::DATE
                - order_estimated_delivery_date::DATE > 90
        ) AS extreme_delays

    FROM vw_order_delivery
    WHERE order_status = 'delivered'
        AND order_delivered_customer_date >= '2017-09-01'
        AND order_delivered_customer_date < '2017-10-01'
    GROUP BY delivery_date
)

-- Compare September 19 with monthly delivery statistics
SELECT
    ROUND(AVG(deliveries), 2) AS avg_daily_deliveries,
    MAX(deliveries) AS max_daily_deliveries,

    MAX(deliveries) FILTER (
        WHERE delivery_date = '2017-09-19'
    ) AS deliveries_sep_19,

    ROUND(AVG(extreme_delays), 2) AS avg_daily_extreme_delays,
    MAX(extreme_delays) AS max_daily_extreme_delays,

    MAX(extreme_delays) FILTER (
        WHERE delivery_date = '2017-09-19'
    ) AS extreme_delays_sep_19

FROM daily_deliveries;