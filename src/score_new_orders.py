import os
from pathlib import Path

import joblib
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL


# 1. Configuration

MODEL_VERSION = "logreg_v1"

PROJECT_ROOT = Path(__file__).resolve().parent.parent

MODEL_PATH = (
    PROJECT_ROOT / "models" / "delivery_delay_logreg.joblib"
)

ENV_PATH = PROJECT_ROOT / ".env"


# 2. PostgreSQL connection

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


# 3. Load the trained model

model_artifact = joblib.load(MODEL_PATH)

pipeline = model_artifact["pipeline"]
feature_names = list(model_artifact["feature_names"])

print(f"\nModel loaded: {MODEL_PATH.name}")


# 4. Load orders without predictions

query = text("""
    SELECT
        n.order_id,
        n.estimated_delivery_days,
        n.distance_km,
        n.item_count,
        n.seller_count,
        n.product_value,
        n.freight_value,
        n.is_interstate,
        n.customer_state,
        n.seller_state
    FROM new_orders n
    WHERE NOT EXISTS (
        SELECT 1
        FROM order_risk_predictions p
        WHERE p.order_id = n.order_id
    )
    ORDER BY n.order_id;
""")

try:
    with engine.connect() as connection:
        orders = pd.read_sql_query(query, connection)

    print(f"Orders awaiting scoring: {len(orders)}")

    if orders.empty:
        print("No new orders to score.")

    else:

        # 5. Prepare model features

        numeric_features = [
            "estimated_delivery_days",
            "distance_km",
            "item_count",
            "seller_count",
            "product_value",
            "freight_value",
        ]

        for column in numeric_features:
            orders[column] = pd.to_numeric(orders[column])

        orders["is_interstate"] = (
            orders["is_interstate"].astype(int)
        )

        X = orders[feature_names].copy()

        if X.isna().any().any():
            raise ValueError("Missing values detected in model features.")

        # 6. Generate risk scores

        risk_scores = pipeline.predict_proba(X)[:, 1]

        predictions = [
            {
                "order_id": order_id,
                "risk_score": float(score),
                "model_version": MODEL_VERSION,
            }
            for order_id, score in zip(
                orders["order_id"],
                risk_scores,
            )
        ]

        # 7. Save predictions to PostgreSQL

        insert_query = text("""
            INSERT INTO order_risk_predictions (
                order_id,
                risk_score,
                model_version
            )
            VALUES (
                :order_id,
                :risk_score,
                :model_version
            )
            ON CONFLICT (order_id)
            DO UPDATE SET
                risk_score = EXCLUDED.risk_score,
                model_version = EXCLUDED.model_version,
                scored_at = CURRENT_TIMESTAMP;
        """)

        with engine.begin() as connection:
            connection.execute(insert_query, predictions)

        print(f"Predictions saved: {len(predictions)}")
        print("Scoring completed successfully.")

finally:
    engine.dispose()
