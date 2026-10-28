# E-commerce Performance & Delivery Analytics

### End-to-End Business Analytics with PostgreSQL, Python, Machine Learning & Power BI

**Project Status:** SQL Data Preparation Completed — Exploratory Data Analysis Next

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

The planned analytical workflow uses:

| Tool | Purpose |
|---|---|
| PostgreSQL | Relational database and SQL transformations |
| SQL | Data validation, integration, and business metrics |
| Python | Data preparation and statistical analysis |
| JupyterLab | Exploratory analysis and analytical documentation |
| pandas / NumPy | Data manipulation |
| scipy / statsmodels | Statistical inference |
| scikit-learn | Predictive modeling and evaluation |
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
| `src/` | Reusable Python scripts |
| `docs/` | Analytical methodology, data quality documentation, and supporting materials |
| `powerbi/` | Power BI reports and dashboard screenshots |
| `reports/` | Executive summary and business recommendations |

## Methodological Considerations

The project uses historical observational data. Statistical associations will not be interpreted as causal relationships.

Sales metrics, delivery performance indicators, and analytical populations will be explicitly defined and documented.

Special attention will be given to relational data granularity, missing values, order statuses, and the prevention of data leakage in predictive modeling.

Predictive models will be evaluated using appropriate validation strategies and compared against baseline approaches.

## Project Deliverables

The planned deliverables include:

- A reproducible PostgreSQL database setup
- Documented SQL transformations and analytical queries
- Data quality assessment
- Exploratory data analysis
- Statistical hypothesis testing
- Delivery delay prediction models
- Interactive Power BI dashboard
- Business findings and recommendations
- Reproduction instructions

## Project Status

The project is currently in the setup and data acquisition phase. Analysis results, visualizations, model evaluation, 
and business recommendations will be added as the project progresses.

## Technical Documentation

- [Database Import Instructions](sql/03_import_data.md)
- [Data Quality Summary](docs/data_quality_summary.md)

## Data Attribution

Data source: Olist — Brazilian E-Commerce Public Dataset, available on Kaggle.

The dataset is distributed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International license.

This repository is an independent educational portfolio project and is not affiliated with Olist.