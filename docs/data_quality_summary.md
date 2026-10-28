# Data Quality Summary

## Referential Integrity

All tested foreign key relationships were valid, except for missing product category translations.

## Identified Data Quality Issues

| Issue | Records |
|---|---:|
| Delivered orders without delivery dates | 8 |
| Canceled orders with delivery dates | 6 |
| Shipping recorded before purchase | 166 |
| Delivery recorded before shipping | 23 |
| Orders without items | 775 |
| Orders without payments | 1 |
| Orders without reviews | 768 |
| Products without category translations | 13 |
| Customers without geolocation matches | 278 |
| Sellers without geolocation matches | 7 |
| ZIP prefixes associated with multiple states | 8 |

## Delivery Date Anomaly

An unusually high concentration of extreme delivery delays was identified on September 19, 2017.

On that date:
- 282 deliveries were recorded.
- 21 orders were delivered more than 90 days after their estimated delivery date.
- The date had the highest daily delivery volume in September 2017.

This pattern may indicate a batch update of delivery records, but the available data does not allow the cause to be confirmed.

## Data Preparation Decisions

- Original source tables remain unchanged.
- Inconsistent date sequences are identified using a quality flag.
- Missing delivery dates are not interpreted as late deliveries.
- Missing product category translations are handled without removing products.
- Geographical coordinates are aggregated to the ZIP prefix level using median coordinates.
- Order items are aggregated to the order level before joining with delivery data.
- Extreme delivery delays are retained for further analysis.

## Validation

The analytical views preserve the expected record counts.

Joining the order-level sales and delivery views does not introduce duplicate orders.