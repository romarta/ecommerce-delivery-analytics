# E-commerce Performance & Delivery Analytics

### End-to-End Business Analytics with PostgreSQL, Python, Machine Learning & Power BI

**Project Status:** SQL, Data Quality, Exploratory Analysis & Machine Learning Completed — Power BI Next

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

The project uses the following tools and technologies, including those planned for later stages:

| Tool | Purpose |
|---|---|
| PostgreSQL | Relational database and SQL transformations |
| SQL | Data validation, integration, and business metrics |
| Python | Data preparation and statistical analysis |
| JupyterLab | Exploratory analysis and analytical documentation |
| pandas / NumPy | Data manipulation |
| scipy / statsmodels | Statistical inference |
| scikit-learn | Predictive modeling and evaluation |
| CatBoost | Gradient boosting classification |
| joblib | Machine learning model serialization |
| Power BI | Business intelligence dashboards |
| Git / GitHub | Version control and project documentation |


## Project Workflow

The project is organized into the following stages:

1. Project setup and data acquisition
2. Data understanding and analytical planning
3. PostgreSQL database development
4. Data quality assessment and SQL transformations
5. Exploratory data analysis
6. Statistical analysis
7. Delivery delay prediction
8. Power BI dashboard development
9. Business recommendations and final reporting

## Repository Structure

| Directory | Description |
|---|---|
| `data/` | Data source documentation and local data directories |
| `sql/` | Database creation, validation, transformation, and analytical SQL scripts |
| `notebooks/` | Exploratory, statistical, and machine learning analyses |
| `models/` | Exported machine learning models |
| `src/` | Reusable Python scripts |
| `docs/` | Analytical methodology, data quality documentation, and supporting materials |
| `powerbi/` | Power BI reports and dashboard screenshots |
| `reports/` | Executive summary and business recommendations |

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


## Methodological Considerations

The project uses historical observational data. Statistical associations are not interpreted as causal relationships.
Sales metrics, delivery performance indicators, and analytical populations are explicitly defined and documented.
Data quality assessment addresses relational data granularity, missing values, and order statuses.
Predictive modeling uses chronological data splits and outcome availability checks to reduce future-label leakage. Model evaluation includes baseline comparisons, final test assessment, and temporal backtesting.
Limitations related to selection bias, temporal instability, and probability calibration are documented.

## Project Deliverables

### Completed

- PostgreSQL database setup and data import scripts
- SQL data validation, transformations, and analytical views
- Data quality assessment and documentation
- Exploratory data analysis in Python and JupyterLab
- Statistical analysis of delivery performance and customer satisfaction
- Initial business findings and operational recommendations
- Machine learning model development and comparison
- Hyperparameter tuning and feature selection
- Chronological model evaluation and temporal backtesting
- Model interpretation and performance documentation
- Exported Logistic Regression pipeline

### Planned

- Interactive Power BI dashboard
- Final business report and recommendations
- Updated end-to-end reproduction instructions

## Project Status

**Current Stage: Machine Learning Completed**

The SQL, data quality, exploratory analysis, and machine learning stages have been completed.

The predictive modeling stage included algorithm comparison, feature selection, chronological evaluation, temporal backtesting, and model interpretation.

The final test revealed substantial limitations in model generalization and probability calibration. These findings are documented in the Machine Learning Summary.

**Next Stage: Power BI**

The next phase will focus on developing an interactive dashboard presenting business KPIs, sales trends, delivery performance, geographical patterns, and customer satisfaction.

The dashboard will also incorporate relevant findings from the delivery delay prediction analysis.

## Technical Documentation

- [Database Import Instructions](sql/03_import_data.md)
- [Data Quality Summary](docs/data_quality_summary.md)
- [Data Understanding Notebook](notebooks/01_data_understanding.ipynb)
- [Exploratory Data Analysis Notebook](notebooks/02_exploratory_analysis.ipynb)
- [Exploratory Data Analysis Summary](docs/eda_summary.md)
- [Delivery Delay Prediction Notebook](notebooks/03_delivery_delay_prediction.ipynb)
- [Machine Learning Summary](docs/ml_summary.md)

## Data Attribution

Data source: Olist — Brazilian E-Commerce Public Dataset, available on Kaggle.

The dataset is distributed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International license.

This repository is an independent educational portfolio project and is not affiliated with Olist.