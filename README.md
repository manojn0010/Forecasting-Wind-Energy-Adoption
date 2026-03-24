# Forecasting Wind Energy Adoption  
Analysing and forecasting wind energy growth trends using statistical and time series modelling techniques.

---
## Description
This project analyses and forecasts wind energy adoption in Europe using a structured time series modelling framework. Installed wind capacity is used as a proxy for wind energy adoption, representing cumulative deployment over time.

The analysis begins with an exploratory assessment of key economic drivers, including electricity generation (demand proxy), natural gas prices (competitive energy pricing), and wind levelised cost of energy (LCOE). These variables are evaluated to understand their relationship with wind capacity growth.

Pre-modelling diagnostics reveal strong upward trends and autocorrelation in the data, motivating log transformation and time series modelling. Multiple model classes are then constructed, including regression, ARIMA, and ARIMAX specifications.

Model validation using a train-test framework demonstrates that pure time series modelling (ARIMA) outperforms models incorporating external drivers. The final forecast is therefore generated using an ARIMA model fitted on log-transformed wind capacity.

> This highlights that strong explanatory relationships do not necessarily translate into improved forecasting performance.

#### Tools Used
**Time Series Modelling and Forecasting:** `forecast`, `tseries`  
**Statistical Modelling and Testing:** Base R (`stats`), `car`, `lmtest`  
**Data Manipulation and Visualisation:** `tidyverse`, `GGally`, `patchwork`, `here`  

---
### Data
The project uses a compiled dataset combining multiple sources related to European energy systems.

**Variables included:**
- Wind installed capacity (GW) — target variable  
- Electricity generation (TWh) — demand proxy  
- Natural gas price ($/MMBtu) — competing energy source  
- Wind LCOE ($/MWh) — technology cost indicator  

The dataset spans **1997–2022 (26 annual observations)** and is constructed through a structured data pipeline.

---
### Modelling Framework

The modelling approach follows a staged analytical pipeline:

#### 1. Exploratory Analysis
- Time series visualisation and correlation assessment  
- Identification of non-linear growth patterns and variance instability  
- Log transformation applied to stabilise variance and linearise relationships  

#### 2. Stationarity Assessment
- Augmented Dickey-Fuller (ADF) and KPSS tests applied  
- All variables identified as non-stationary in levels  
- Log transformation and differencing used to address trend components  

#### 3. Model Construction
Multiple model classes are evaluated:

- **ARIMA (univariate time series model)**
- **ARIMAX (with exogenous drivers)**
  - Full model (all drivers)  
  - Reduced model (excluding gas price)  
- **Regression models (log-log specification)**  

#### 4. Model Validation
- 80–20 train-test split (constrained by small sample size)  
- Evaluation performed on log-transformed data  

**Result:**
- ARIMA achieves the lowest forecasting error  
- ARIMAX models perform significantly worse out-of-sample  

> Final model selected: **ARIMA(0,2,0)**

---
### Forecast Output

The final model is used to generate forecasts for wind capacity over an **8-year horizon (2023–2030)**.

- Forecasts are produced in log scale and back-transformed to original units  
- Results indicate continued growth in wind energy adoption  
- Forecast uncertainty increases over longer horizons  

---
### Project Notes

- The project focuses on **forecasting wind energy adoption**, not causal inference  
- Economic drivers are explored for context but excluded from the final model due to inferior predictive performance  
- Log transformation is used to model exponential growth behaviour  
- Time series structure dominates forecasting accuracy in this dataset  
- Limited sample size (26 observations) influences modelling and validation design  

---
### Project Structure
- `/scripts` → Modular analytical pipeline (data → modelling → forecast)  
- `/data` → Raw, cleaned, and processed datasets  
- `/models` → Saved model objects  
- `/outputs` → EDA plots, diagnostics, validation results, and forecasts  

---
### Additional Notes
- Detailed modelling logic and implementation decisions are documented in `documentation.md`  
- Analytical findings and interpretation are presented in `report.md`  

---
### References
**Data (Wind Capacity and Energy Generated) obtained from:** Energy Institute Statistical Review of World Energy  
**Wind LCOE data obtained from:** IRENA (2023), Renewable Power Generation Costs in 2022  
**Natural gas price data obtained from:** Publicly available European gas price datasets (Dutch TTF benchmark)  
**Main workflow/Modelling performed using:** R Language
