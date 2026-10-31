import os
from pathlib import Path

from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL


# 1. PostgreSQL connection

PROJECT_ROOT = Path(__file__).resolve().parent.parent
ENV_PATH = PROJECT_ROOT / ".env"

if not ENV_PATH.exists():
    raise FileNotFoundError("Missing .env file in project root.")

load_dotenv(ENV_PATH)

required_variables = ["DB_NAME", "DB_USER", "DB_PASSWORD"]

missing_variables = [
    variable
    for variable in required_variables
    if not os.getenv(variable)
]

if missing_variables:
    raise ValueError(
        f"Missing database configuration: {', '.join(missing_variables)}"
    )

database_url = URL.create(
    "postgresql+psycopg2",
    username=os.environ["DB_USER"],
    password=os.environ["DB_PASSWORD"],
    host=os.getenv("DB_HOST", "localhost"),
    port=int(os.getenv("DB_PORT", "5432")),
    database=os.environ["DB_NAME"],
)

engine = create_engine(database_url)

# 2. Generate synthetic orders
generate_sql = text("""
    INSERT INTO new_orders (
        order_id,
        order_purchase_timestamp,
        estimated_delivery_days,
        distance_km,
        customer_state,
        seller_state,
        is_interstate,
        item_count,
        seller_count,
        product_value,
        freight_value
    )

    SELECT
        'SYN_' || REPLACE(gen_random_uuid()::text, '-', ''),

        LOCALTIMESTAMP - RANDOM() * INTERVAL '7 days',

        FLOOR(
            EXTRACT(
                EPOCH FROM (
                    o.order_estimated_delivery_date
                    - o.order_purchase_timestamp
                )
            ) / 86400.0
        ),

        r.distance_km,
        o.customer_state,
        r.seller_state,
        o.customer_state <> r.seller_state,
        o.item_count,
        o.seller_count,
        o.product_value,
        o.freight_value

    FROM vw_powerbi_orders o

    JOIN vw_powerbi_shipping_routes r
        ON o.order_id = r.order_id

    WHERE o.order_status = 'delivered'
      AND o.seller_count = 1

      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'

      AND o.order_estimated_delivery_date IS NOT NULL
      AND o.order_estimated_delivery_date > o.order_purchase_timestamp

      AND r.distance_km IS NOT NULL
      AND r.seller_state IS NOT NULL

      AND o.customer_state IS NOT NULL
      AND o.item_count IS NOT NULL
      AND o.product_value IS NOT NULL
      AND o.freight_value IS NOT NULL

    ORDER BY RANDOM()
    LIMIT 300;
""")


# 3. Insert synthetic orders into PostgreSQL

print("\nConnecting to PostgreSQL...")
print("Generating synthetic orders...")

try:
    with engine.begin() as connection:
        result = connection.execute(generate_sql)

        # Save the estimated delivery date for new orders
        connection.execute(text("""
            UPDATE new_orders
            SET estimated_delivery_date =
                order_purchase_timestamp::date
                + estimated_delivery_days::integer
            WHERE estimated_delivery_date IS NULL;
        """))

    print(f"\nGenerated orders: {result.rowcount}")
    print("Synthetic orders saved successfully.")

finally:
    engine.dispose()


print("\nScript completed.")