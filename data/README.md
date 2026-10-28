# Data Source and Acquisition

## Dataset Information

**Dataset:** Brazilian E-Commerce Public Dataset by Olist

**Source:** Kaggle

**Provider:** Olist

**URL:** https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

**License:** CC BY-NC-SA 4.0

The dataset contains anonymized information about approximately 100,000 e-commerce orders placed between 2016 and 2018.
It includes transactional, customer, seller, product, payment, review, and geographical information.

## Source Files

The dataset consists of nine CSV files.

| File | Description |
|---|---|
| `olist_orders_dataset.csv` | Order status and purchase, shipping, and delivery timestamps |
| `olist_order_items_dataset.csv` | Products and sellers associated with orders |
| `olist_customers_dataset.csv` | Customer identifiers and locations |
| `olist_products_dataset.csv` | Product characteristics and categories |
| `olist_sellers_dataset.csv` | Seller identifiers and locations |
| `olist_order_payments_dataset.csv` | Payment methods and payment values |
| `olist_order_reviews_dataset.csv` | Customer reviews and ratings |
| `olist_geolocation_dataset.csv` | Geographical coordinates and postal code information |
| `product_category_name_translation.csv` | Product category translations |

## Local Data Structure

The project uses the following directories:

- `data/raw/` — original source files
- `data/processed/` — datasets generated during data preparation

Both directories are excluded from Git version control.

## Data Reproducibility

The source files are not distributed through this repository.
Database creation, data import, transformation, and validation scripts will be documented in the project.
These resources will allow the analytical workflow to be reproduced using the original dataset.

## Data Quality

Data quality checks will be performed during the database preparation stage.
The assessment will include missing values, duplicate records, key relationships, date consistency, and other relevant validation rules.
Any cleaning decisions and assumptions will be documented separately.

## Attribution and License

The dataset was published by Olist and is available through Kaggle under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International license.
The data is used for an independent educational portfolio project.

## PostgreSQL Data Import

The Olist datasets were imported into PostgreSQL 18 using a reproducible SQL script executed through `psql`.

### Database Setup

1. Create the database using `sql/01_create_database.sql`.
2. Connect to the `olist_ecommerce` database.
3. Create the tables using `sql/02_create_tables.sql`.
4. Download the original CSV files and place them in `data/raw/`.

### Import Execution

Run the following command from the project root directory in PowerShell:

```powershell
& "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d olist_ecommerce -v ON_ERROR_STOP=1 -1 -f sql/03_import_data.sql
```

The script imports all nine original datasets.

**Note:** The import script truncates the source tables before loading the data. It should only be rerun when a complete data reload is intended.

### Import Validation

The import was successfully completed and verified.
All nine PostgreSQL tables contain the expected number of records, matching the original CSV files.
Referential integrity and data quality checks are available in `sql/04_data_quality_checks.sql`.
Foreign key constraints are defined in `sql/05_add_foreign_keys.sql`.
The original source data remains unchanged.