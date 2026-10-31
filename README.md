# E-commerce Performance & Delivery Analytics

End-to-End Business Analytics with PostgreSQL, Python, Machine Learning & Power BI

**[View Interactive Power BI Dashboard](https://app.powerbi.com/view?r=eyJrIjoiOTUxMmZmNmMtZDQ0ZS00YjA1LTg2ODEtZDFhMDlkMGIzNWIxIiwidCI6IjJmYWI1MTA4LTBiM2UtNDYwMy05Yjc3LTM2Y2QyYzk0ZmEzZSJ9)**

Explore the Executive Overview, Delivery Performance, and Risk Monitoring dashboards.

## Project Overview

This project explores e-commerce sales performance, order fulfillment efficiency, delivery delays, and customer satisfaction using real-world transactional data from Olist, a Brazilian e-commerce platform.
The analysis is designed as an end-to-end business analytics case study, combining relational data modeling, SQL, exploratory data analysis, statistical inference, predictive modeling, and interactive business intelligence reporting.
The objective is to identify operational patterns, investigate factors associated with delivery delays and customer satisfaction, and evaluate whether delivery risks can be predicted using information available at the time of purchase.

## Business Context

Efficient order fulfillment is an important component of e-commerce operations.
Delivery delays may affect customer experience, operational performance, and the reliability of promised delivery dates.
Understanding how delivery performance varies across products, sellers, and geographical regions can help businesses identify areas requiring further investigation.
This project approaches these challenges from the perspective of a Data Analyst supporting an e-commerce operations team.

## Business Objectives

The project focuses on three main analytical objectives.

### 1. Evaluate E-commerce Performance

Analyze order volumes, sales value, product categories, and seller performance to understand overall business activity.

### 2. Investigate Delivery Performance and Customer Satisfaction

Examine delivery times, delayed shipments, and customer reviews to identify patterns associated with operational inefficiencies and customer dissatisfaction.

### 3. Predict Delivery Delays

Develop and evaluate machine learning models to estimate the risk of delayed delivery using information available before the delivery outcome is known.

## Key Business Questions

- How do order volumes and sales values change over time?
- Which product categories generate the highest sales value?
- How does delivery performance vary across sellers and regions?
- What proportion of delivered orders arrive after the estimated delivery date?
- How are delivery delays associated with customer review scores?
- Which order characteristics are associated with a higher risk of late delivery?
- Can machine learning models identify orders at risk of delay?

## Dataset

**Source:** Brazilian E-Commerce Public Dataset by Olist

**Provider:** Olist

**Platform:** Kaggle

**Dataset URL:** https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

**Period:** 2016–2018

The dataset contains approximately 100,000 orders and includes information about customers, orders, products, sellers, payments, reviews, and geographical locations.

The original data is anonymized.

**License:** CC BY-NC-SA 4.0

Raw datasets are not included in this repository. Instructions for obtaining the data are provided in [data/README.md](data/README.md).

## Tools and Technologies

The project combines PostgreSQL, Python, Machine Learning, and Power BI to deliver an end-to-end e-commerce analytics solution.

| Tool | Purpose |
|---|---|
| PostgreSQL | Relational database, analytical views, and ML prediction storage |
| SQL | Data validation, transformations, and business metrics |
| Python | Data preparation, statistical analysis, and ML scoring |
| JupyterLab | Exploratory analysis and analytical documentation |
| pandas / NumPy | Data manipulation and numerical computations |
| scipy / statsmodels | Statistical inference |
| scikit-learn | Predictive modeling and evaluation |
| CatBoost | Gradient boosting classification |
| joblib | Machine learning model serialization |
| SQLAlchemy / psycopg2 | Python integration with PostgreSQL |
| python-dotenv | Secure loading of local database configuration |
| Power BI | Interactive dashboards and risk monitoring |
| Azure Maps | Geographical visualization of delivery performance |
| Git / GitHub | Version control and project documentation |

## Project Workflow

The project follows an end-to-end analytics workflow, from raw transactional data to interactive business intelligence and machine learning-based risk monitoring.

1. **Project Setup and Data Acquisition** — Repository initialization, environment configuration, and acquisition of the Olist dataset.
2. **Data Understanding and Analytical Planning** — Exploration of the database structure, definition of business questions, and identification of analytical requirements.
3. **PostgreSQL Database Development** — Database creation, data import, relational modeling, and analytical SQL views.
4. **Data Quality Assessment** — Validation of data completeness, consistency, relationships, and delivery date sequences.
5. **Exploratory Data Analysis** — Investigation of sales performance, delivery times, geographical patterns, and customer satisfaction.
6. **Statistical Analysis** — Examination of relationships between delivery performance, customer reviews, and operational characteristics.
7. **Machine Learning Development** — Feature engineering, model comparison, hyperparameter tuning, chronological evaluation, and temporal backtesting.
8. **Risk Monitoring Pipeline** — Generation of synthetic orders, scoring with the saved Logistic Regression model, and storage of predictions in PostgreSQL.
9. **Power BI Dashboard Development** — Creation of the Executive Overview, Delivery Performance, and Risk Monitoring dashboards.
10. **Pipeline Validation and Final Reporting** — Verification of data refresh, integration testing

## Repository Structure

The repository is organized to separate data preparation, analytical research, machine learning, business intelligence, and project documentation.

| Path | Description |
|---|---|
| `data/` | Data source documentation and local data storage |
| `sql/` | PostgreSQL database creation, data validation, transformations, and analytical views |
| `notebooks/` | Data understanding, exploratory analysis, statistical analysis, and machine learning |
| `models/` | Serialized machine learning models |
| `src/` | Python scripts for synthetic order generation and ML scoring |
| `docs/` | Data quality, analytical methodology, ML evaluation, dashboard, and pipeline documentation |
| `powerbi/` | Power BI report and dashboard documentation |
| `reports/` | Business findings, recommendations, and final reporting |
| `requirements.txt` | Python dependencies |
| `.env.example` | Example PostgreSQL connection configuration without credentials |
| `.gitignore` | Files and directories excluded from version control |
| `README.md` | Main project documentation |

### Key Pipeline Files

| File | Purpose |
|---|---|
| `sql/06_create_analytical_views.sql` | Analytical views supporting historical reporting and product category analysis |
| `sql/08_risk_monitoring.sql` | Database tables and analytical view for synthetic order risk monitoring |
| `src/generate_new_orders.py` | Generates synthetic orders based on historical Olist order characteristics |
| `src/score_new_orders.py` | Loads the trained Logistic Regression model and saves risk scores to PostgreSQL |
| `models/delivery_delay_logreg.joblib` | Saved Logistic Regression prediction pipeline |

Historical business analytics and synthetic risk monitoring are maintained separately to prevent simulated orders from affecting historical KPIs.
## Local Setup & Database Configuration

The project uses PostgreSQL for data storage, Python for analytical processing and machine learning, and Power BI for interactive reporting.

### 1. Install Dependencies

Create a Python virtual environment and install the required packages:

```bash
pip install -r requirements.txt
```

### 2. Configure PostgreSQL Connection

Database credentials are managed through environment variables using `python-dotenv`.
Copy `.env.example` to a new file named `.env` in the project root.
Configure the connection using your local PostgreSQL credentials:

```dotenv
DB_HOST=localhost
DB_PORT=5432
DB_NAME=olist_ecommerce
DB_USER=postgres
DB_PASSWORD=your_password
```

The Python scripts automatically load these settings from `.env`. No interactive password entry is required.

**Security:** The `.env` file is excluded from version control through `.gitignore` and must never be committed to GitHub. The repository includes `.env.example` as a configuration template without sensitive credentials.

### 3. Prepare the Database

Create the PostgreSQL database and execute the SQL scripts in the `sql/` directory to prepare the historical dataset, analytical views, and risk monitoring tables.
The original Olist dataset must be downloaded separately. See [Data Source and Import Instructions](data/README.md) for setup details.

### 4. Run the Risk Monitoring Pipeline

The risk monitoring workflow uses synthetic orders and a previously trained Logistic Regression model.

Generate synthetic orders:

```bash
python src/generate_new_orders.py
```

Each execution adds a new batch of 300 synthetic orders to PostgreSQL.

Calculate risk scores:

```bash
python src/score_new_orders.py
```

The scoring script loads the saved model from `models/delivery_delay_logreg.joblib`, evaluates orders without existing predictions, and stores the results in PostgreSQL.
The `vw_powerbi_risk_monitoring` view provides the scored orders and their relative risk ranking to Power BI.

### 5. Refresh Power BI

After running the scoring script, refresh the Power BI report to load the latest predictions.

**Important:** Power BI refresh does not execute the Python scripts. Generating orders, calculating scores, and refreshing the dashboard are separate operations.

### Model Interpretation

Risk Monitoring is a demonstration based on synthetic orders.
The `High Risk` category identifies the top 10% of scored orders ranked by the Logistic Regression model. Risk scores are not calibrated probabilities of delivery delay.
The model demonstrated limited temporal stability during evaluation and is not intended for production decision-making.
For detailed methodology and evaluation results, see the [Machine Learning Summary](docs/ml_summary.md).


## Key Exploratory Analysis Findings

Exploratory data analysis was conducted on orders purchased between January 2017 and August 2018.
The analysis covered delivery performance, geographical factors, sales trends, and customer satisfaction.

### Delivery Performance

- The median delivery time was **10 days**, with a mean of approximately **12.5 days**.
- Approximately **6.8%** of evaluated deliveries arrived after the estimated delivery date.
- Delivery distance was moderately correlated with actual delivery time (Spearman ρ = 0.543).
- Interstate deliveries generally took longer than deliveries within the same state.

### Delivery Delay Spikes

Three months showed particularly high late delivery rates:

| Month | Late Delivery Rate |
|---|---:|
| November 2017 | 12.40% |
| February 2018 | 14.13% |
| March 2018 | 18.96% |

The increases were associated with changes in transit times, delivery estimates, and shipping-route performance.
The São Paulo → Rio de Janeiro shipping corridor showed particularly substantial deterioration in November 2017 and February 2018.

### Sales Performance

- Monthly total order value increased significantly throughout 2017, reaching approximately **BRL 1.15 million** in November.
- In 2018, monthly order value remained relatively stable at around **BRL 1 million**.
- Average order value was comparatively stable, indicating that changes in total order value were primarily associated with order volume.
- The five largest product categories generated approximately **39.9% of total merchandise value**.

### Customer Satisfaction

- On-time deliveries received an average review score of **4.29/5**, compared with **2.27/5** for late deliveries.
- Low ratings (1–2 stars) occurred in **9.21%** of on-time deliveries and **62.35%** of late deliveries.
- Among late deliveries, delay duration was negatively correlated with customer ratings (Spearman ρ = −0.401, p < 0.001).
- Customer dissatisfaction increased particularly sharply when delivery delays exceeded two days.

### Business Implications

The findings highlight delivery reliability as an important operational priority.
Monitoring should include not only the overall late delivery rate but also delay duration, transit-time distributions, and performance across shipping routes.
All findings are based on observational data and should not be interpreted as evidence of causation.

Detailed analysis, visualizations, and statistical results are available in the [Exploratory Data Analysis Notebook](notebooks/02_exploratory_analysis.ipynb).

## Key Machine Learning Findings

Four classification algorithms were evaluated to predict delivery delays using information available at purchase: Logistic Regression, Random Forest, HistGradientBoosting, and CatBoost.

**Logistic Regression achieved the strongest validation performance** using nine selected features.

### Model Performance

| Metric | Validation | Final Test |
|---|---:|---:|
| PR-AUC | 0.2351 | 0.0752 |
| ROC-AUC | 0.7246 | 0.6365 |
| Precision@10% | 30.82% | 6.63% |
| Lift@10% | 3.05 | 1.38 |

The substantial performance decline on the final test set highlighted limitations in the model's ability to generalize over time.
Temporal backtesting confirmed that predictive performance varied considerably across historical periods.

### Key Predictive Factors

Permutation feature importance identified three leading predictors:

- Estimated delivery days
- Customer state
- Delivery distance

**Business implication:** The model demonstrates some ability to rank orders by delivery delay risk, but its limited temporal stability and unreliable probability estimates prevent its use as a production-ready prediction system.

Detailed methodology and results are available in the [Machine Learning Summary](docs/ml_summary.md) and [Delivery Delay Prediction Notebook](notebooks/03_delivery_delay_prediction.ipynb).

## Power BI Dashboard

The project includes an interactive Power BI dashboard designed to support e-commerce performance analysis, delivery monitoring, and machine learning-based risk prioritization.
The dashboard consists of three pages: **Executive Overview**, **Delivery Performance**, and **Risk Monitoring**.

### Executive Overview

The Executive Overview provides a high-level summary of business performance using historical Olist transactions.

**Key performance indicators:**
- Total Orders
- Delivered Orders
- Total Order Value (BRL)
- Average Order Value (BRL)

**Visualizations:**
- Monthly Order Volume
- Monthly Sales Trend
- Top 5 Product Categories by Units Sold
- Top 5 Product Categories by Sales Value

The product category charts display the five leading categories alongside an aggregated **Other** segment representing all remaining categories. Each chart also shows the number of categories included in the Other group.
Product category sales values exclude freight charges, while Total Order Value includes freight.

### Delivery Performance

The Delivery Performance page focuses on delivery efficiency, timeliness, and geographical patterns.

**Key performance indicators:**
- Average Delivery Days
- Late Delivery Rate

**Visualizations:**
- Monthly Late Delivery Rate
- Late Delivery Rate by Customer State
- Late Deliveries by State — an interactive Azure Maps choropleth displaying the absolute number of delayed deliveries across Brazilian states

The page combines relative measures, such as late delivery rates, with absolute counts to distinguish regions with poor delivery performance from regions with high volumes of delayed orders.

### Interactive Filtering

The Executive Overview and Delivery Performance pages share synchronized filters for purchase date and customer state.
The dashboard supports interactive filtering across KPIs and visualizations, allowing users to investigate performance for selected periods and geographical regions.

### Risk Monitoring

The Risk Monitoring page demonstrates how a previously trained machine learning model can support operational prioritization.
Unlike the historical reporting pages, Risk Monitoring uses **synthetic orders** generated from historical order characteristics.

The page includes:

- **Scored Orders** — number of synthetic orders evaluated by the model.
- **High Risk Orders** — number of orders assigned to the highest-risk group.
- **Scoring Model** — model and version used to generate the scores.
- **Last Scoring** — timestamp of the latest scoring execution.
- **Risk Score Distribution** — distribution of model scores by risk category.
- **Priority Orders** — ranked list of high-risk orders, including customer and seller locations, delivery distance, estimated delivery date, and model score.

The scoring process uses the saved **Logistic Regression (v1)** model.
Orders are ranked by their model scores, with the highest-scoring 10% classified as **High Risk**. The remaining orders are classified as **Other Orders**.
Because the model demonstrated limited temporal stability and unreliable probability calibration, its scores are used for **relative risk ranking**, not as precise probabilities of late delivery.
The Risk Monitoring data is kept separate from historical business data to ensure that simulated orders do not affect historical KPIs.

### Data Model and Integration

The Power BI semantic model uses PostgreSQL analytical views and includes the following tables:

| Table | Purpose |
|---|---|
| `Orders` | Historical order-level business and delivery metrics |
| `ShippingRoutes` | Seller-to-customer shipping route information |
| `CategorySales` | Product category sales and quantities |
| `DimDate` | Calendar dimension for historical time-based analysis |
| `RiskMonitoring` | Synthetic orders with machine learning risk scores and rankings |

Historical tables are connected through defined relationships, while `RiskMonitoring` remains independent.
Power BI uses imported data. After new synthetic orders have been generated and scored in Python, the report must be refreshed to display the updated results.
**Power BI refresh does not automatically execute the machine learning pipeline.**

## Methodological Considerations

Historical analyses use observational Olist data, with explicit definitions of business metrics and data quality checks. Statistical associations are not interpreted as causal relationships.
Delivery delay models were evaluated using chronological data splits and temporal backtesting. Although Logistic Regression achieved the strongest validation performance, its performance declined on the final test set and varied over time.
Risk Monitoring uses synthetic orders generated from historical order characteristics. The highest-scoring 10% are classified as **High Risk**, but model scores are not calibrated probabilities of late delivery.
Synthetic orders are kept separate from historical KPIs. The scoring pipeline runs independently of Power BI, which displays updated results after refreshing the data.
Detailed methodology and limitations are documented in the [Machine Learning Summary](docs/ml_summary.md).

## Technical Documentation

Detailed methodology, analytical findings, and implementation notes are available in the following resources:

| Area | Documentation |
|---|---|
| Data acquisition and import | [Data Setup](data/README.md) |
| Data understanding | [Data Understanding Notebook](notebooks/01_data_understanding.ipynb) |
| Data quality | [Data Quality Summary](docs/data_quality_summary.md) |
| Exploratory and statistical analysis | [EDA Summary](docs/eda_summary.md) · [EDA Notebook](notebooks/02_exploratory_analysis.ipynb) |
| Machine learning | [ML Summary](docs/ml_summary.md) · [ML Notebook](notebooks/03_delivery_delay_prediction.ipynb) |
| Power BI Dashboard | [Power BI Dashboard Documentation](docs/powerbi_dashboard.md) |
| Risk Monitoring | [Risk Monitoring Pipeline](docs/risk_monitoring_pipeline.md) |
| Business Insights | [Key Business Insights & Recommendations](reports/business_insights_and_recommendations.md) |

## Data Attribution

Data source: Olist — Brazilian E-Commerce Public Dataset, available on Kaggle.

The dataset is distributed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International license.

This repository is an independent educational portfolio project and is not affiliated with Olist.