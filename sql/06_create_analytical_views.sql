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


-- Power BI: Order-Level Analytical View
-- Create the main order-level view for Power BI
CREATE OR REPLACE VIEW vw_powerbi_orders AS

SELECT
    -- Order identifiers and status
    d.order_id,
    d.customer_id,
    d.order_status,

    -- Order and delivery dates
    d.order_purchase_timestamp,
    d.order_approved_at,
    d.order_delivered_carrier_date,
    d.order_delivered_customer_date,
    d.order_estimated_delivery_date,

    -- Delivery performance
    d.delivery_days,
    d.has_date_sequence_issue,

    -- Identify orders with assessable delivery outcomes
    (
        d.order_status = 'delivered'
        AND d.order_delivered_customer_date IS NOT NULL
        AND d.order_estimated_delivery_date IS NOT NULL
    ) AS is_delivery_assessable,

    -- Late delivery flag only for assessable orders
    CASE
        WHEN d.order_status = 'delivered'
             AND d.order_delivered_customer_date IS NOT NULL
             AND d.order_estimated_delivery_date IS NOT NULL
        THEN d.is_late_delivery
        ELSE NULL
    END AS is_late_delivery,

    -- Sales and order characteristics
    s.item_count,
    s.seller_count,
    s.product_value,
    s.freight_value,
    s.order_value,

    -- Sales data availability
    (s.order_id IS NOT NULL) AS has_sales_data,

    -- Customer geographical information
    c.customer_state,
    c.customer_city,
    c.customer_zip_code_prefix,

    -- Approximate customer coordinates (ZIP code prefix level)
    g.latitude_mdn AS customer_latitude,
    g.longitude_mdn AS customer_longitude,

    -- Geolocation quality indicator
    g.has_state_conflict AS customer_geo_state_conflict

FROM vw_order_delivery d

LEFT JOIN vw_order_sales s
    ON d.order_id = s.order_id

LEFT JOIN customers c
    ON d.customer_id = c.customer_id

LEFT JOIN vw_geolocation_prefix g
    ON c.customer_zip_code_prefix::text =
       g.geolocation_zip_code_prefix;



-- Power BI: Order-Seller Shipping Routes
CREATE OR REPLACE VIEW vw_powerbi_shipping_routes AS

WITH order_sellers AS (
    -- Aggregate order items at the order-seller level
    SELECT
        order_id,
        seller_id,
        COUNT(*) AS seller_item_count,
        SUM(price) AS seller_product_value,
        SUM(freight_value) AS seller_freight_value
    FROM order_items
    GROUP BY order_id, seller_id
),

route_data AS (
    -- Combine seller information with order and customer data
    SELECT
        o.order_id,
        os.seller_id,
        o.order_purchase_timestamp,
        o.order_status,

        -- Delivery information
        o.is_delivery_assessable,
        o.is_late_delivery,
        o.delivery_days,

        -- Customer location
        o.customer_state,
        o.customer_city,
        o.customer_zip_code_prefix,
        o.customer_latitude,
        o.customer_longitude,
        o.customer_geo_state_conflict,

        -- Seller location
        s.seller_state,
        s.seller_city,
        s.seller_zip_code_prefix,
        g.latitude_mdn AS seller_latitude,
        g.longitude_mdn AS seller_longitude,
        g.has_state_conflict AS seller_geo_state_conflict,

        -- Seller-level order characteristics
        os.seller_item_count,
        os.seller_product_value,
        os.seller_freight_value

    FROM order_sellers os

    JOIN vw_powerbi_orders o
        ON os.order_id = o.order_id

    LEFT JOIN sellers s
        ON os.seller_id = s.seller_id

    LEFT JOIN vw_geolocation_prefix g
        ON s.seller_zip_code_prefix::text =
           g.geolocation_zip_code_prefix
)

SELECT
    r.*,

    -- Calculate approximate straight-line distance (Haversine)
    CASE
        WHEN r.customer_latitude BETWEEN -34 AND 6
         AND r.customer_longitude BETWEEN -74 AND -34
         AND r.seller_latitude BETWEEN -34 AND 6
         AND r.seller_longitude BETWEEN -74 AND -34

        THEN ROUND((
            6371.0 * 2 * ASIN(
                SQRT(
                    LEAST(
                        1.0,
                        POWER(
                            SIN(
                                RADIANS(
                                    r.seller_latitude - r.customer_latitude
                                ) / 2
                            ),
                            2
                        )
                        +
                        COS(RADIANS(r.customer_latitude))
                        * COS(RADIANS(r.seller_latitude))
                        * POWER(
                            SIN(
                                RADIANS(
                                    r.seller_longitude - r.customer_longitude
                                ) / 2
                            ),
                            2
                        )
                    )
                )
            )
        )::numeric, 2)

        ELSE NULL
    END AS distance_km

FROM route_data r;



-- Power BI: Product Category Sales
-- Grain: one row per order and product category

CREATE OR REPLACE VIEW vw_powerbi_category_sales AS

SELECT
    oi.order_id,

    INITCAP(
        REPLACE(
            COALESCE(t.product_category_name_english, 'Unknown'),
            '_',
            ' '
        )
    ) AS product_category,

    COUNT(*) AS items_sold,

    SUM(oi.price) AS merchandise_value

FROM order_items oi

LEFT JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN product_category_translation t
    ON p.product_category_name = t.product_category_name

GROUP BY
    oi.order_id,
    INITCAP(
        REPLACE(
            COALESCE(t.product_category_name_english, 'Unknown'),
            '_',
            ' '
        )
    );