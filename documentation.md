# Project Documentation  
**Project:** Forecasting Wind Energy Adoption  
**Scope:** This document is intended for technical reviewers and focuses on modelling logic, data transformations, and statistical validation. Interpretative findings and results are presented in `report.md`.

---
## Overview  
This document provides technical documentation for the wind energy forecasting pipeline. The project models installed wind capacity in Europe using time series techniques, with exploratory evaluation of economic drivers.

The workflow is divided into:

1. Data ingestion and construction  
2. Exploratory analysis  
3. Stationarity testing and transformation  
4. Feature engineering  
5. Model construction  
6. Diagnostic validation  
7. Model validation (train-test)  
8. Final forecasting  

The objective is to identify a suitable forecasting model through structured comparison of regression, ARIMA, and ARIMAX approaches.

---
### Data Construction Logic  
> Implemented in `01_data_construction.R`
#### Raw Data Sources  

The dataset is compiled from multiple raw files containing:

- Wind installed capacity (MW)  
- Electricity generation (TWh)  
- Natural gas prices (Europe)  
- Onshore wind LCOE  

#### Transformation Steps  

- Wide-to-long reshaping using `pivot_longer()`  
- Standardisation of variable names  
- Explicit type coercion to numeric formats  

#### Unit Transformations  

- Wind: MW → GW  
- LCOE: $/kWh → $/MWh  

#### Data Integration  

Datasets are merged on `year` using sequential `left_join()` operations.

#### Data Quality  

- Missing values introduced during gas price coercion  
- No duplicate observations detected  
- Final dataset spans 26 annual observations (1997–2022)  

Output: `data/clean/master_dataset.csv`

---
### Exploratory Analysis  
> Implemented in `02_eda.R`

EDA is used to assess modelling suitability and inform transformation choices.

#### Technical Observations  

- Wind capacity exhibits strong non-linear upward growth  
- Variance instability present in level data  
- Correlation structure suggests:
  - Strong inverse relationship with LCOE  
  - Moderate positive relationship with electricity  
  - Weak relationship with gas price  

#### Design Decisions  

- Log transformation applied to all variables to:
  - Stabilise variance  
  - Linearise multiplicative relationships  

---
### Stationarity Testing  
> Implemented in `03_stationarity_tests.R`

#### Level Series  

ADF test results:
- Wind: p = 0.765  
- Electricity: p = 0.665  
- Gas: p = 0.774  
- LCOE: p = 0.469  

KPSS test results:
- Wind: p = 0.01  
- Electricity: p ≈ 0.02  
- Gas: p ≈ 0.049  
- LCOE: p = 0.01  

**Interpretation:**  
- ADF fails to reject non-stationarity  
- KPSS rejects stationarity  
> All variables treated as non-stationary in levels  

#### Transformed Series  

Transformation pipeline:
1. Log transformation  
2. First differencing  

ADF (differenced):
- Wind: p = 0.668  
- Electricity: p = 0.096  
- Gas: p = 0.673  
- LCOE: p = 0.309  

KPSS (differenced):
- Wind: p = 0.01  
- Electricity: p ≈ 0.023  
- Gas: p = 0.10  
- LCOE: p ≈ 0.059  

**Interpretation:**  
- Partial improvement in stationarity  
- Wind series remains persistent  
> Supports use of integrated time series models  

---
### Feature Engineering  
> Implemented in `04_feature_engineering.R`

#### Constructed Variables  

- `log_wind`  
- `log_electricity`  
- `log_gas`  
- `log_lcoe`  

#### Design Rationale  

- Maintain consistency across modelling approaches  
- Enable log-log relationships in regression  
- Align transformations with stationarity requirements  

Output: `data/processed/model_df.csv`

---
### Model Construction  
> Implemented in `05_model_fitting.R`

**ARIMA Model**  
- Selected using `auto.arima()`  
- Final specification: **ARIMA(0,2,0)**  

Model output:
- sigma² = 0.001301  
- log likelihood = 45.68  
- AIC = -89.37  

**ARIMAX Models**  

- Full model:
  - AR(1) coefficient = 0.9873  
  - log_lcoe = -1.1002  
  - log_electricity = 1.0245  
  - log_gas = 0.0397  

AIC = -11.62  

- Reduced model:
  - AR(1) = 0.9881  
  - log_lcoe = -1.1106  
  - log_electricity = 1.0430  

AIC = -13.24  

**Regression Models**  

- Full model:
  - log_lcoe significant (p < 0.001)  
  - log_electricity significant (p < 0.001)  
  - log_gas insignificant (p = 0.928)  
  - Adjusted R² = 0.9513  

- Reduced model:
  - Adjusted R² = 0.9534  

*Multicollinearity:* (VIF < 2.1) across all variables  

---
### Diagnostic Validation  
> Implemented in `06_model_diagnostics.R`

**Time Series Models**  

Ljung-Box test:

- ARIMA: p = 0.0098 → residual autocorrelation present  
- ARIMAX (full): p = 0.051 → borderline  
- ARIMAX (reduced): p = 0.040 → autocorrelation present  

**Regression Models**  

Breusch-Pagan:
- p = 0.220 → no heteroskedasticity  

Shapiro-Wilk:
- p ≈ 0.92 → residuals approximately normal  

Durbin-Watson:
- p < 0.01 → strong autocorrelation  

*Conclusion:* Regression models violate independence assumption  

---
### Model Validation  
> Implemented in `07_model_validation.R`

#### Validation Design  
- 80–20 train-test split  
- Validation performed on log scale  

#### Forecast Accuracy (Test Set)  
- ARIMA RMSE = 0.0634  
- ARIMAX (reduced) RMSE = 0.2026  
- ARIMAX (full) RMSE = 1.5205  

**Interpretation**  
- ARIMA achieves lowest forecast error  
- ARIMAX models degrade performance when including exogenous variables  

> Time series structure dominates predictive accuracy  

---
### Final Forecast  
> Implemented in `08_final_forecast.R`

#### Model  
- Final model: **ARIMA(0,2,0)**  
- Fitted on full dataset  

#### Forecast Design  
- Horizon: 8 years  
- Forecast generated in log scale  
- Back-transformed using exponential function  

***Implementation Steps***  
1. Generate forecasts using `forecast()`  
2. Extract mean and confidence intervals  
3. Convert to original scale using `exp()`  

Outputs:
- `forecast_values.csv`  
- `forecast_plot.png`  

---
### Assumptions and Limitations  
- ARIMA assumes linear dependence in differenced series  
- Log transformation assumes multiplicative growth  
- Small sample size (26 observations) limits robustness  
- No seasonal component (annual data)  
- Residual autocorrelation persists in ARIMA model   

---
### References  
*To be added*
