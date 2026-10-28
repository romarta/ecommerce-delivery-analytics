-- Check orders without a matching customer
SELECT COUNT(*) AS missing_customers
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Check foreign key relationships between tables

SELECT
    'order_items → orders' AS relationship,
    COUNT(*) AS missing_references
FROM order_items i
LEFT JOIN orders o ON i.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
    'order_items → products',
    COUNT(*)
FROM order_items i
LEFT JOIN products p ON i.product_id = p.product_id
WHERE p.product_id IS NULL

UNION ALL

SELECT
    'order_items → sellers',
    COUNT(*)
FROM order_items i
LEFT JOIN sellers s ON i.seller_id = s.seller_id
WHERE s.seller_id IS NULL

UNION ALL

SELECT
    'order_payments → orders',
    COUNT(*)
FROM order_payments p
LEFT JOIN orders o ON p.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
    'order_reviews → orders',
    COUNT(*)
FROM order_reviews r
LEFT JOIN orders o ON r.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

-- Check category references, excluding products without a category
SELECT
    'products → category_translation',
    COUNT(*)
FROM products p
LEFT JOIN product_category_translation t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
    AND t.product_category_name IS NULL;

-- Identify product categories without English translations
SELECT
    p.product_category_name,
    COUNT(*) AS product_count
FROM products p
LEFT JOIN product_category_translation t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
    AND t.product_category_name IS NULL
GROUP BY p.product_category_name
ORDER BY product_count DESC;

-- Count orders without items
SELECT
    'Without items' AS check_type,
    COUNT(*) AS order_count
FROM orders o
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items i
    WHERE i.order_id = o.order_id
)

UNION ALL

-- Count orders without payments
SELECT
    'Without payments',
    COUNT(*)
FROM orders o
WHERE NOT EXISTS (
    SELECT 1
    FROM order_payments p
    WHERE p.order_id = o.order_id
)

UNION ALL

-- Count orders without reviews
SELECT
    'Without reviews',
    COUNT(*)
FROM orders o
WHERE NOT EXISTS (
    SELECT 1
    FROM order_reviews r
    WHERE r.order_id = o.order_id
);

-- Check the status of orders without items
SELECT
    o.order_status,
    COUNT(*) AS orders_without_items
FROM orders o
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items i
    WHERE i.order_id = o.order_id
)
GROUP BY o.order_status
ORDER BY orders_without_items DESC;

-- Identify orders without payment records
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp
FROM orders o
WHERE NOT EXISTS (
    SELECT 1
    FROM order_payments p
    WHERE p.order_id = o.order_id
);

-- Check the number of unique postal code prefixes
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zip_prefixes
FROM geolocation;

-- Check ZIP prefixes associated with multiple states
SELECT
    geolocation_zip_code_prefix,
    COUNT(DISTINCT geolocation_state) AS state_count
FROM geolocation
GROUP BY geolocation_zip_code_prefix
HAVING COUNT(DISTINCT geolocation_state) > 1
ORDER BY state_count DESC;

-- Check uniqueness of candidate composite keys
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (geolocation_zip_code_prefix, geolocation_state)) AS zip_state,
    COUNT(DISTINCT (geolocation_zip_code_prefix, geolocation_city)) AS zip_city,
    COUNT(DISTINCT (geolocation_zip_code_prefix, geolocation_lat)) AS zip_lat,
    COUNT(DISTINCT (geolocation_zip_code_prefix, geolocation_lng)) AS zip_lng,
    COUNT(DISTINCT (geolocation_lat, geolocation_lng)) AS lat_lng
FROM geolocation;


-- Count customers without matching geolocation data
SELECT
    'customers' AS source,
    COUNT(*) AS unmatched_records
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM geolocation g
    WHERE g.geolocation_zip_code_prefix = c.customer_zip_code_prefix
)

UNION ALL

-- Count sellers without matching geolocation data
SELECT
    'sellers',
    COUNT(*)
FROM sellers s
WHERE NOT EXISTS (
    SELECT 1
    FROM geolocation g
    WHERE g.geolocation_zip_code_prefix = s.seller_zip_code_prefix
);

-- Count unmatched customers by state
SELECT
    customer_state AS state,
    COUNT(*) AS unmatched_customers
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM geolocation g
    WHERE g.geolocation_zip_code_prefix = c.customer_zip_code_prefix
)
GROUP BY customer_state
ORDER BY unmatched_customers DESC;

-- Display all geolocation records for a ZIP prefix assigned to multiple states (example)
SELECT *
FROM geolocation
WHERE geolocation_zip_code_prefix = '02116'
ORDER BY
    geolocation_state,
    geolocation_city;


-- Calculate the observed coordinate range for ZIP prefix 02116 (example)
SELECT
    geolocation_zip_code_prefix,
    COUNT(*) AS total_records,
    MIN(geolocation_lat) AS min_lat,
    MAX(geolocation_lat) AS max_lat,
    MIN(geolocation_lng) AS min_lng,
    MAX(geolocation_lng) AS max_lng
FROM geolocation
WHERE geolocation_zip_code_prefix = '02116'
GROUP BY geolocation_zip_code_prefix;

-- Verify that joining analytical views preserves the order-level granularity
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT o.order_id) AS unique_orders,

    -- Count orders without items
    COUNT(*) FILTER (
        WHERE s.order_id IS NULL
    ) AS orders_without_items,

    -- Verify the total number of order items
    SUM(s.item_count) AS total_items,

    -- Verify the number of evaluated deliveries
    COUNT(d.is_late_delivery) AS evaluated_deliveries

FROM orders o
LEFT JOIN vw_order_sales s
    ON o.order_id = s.order_id
LEFT JOIN vw_order_delivery d
    ON o.order_id = d.order_id;