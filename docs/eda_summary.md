# Exploratory Data Analysis — Summary

## 1. Overview

This document summarizes the main findings from the exploratory data analysis of the Brazilian E-Commerce Public Dataset by Olist.

The analysis focuses on three business areas:

1. Delivery performance and operational efficiency
2. E-commerce sales performance
3. Customer satisfaction and delivery reliability

**Analysis period:** January 2017 – August 2018. The selected period excludes the incomplete final months of the dataset.

Detailed calculations, statistical tests, and visualizations are available in [02_exploratory_analysis.ipynb](../notebooks/02_exploratory_analysis.ipynb).

---

## 2. Delivery Performance

### Delivery Time Distribution

Delivery times were right-skewed, with a relatively small proportion of orders experiencing exceptionally long delivery times.

| Metric | Value |
|---|---:|
| Mean delivery time | 12.48 days |
| Median delivery time | 10 days |
| 75th percentile | 16 days |
| 90th percentile | 23 days |
| 95th percentile | 29 days |
| 99th percentile | 46 days |

Estimated delivery dates were generally conservative compared with actual delivery times. However, this did not prevent substantial delays for a subset of orders.

### Geographical Factors

Shipping distance and delivery type were associated with delivery performance.

- **Distance vs. actual delivery time:** Spearman ρ = 0.543.
- **Distance vs. estimated delivery time:** Spearman ρ = 0.623.
- **Distance vs. late delivery status:** Spearman ρ = 0.070.

Distance was considerably more strongly associated with delivery duration than with the probability of exceeding the estimated delivery date.

For single-seller orders:

| Metric | Same-State | Interstate |
|---|---:|---:|
| Median delivery time | 7 days | 13 days |
| Late delivery rate | 4.57% | 8.16% |

Interstate deliveries generally took longer and were more likely to arrive after the estimated date. These associations do not establish causality.

---

## 3. Investigation of Delivery Delay Spikes

Three purchase months showed particularly high late delivery rates:

| Month | Late Delivery Rate |
|---|---:|
| November 2017 | 12.40% |
| February 2018 | 14.13% |
| March 2018 | 18.96% |

### November 2017

Compared with October 2017:

- Median delivery time increased from 10 to 13 days.
- The 90th percentile of delivery time increased from 20 to 27 days.
- Both order processing and transit times increased.
- The São Paulo → Rio de Janeiro shipping corridor showed substantial deterioration.

The results indicate a broad worsening of delivery performance, particularly in slower deliveries.

### February 2018

Compared with January 2018:

- Median delivery time increased from 12 to 14 days.
- The 90th percentile increased from 25 to 31 days.
- Median transit time increased from 8.04 to 11.02 days.
- Delivery performance deteriorated substantially on the São Paulo → Rio de Janeiro route.

Longer transit times were a prominent characteristic of this period.

### March 2018

Compared with February 2018:

- Median delivery time decreased from 14 to 13 days.
- The 90th percentile of delivery time increased from 31 to 32 days.
- The median estimated delivery window decreased from 25 to 22 days.
- The median delivery margin decreased from 10 to 8 days.

These findings suggest that shorter estimated delivery windows and longer durations among the slowest shipments were associated with the increased late delivery rate.

### Regional, Product, and Seller Patterns

Additional analysis examined customer states, product categories, sellers, and shipping routes.
Delivery performance deteriorated across multiple regions and product categories.
Some sellers showed recurring increases in late delivery rates, but delays were not restricted to a single seller or product category.

The ten sellers with the highest numbers of delayed orders accounted for:

| Month | Share of Orders | Share of Late Orders |
|---|---:|---:|
| November 2017 | 16.15% | 29.27% |
| February 2018 | 14.17% | 21.51% |
| March 2018 | 15.19% | 19.79% |

The results suggest greater concentration among the leading sellers in November and a more distributed pattern of delays in March.

**Overall finding:** The three delivery delay spikes were associated with different combinations of operational and geographical factors. No single underlying cause was established.

---

## 4. Sales Performance

### Monthly Sales Trends

The total value of delivered orders increased considerably throughout 2017.

The highest monthly value was recorded in November 2017:

| Metric | November 2017 |
|---|---:|
| Delivered orders | 7,289 |
| Total order value | BRL 1,153,364 |
| Average order value | BRL 158.23 |

During 2018, monthly total order value remained relatively stable at approximately BRL 1 million.
Average order value fluctuated within a comparatively narrow range throughout the analysis period.

