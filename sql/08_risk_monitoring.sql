
-- Risk Monitoring: Synthetic New Orders

CREATE TABLE IF NOT EXISTS new_orders (
    order_id TEXT PRIMARY KEY,
    order_purchase_timestamp TIMESTAMP NOT NULL,

    -- Delivery promise and geography
    estimated_delivery_days DOUBLE PRECISION,
    estimated_delivery_date DATE,
    distance_km DOUBLE PRECISION,
    customer_state TEXT,
    seller_state TEXT,
    is_interstate BOOLEAN,

    -- Order characteristics
    item_count INTEGER,
    seller_count INTEGER,
    product_value NUMERIC(12, 2),
    freight_value NUMERIC(12, 2),

    -- Record creation timestamp
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);



-- Risk Monitoring: Model Predictions
CREATE TABLE IF NOT EXISTS order_risk_predictions (
    order_id TEXT PRIMARY KEY
        REFERENCES new_orders(order_id)
        ON DELETE CASCADE,

    risk_score DOUBLE PRECISION NOT NULL
        CHECK (risk_score BETWEEN 0 AND 1),

    model_version TEXT NOT NULL,

    scored_at TIMESTAMPTZ NOT NULL
        DEFAULT CURRENT_TIMESTAMP
);


-- Risk Monitoring: Power BI Analytical View
CREATE OR REPLACE VIEW vw_powerbi_risk_monitoring AS

WITH ranked_orders AS (
    SELECT
        n.order_id,
        n.order_purchase_timestamp,
        n.customer_state,
        n.seller_state,
        n.is_interstate,
        n.estimated_delivery_days,
        n.distance_km,
        n.item_count,
        n.seller_count,
        n.product_value,
        n.freight_value,

        p.risk_score,
        p.model_version,
        p.scored_at,

        ROW_NUMBER() OVER (
            ORDER BY p.risk_score DESC, n.order_id
        ) AS risk_rank,

        COUNT(*) OVER () AS total_scored_orders,

        n.estimated_delivery_date

    FROM new_orders n

    INNER JOIN order_risk_predictions p
        ON n.order_id = p.order_id
)

SELECT
    order_id,
    order_purchase_timestamp,
    customer_state,
    seller_state,
    is_interstate,
    estimated_delivery_days,
    distance_km,
    item_count,
    seller_count,
    product_value,
    freight_value,

    risk_score,
    model_version,
    scored_at,
    risk_rank,

    CASE
        WHEN risk_rank <= CEIL(total_scored_orders * 0.10)
        THEN 'High Risk'
        ELSE 'Other Orders'
    END AS risk_category,

    estimated_delivery_date

FROM ranked_orders;