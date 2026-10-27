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