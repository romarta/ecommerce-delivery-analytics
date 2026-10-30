# Delivery Delay Prediction — ML Summary

## 1. Objective

The goal was to predict late deliveries using information available at the time of purchase and identify orders requiring closer operational monitoring.

The analysis used **96,203 delivered orders** from the Olist Brazilian E-Commerce dataset.

A chronological train/validation/test split was applied to reflect real-world prediction conditions and reduce future-label leakage.

The complete modeling workflow is available in [`03_delivery_delay_prediction.ipynb`](../notebooks/03_delivery_delay_prediction.ipynb).

## 2. Model Selection

Four classification algorithms were evaluated:

- Logistic Regression
- Random Forest
- HistGradientBoosting
- CatBoost

**Logistic Regression achieved the strongest validation performance.**

The selected configuration used `C=0.1` and nine features, excluding purchase-time variables and detailed product characteristics.

### Validation vs. Final Test

| Metric | Validation | Final Test |
|---|---:|---:|
| PR-AUC | 0.2351 | 0.0752 |
| ROC-AUC | 0.7246 | 0.6365 |
| Precision@10% | 30.82% | 6.63% |
| Recall@10% | 30.54% | 13.81% |
| Lift@10% | 3.05 | 1.38 |

The substantial decline in test performance indicates that validation results were overly optimistic.
On the final test set, the highest-risk 10% of orders had a **6.63% delay rate**, compared with **4.81% overall**.

## 3. Temporal Backtesting

Expanding-window backtesting was conducted to assess performance across different historical periods.

| Evaluation Period | ROC-AUC | Lift@10% |
|---|---:|---:|
| 2017-Q4 | 0.6110 | 1.69 |
| 2018-Q1 | 0.7073 | 2.88 |
| 2018-Q2 | 0.7781 | 3.65 |
| Jul–Aug 2018 | 0.6296 | 1.83 |

**Model effectiveness varied substantially over time.** Increasing the amount of training data did not consistently translate into stronger performance, although evaluation conditions also changed.

Probability estimates were also unreliable. On the original final test set, Logistic Regression achieved a Brier Score of **0.0469**, compared with **0.0458** for the constant-probability baseline.

## 4. Key Predictive Factors

Permutation feature importance identified three leading predictors:

| Feature | Mean PR-AUC Decrease |
|---|---:|
| Estimated delivery days | 0.0650 |
| Customer state | 0.0610 |
| Delivery distance | 0.0555 |

Longer promised delivery windows were associated with lower predicted delay risk, while greater delivery distances were associated with higher risk.
These relationships are predictive associations, not evidence of causation.

## 5. Conclusions and Limitations

The model demonstrates some ability to prioritize orders by relative delivery risk, but **its performance is not sufficiently stable for reliable operational deployment**.

Key limitations include:

- Significant differences between validation and test performance.
- Changes in delivery delay rates and model effectiveness over time.
- Poor probability calibration.
- Potential selection bias from using only delivery outcomes known at each training cutoff.
- Repeated use of the same validation period for model selection and tuning.

**Business recommendation:** Use the model for exploratory risk ranking and logistics analysis rather than automated operational decisions.

Further out-of-time validation and performance monitoring would be required before production use.