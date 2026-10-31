# Risk Monitoring Pipeline

## Overview

The Risk Monitoring pipeline demonstrates how a trained machine learning model can be integrated into an e-commerce analytics workflow.
It generates synthetic orders, assigns delivery delay risk scores using a saved Logistic Regression model, and makes the results available in Power BI.
The pipeline is a portfolio demonstration, not a production prediction system.

## Pipeline Architecture

```text
Historical Olist Data
        |
        v
Synthetic Order Generation (Python)
        |
        v
PostgreSQL: new_orders
        |
        v
Logistic Regression Scoring (Python)
        |
        v
PostgreSQL: order_risk_predictions
        |
        v
vw_powerbi_risk_monitoring
        |
        v
Power BI: Risk Monitoring
```

## 1. Synthetic Order Generation

**Script:** `src/generate_new_orders.py`

The generator samples historical combinations of order characteristics to preserve realistic relationships between features.
The source population consists of delivered orders with a single seller and the information required for scoring.
Each generated order receives:

- A unique synthetic order ID.
- A new purchase timestamp.
- An estimated delivery date consistent with the generated purchase date and delivery estimate.
- Nine model input features derived from historical order characteristics.

Each execution generates a batch of 300 orders.
Synthetic orders are stored in the PostgreSQL table `new_orders` and remain separate from historical Olist transactions.

## 2. Machine Learning Scoring

**Script:** `src/score_new_orders.py`  
**Model:** `models/delivery_delay_logreg.joblib`

The script identifies orders without existing predictions and applies the saved Logistic Regression pipeline.

The model uses nine purchase-time features:

| Feature | Description |
|---|---|
| `estimated_delivery_days` | Estimated delivery duration |
| `distance_km` | Approximate shipping distance |
| `item_count` | Number of purchased items |
| `seller_count` | Number of sellers |
| `product_value` | Merchandise value |
| `freight_value` | Shipping charges |
| `is_interstate` | Whether the shipment crosses state boundaries |
| `customer_state` | Customer's Brazilian state |
| `seller_state` | Seller's Brazilian state |

The resulting scores are saved in `order_risk_predictions`, together with the model version and scoring timestamp.
Previously scored orders are skipped during subsequent executions.

## 3. Risk Classification

The PostgreSQL view `vw_powerbi_risk_monitoring` combines synthetic orders with model predictions.
Orders are ranked by descending risk score.
The highest-scoring 10% are classified as **High Risk**, while the remaining orders are classified as **Other Orders**.
The ranking is recalculated as additional orders receive predictions.

**Important:** Risk scores are used for relative prioritization. They are not reliably calibrated probabilities of late delivery. The High Risk category does not represent an expected 10% delivery delay rate.

## 4. Database Configuration

Both Python scripts load PostgreSQL connection settings from a local `.env` file using `python-dotenv`.
The `.env` file is excluded from version control. A `.env.example` template documents the required environment variables without exposing credentials.

## 5. Running the Pipeline

Generate a new batch of synthetic orders:

```bash
python src/generate_new_orders.py
```

Score orders without existing predictions:

```bash
python src/score_new_orders.py
```

Refresh the Power BI report to display the updated risk rankings.
**Power BI refresh does not execute the Python scripts.** Order generation and scoring must be completed before refreshing the report.

## 6. Validation and Limitations

The end-to-end workflow was tested by generating additional synthetic orders, calculating their scores, verifying PostgreSQL records, and refreshing Power BI.
The model demonstrated limited temporal stability and weak performance on the final chronological test set. It is therefore used only to demonstrate risk-based order prioritization.
Synthetic orders do not contain observed delivery outcomes, so their actual delay rate and the model's predictive accuracy on these orders cannot be measured.
For model development, evaluation metrics, and limitations, see the [Machine Learning Summary](ml_summary.md).