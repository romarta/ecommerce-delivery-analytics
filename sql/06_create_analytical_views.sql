-- Create one representative location per ZIP prefix
CREATE OR REPLACE VIEW vw_geolocation_prefix AS
SELECT geolocation_zip_code_prefix,

    -- Calculate representative coordinates using the median
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY geolocation_lat) AS latitude_mdn,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY geolocation_lng) AS longitude_mdn,

    -- Count observations for each ZIP prefix
    COUNT(*) AS location_count,

    -- Flag ZIP prefixes associated with multiple states
    COUNT(DISTINCT geolocation_state) > 1 AS has_state_conflict

FROM geolocation
WHERE geolocation_zip_code_prefix IS NOT NULL
GROUP BY geolocation_zip_code_prefix;

-- Create an analytical view for delivery performance
CREATE OR REPLACE VIEW vw_order_delivery AS

SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    -- Flag inconsistent date sequences
    (
        order_delivered_carrier_date < order_purchase_timestamp
        OR order_delivered_customer_date < order_delivered_carrier_date
    ) IS TRUE AS has_date_sequence_issue,

    -- Calculate delivery time in calendar days
    CASE
        WHEN order_status = 'delivered'
             AND order_delivered_customer_date IS NOT NULL
        THEN order_delivered_customer_date::DATE
             - order_purchase_timestamp::DATE
    END AS delivery_days,

    -- Flag orders delivered after the estimated date
    CASE
        WHEN order_status = 'delivered'
             AND order_delivered_customer_date IS NOT NULL
        THEN order_delivered_customer_date::DATE
             > order_estimated_delivery_date::DATE
    END AS is_late_delivery

FROM orders;




-- Aggregate order items to the order level
CREATE OR REPLACE VIEW vw_order_sales AS

SELECT
    order_id,

    -- Count products and distinct sellers per order
    COUNT(*) AS item_count,
    COUNT(DISTINCT seller_id) AS seller_count,

    -- Calculate product and freight values
    SUM(price) AS product_value,
    SUM(freight_value) AS freight_value,

    -- Calculate total order value including freight
    SUM(price + freight_value) AS order_value

FROM order_items
GROUP BY order_id;