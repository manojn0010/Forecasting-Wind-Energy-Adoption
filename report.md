# Forecasting Wind Energy Adoption in Europe — Analysis Report

## Abstract
This project presents a structured time series analysis and forecasting study of wind energy adoption in Europe. Installed wind capacity is used as a proxy for adoption, capturing long-term growth in renewable energy deployment.

The analysis integrates exploratory data assessment with statistical modelling to evaluate both temporal dynamics and the role of economic drivers. While variables such as electricity demand, gas prices, and wind cost exhibit meaningful relationships with wind capacity, model validation shows that a pure time series approach provides superior forecasting performance. The final model is selected based on out-of-sample accuracy and used to generate multi-period forecasts.

---
### Objectives

- Analyse growth trends in wind energy adoption in Europe  
- Evaluate relationships between wind capacity and key economic drivers  
- Compare regression, ARIMA, and ARIMAX modelling approaches  
- Identify the most accurate forecasting model using validation  
- Generate forward projections of wind energy adoption  

---
### Dataset Description

- **Region:** Europe  
- **Frequency:** Annual  
- **Period:** 1997–2022 (26 observations)  

#### Variables Used

| Variable | Description |
|---|---|
| Wind capacity (GW) | Installed capacity (proxy for adoption) |
| Electricity generation (TWh) | Demand proxy |
| Gas price ($/MMBtu) | Competing energy cost |
| Wind LCOE ($/MWh) | Technology cost indicator |

The dataset is constructed from multiple sources and integrated into a unified analytical dataset.

---
### Exploratory Analysis

- Trend Behaviour  

Wind capacity exhibits strong upward, non-linear growth, indicating accelerating adoption over time. Electricity generation shows a gradual increase, while wind LCOE declines steadily, reflecting cost improvements. Gas prices display volatility without a consistent long-term trend.

- Correlation Structure  

| Relationship | Observation |
|-------------|------------|
| Wind vs LCOE | Strong negative |
| Wind vs Electricity | Moderate positive |
| Wind vs Gas | Weak to moderate |

> Log transformation is applied to stabilise variance and better capture exponential growth dynamics. Log-based relationships confirm strong inverse association with cost and positive association with demand.

---
### Stationarity and Transformation

Statistical tests indicate that all variables are non-stationary in levels:

- ADF tests fail to reject unit roots  
- KPSS tests reject stationarity  

To address this:
- Log transformation is applied  
- First differencing is used to remove trend components  

> Autocorrelation analysis (ACF/PACF) reveals strong persistence in wind capacity, supporting the use of ARIMA-type models.

---
### Modelling Framework

**Regression Models**  

Log-log regression models show strong explanatory power (Adjusted R² ≈ 0.95).

Key findings:
- Wind LCOE has a strong negative and statistically significant effect  
- Electricity generation has a strong positive and significant effect  
- Gas prices are statistically insignificant  

> However, residual autocorrelation violates time series assumptions, making regression unsuitable for forecasting.

**ARIMAX Models**  

ARIMAX models incorporate external drivers within a time series framework.

- Full model includes all drivers  
- Reduced model excludes gas price  

> Despite capturing both temporal and economic effects, these models perform poorly in out-of-sample forecasting.

**ARIMA Model**  

A univariate ARIMA model is fitted on log-transformed wind capacity.

- Selected specification: **ARIMA(0,2,0)**  
- Captures strong trend dynamics through differencing  

---
### Model Validation

Models are evaluated using an 80–20 train-test split.

#### Forecast Accuracy (Test Set)

| Model | RMSE |
|------|------|
| ARIMA | 0.0634 |
| ARIMAX (Reduced) | 0.2026 |
| ARIMAX (Full) | 1.5205 |

#### Key Result

- ARIMA significantly outperforms ARIMAX models  
- Inclusion of exogenous variables degrades forecasting accuracy  

> Final model selected: **ARIMA(0,2,0)**  

---
### Forecast Results

The final model (ARIMA) is used to generate forecasts for wind capacity over an 8-year horizon (2023–2030).

**Forecast Estimates**

| Year | Forecast (GW) |
|------|--------------|
| 2023 | 272.89 |
| 2024 | 295.95 |
| 2025 | 320.96 |
| 2026 | 348.09 |
| 2027 | 377.50 |
| 2028 | 409.40 |
| 2029 | 443.99 |
| 2030 | 481.52 |

**Forecast Plot**

![](outputs/forecast/forecast_plot.png)

> The forecasts indicate continued growth in wind energy adoption across Europe.  
> Uncertainty intervals widen over time due to cumulative forecasting error.

---
## Key Insights

- **Time series dynamics dominate forecasting performance**  
- **Economic drivers are explanatory but do not improve prediction accuracy**  
- **Gas prices have negligible influence in this dataset**  
- **Wind adoption exhibits strong persistence and trend-driven growth**  

---
## Limitations
- Small sample size (26 observations)  
- Annual frequency limits short-term dynamics  
- Residual autocorrelation remains in ARIMA model  
- Exogenous variables excluded from final forecast  
- Forecast uncertainty increases over longer horizons  

---
## Conclusion

This project demonstrates a structured forecasting workflow combining exploratory analysis, statistical modelling, and validation. While economic drivers provide useful explanatory context, the results show that time series modelling alone offers the most reliable forecasts for wind energy adoption in this dataset.

---
## References and Sources
