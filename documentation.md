# Project Documentation  
**Project:** Forecasting Wind Energy Adoption  
**Scope:** This document is intended for technical reviewers and focuses on data processing, modelling logic, and time series methodology rather than interpretative findings.

---
## Overview  
This document provides technical documentation for the wind energy forecasting pipeline. The project models and forecasts installed wind capacity in Europe using time series techniques, with exploratory evaluation of economic drivers.

The workflow is divided into:

1. Data ingestion and construction  
2. Exploratory data analysis  
3. Stationarity testing and transformation  
4. Feature engineering  
5. Model construction  
6. Diagnostic validation  
7. Model validation (train-test)  
8. Final forecasting  

The objective is to identify an appropriate forecasting model through structured comparison across regression, ARIMA, and ARIMAX specifications.

---
### Data Construction Logic  

> Implemented in `01_data_construction.R`

#### Raw Data Sources  
The dataset is constructed from multiple raw files containing:

- Wind installed capacity (MW)  
- Electricity generation (TWh)  
- Natural gas prices (Europe)  
- Onshore wind LCOE  

#### Transformation Steps  

- Wide-to-long reshaping using `pivot_longer()`  
- Standardisation of variable names  
- Conversion of all variables to numeric format  
- Unit transformations:
  - Wind: MW → GW  
  - LCOE: $/kWh → $/MWh  

#### Data Integration  

Datasets are merged on `year` using sequential `left_join()` operations.

#### Data Quality  

- Missing values introduced during type coercion (gas prices)  
- No duplicate observations detected  
- Final dataset spans **1997–2022 (26 observations)**  

Output saved to:  
`data/clean/master_dataset.csv`

---
### Exploratory Data Analysis  

> Implemented in `02_eda.R`

#### Time Series Behaviour  

- Wind capacity exhibits strong upward (non-linear) growth  
- Electricity generation shows moderate upward trend  
- LCOE shows declining trend over time  
- Gas prices display volatility  

#### Correlation Structure  

| Variable Pair | Correlation |
|--------------|------------|
| Wind – LCOE | Strong negative |
| Wind – Electricity | Moderate positive |
| Wind – Gas | Moderate positive |

#### Log Transformation  

Log transformation is applied to:
- Stabilise variance  
- Linearise exponential growth  

Log-based scatter plots indicate:
- Strong linear relationship between log(wind) and log(LCOE)  
- Positive association with electricity  
- Weak relationship with gas  

---
### Stationarity Testing  

> Implemented in `03_stationarity_tests.R`

#### Level Series  

- ADF tests fail to reject non-stationarity  
- KPSS tests reject stationarity  

> All series treated as **non-stationary in levels**

#### Transformations  

- Log transformation applied  
- First differencing applied to log series  

#### Transformed Series  

- Mixed results in ADF tests  
- KPSS indicates improved stationarity (especially for gas and LCOE)

#### ACF and PACF  

- Significant autocorrelation observed in wind series  
- Suggests need for differencing and ARIMA-type modelling  

---
### Feature Engineering  

> Implemented in `04_feature_engineering.R`

#### Constructed Variables  

- `log_wind`  
- `log_electricity`  
- `log_gas`  
- `log_lcoe`  

#### Dataset Preparation  

- Retains only modelling-relevant columns  
- Ensures consistency across modelling scripts  

Output saved to:  
`data/processed/model_df.csv`

---
### Model Construction  

> Implemented in `05_model_fitting.R`

#### Time Series Setup  

- Target variable: `log_wind`  
- Annual frequency (`frequency = 1`)  

#### Model Classes Evaluated  

**1. ARIMA** 

- Automatically selected using `auto.arima()`  
- Final specification: **ARIMA(0,2,0)**  

**2. ARIMAX**  

Two specifications:

- *Full model:*  
  - log_lcoe  
  - log_electricity  
  - log_gas  

- *Reduced model:*  
  - log_lcoe  
  - log_electricity  

**3. Regression Models** 

- Log-log functional form  
  - *Full model:* log_wind ~ log_lcoe + log_electricity + log_gas  
  - *Reduced:* log_wind ~ log_lcoe + log_electricity  

#### Model Insights  

- Gas price is statistically insignificant (p ≈ 0.93)  
- Reduced regression model retains explanatory power  
- Multicollinearity not severe (VIF < 2)

---
### Diagnostic Validation  

> Implemented in `06_model_diagnostics.R`

#### Time Series Models  

- ARIMA residuals:
  - Ljung-Box p-value < 0.01  
> residual autocorrelation present  

- ARIMAX (full):
  - borderline residual independence  

- ARIMAX (reduced):
  - residual autocorrelation persists  

#### Regression Models  

Tests performed:
- Breusch-Pagan (heteroskedasticity)  
- Durbin-Watson (autocorrelation)  
- Shapiro-Wilk (normality)  

Findings:
- No strong heteroskedasticity  
- Residuals approximately normal  
- Strong autocorrelation detected  

> Regression models unsuitable for time series forecasting  

---
### Model Validation  

> Implemented in `07_model_validation.R`

#### Train-Test Split  

- 80–20 split (due to limited sample size)  
- Validation performed on log scale  

#### Forecast Accuracy (Test Set)

| Model | RMSE |
|------|------|
| ARIMA | 0.0634 |
| ARIMAX (Reduced) | 0.2026 |
| ARIMAX (Full) | 1.5205 |

#### Key Result  

- ARIMA significantly outperforms ARIMAX models  
- Inclusion of exogenous variables degrades forecasting accuracy  

---
### Final Forecast  

> Implemented in `08_final_forecast.R`

#### Model Used  
**ARIMA(0,2,0)** fitted on full dataset  

#### Forecast Setup  

- Horizon: **8 years**  
- Forecast generated in log scale  
- Back-transformed using exponential function  

#### Forecast Output  

Forecast Values:

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

Forecast Plot:

![](outputs/forecast/forecast_plot.png)  
- Uncertainty intervals widen over time due to cumulative forecasting error.

---
## Assumptions and Limitations  

- Time series assumed to follow ARIMA structure  
- Forecasting performed on log-transformed data  
- Exogenous variables treated as optional (not included in final model)  
- Small sample size (26 observations) limits model complexity  
- No seasonal component (annual data)  
- Residual autocorrelation present in ARIMA model  
- Forecast uncertainty increases over horizon  

---
## References  

*To be added*
