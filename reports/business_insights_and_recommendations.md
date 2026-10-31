# Key Business Insights & Recommendations

## Executive Summary

The analysis of Olist e-commerce transactions (January 2017 – August 2018) identified delivery reliability as a key operational concern, strongly associated with customer satisfaction.
Sales performance was primarily driven by order volume, while delivery delays varied considerably across periods and shipping routes.

## Key Business Insights

**1. Delivery delays were concentrated in specific periods.**

Approximately **6.8% of assessed orders** were delivered late. However, late delivery rates increased to **12.40% in November 2017**, **14.13% in February 2018**, and **18.96% in March 2018**, indicating substantial fluctuations in delivery performance.

**2. Late deliveries were associated with significantly lower customer satisfaction.**

On-time deliveries received an average review score of **4.29/5**, compared with **2.27/5** for late deliveries. Negative reviews (1–2 stars) occurred in **62.35% of late deliveries**, versus **9.21% of on-time deliveries**.

**3. Extended delays were particularly problematic.**

The negative review rate increased from **25.54% for delays of 1–2 days** to **63.77% for delays of 3–7 days**, suggesting that preventing longer delays should be an operational priority.

**4. Delivery performance varied across shipping routes.**

Interstate deliveries had a median delivery time of **13 days**, compared with **7 days** for same-state deliveries. The **São Paulo → Rio de Janeiro** corridor showed recurring deterioration during major delay periods.

**5. Sales growth was primarily volume-driven.**

Monthly order value increased substantially throughout 2017, reaching approximately **BRL 1.15 million in November**. Average order value remained relatively stable. The five leading product categories generated approximately **39.9% of merchandise value**.

## Business Recommendations

**1. Monitor delivery reliability beyond the late delivery rate.**

Track delivery duration, transit times, delivery margins, and severe delays to detect operational deterioration earlier.

**2. Prioritize investigation of problematic shipping routes.**

Regularly review interstate deliveries and corridors with recurring delays, particularly São Paulo → Rio de Janeiro.

**3. Reduce the frequency of extended delays.**

Focus operational attention on shipments at risk of exceeding their estimated delivery dates by more than two days, where negative customer feedback becomes substantially more frequent.

**4. Use predictive models cautiously.**

The Logistic Regression model demonstrated limited and unstable risk-ranking performance on unseen periods. Its outputs may support exploratory prioritization but should not drive automated operational decisions without further validation.

## Conclusion

Delivery reliability is an important area for operational improvement. Combining delivery KPIs, geographical analysis, customer feedback, and cautious risk monitoring can help identify where further investigation may provide the greatest business value.

These findings are based on observational historical data and do not establish causal relationships.

For detailed evidence, see the [EDA Summary](../docs/eda_summary.md) and [ML Summary](../docs/ml_summary.md).