**Key finding:** Changes in total order value were primarily associated with changes in order volume rather than substantial changes in average order value.

Total order value includes product prices and freight charges. It should not be interpreted as formally recognized accounting revenue.

### Product Category Performance

The five leading product categories by merchandise value were:

| Product Category | Share of Merchandise Value |
|---|---:|
| Health & Beauty | 9.33% |
| Watches & Gifts | 8.83% |
| Bed, Bath & Table | 7.76% |
| Sports & Leisure | 7.23% |
| Computers & Accessories | 6.74% |

Together, these categories generated approximately **39.9% of total merchandise value**.
The ten largest categories accounted for approximately **62.5%**.
Sales were distributed across multiple product categories, although the leading categories accounted for a substantial share of total merchandise value.
Merchandise value excludes freight charges.

---

## 5. Customer Satisfaction

### Delivery Status and Review Scores

Customer reviews showed a substantial association between delivery punctuality and customer satisfaction.

| Metric | On Time | Late |
|---|---:|---:|
| Orders | 89,672 | 6,531 |
| Mean review score | 4.29 | 2.27 |
| Median review score | 5 | 1 |
| Low review rate (1–2 stars) | 9.21% | 62.35% |
| Review coverage | 99.45% | 97.66% |

Late deliveries received substantially lower customer ratings.
The Spearman correlation between late delivery status and review score was:
**ρ = −0.312, p < 0.001**

### Delay Duration and Customer Ratings

Among late deliveries, longer delays were associated with lower customer ratings.
**Spearman ρ = −0.401, p < 0.001**

| Delay Duration | Mean Review Score | Low Review Rate |
|---|---:|---:|
| 1–2 days | 3.51 | 25.54% |
| 3–7 days | 2.23 | 63.77% |
| 8–14 days | 1.67 | 80.08% |
| 15+ days | 1.73 | 78.17% |

The largest increase in negative ratings occurred between delays of 1–2 days and delays of 3–7 days.
Ratings remained very low for longer delays, although the relationship was not strictly monotonic across all delay groups.

### Monthly Customer Satisfaction

On-time deliveries maintained relatively stable average ratings of approximately 4.2–4.4 throughout the analysis period.
Late deliveries consistently received lower ratings.
The strongest monthly negative correlations between late delivery status and review scores occurred during the major delivery delay spikes:

| Month | Spearman ρ |
|---|---:|
| November 2017 | −0.403 |
| February 2018 | −0.466 |
| March 2018 | −0.493 |

The magnitude of these monthly correlations is also influenced by the proportion of delayed orders and should not be interpreted as a direct measure of the causal impact of lateness.

**Key finding:** Delivery reliability and delay duration were consistently associated with customer satisfaction.

---

## 6. Business Recommendations

### Monitor Both Delay Frequency and Severity

The late delivery rate alone does not fully describe operational performance.

Monitoring should also include:

- Median and upper-percentile delivery times
- Transit times
- Delay duration
- Delivery margins relative to estimated dates

### Investigate Underperforming Shipping Routes

Shipping-route performance should be monitored regularly.
The São Paulo → Rio de Janeiro corridor warrants particular investigation because of recurring delivery deterioration in November 2017 and February 2018.

### Prioritize the Prevention of Extended Delays

Delays exceeding two days were associated with substantially higher rates of negative reviews.
Operational monitoring could therefore distinguish short delays from longer and more severe delays.

### Monitor Customer Experience Alongside Delivery KPIs

Customer ratings and low-review rates should be considered alongside delivery performance metrics.
This would help identify periods in which operational deterioration coincides with negative customer experiences.
These recommendations identify areas for further investigation rather than proven causal interventions.

---

## 7. Limitations

The analysis is based on historical observational data and does not establish causal relationships.

Key limitations include:

- **Geographical approximation:** Shipping distances were estimated from ZIP-code-prefix coordinates using straight-line distances rather than actual transport routes.
- **Single-seller restriction:** Some geographical and seller-level analyses excluded multi-seller orders.
- **Data quality:** Missing values and date-sequence anomalies were identified and handled according to the requirements of individual analyses.
- **Review interpretation:** Customer ratings may reflect product quality, seller communication, and other factors beyond delivery punctuality.
- **Multiple reviews:** Orders with multiple reviews were represented using the average review score at the order level.
- **Historical scope:** Findings describe the selected period and may not generalize to current e-commerce operations.

Statistical significance should not be confused with practical significance or causal evidence.
