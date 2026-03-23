# Forecasting Wind Energy Adoption  
Analysing and forecasting wind energy growth trends using statistical and time series modelling techniques.

---
## Description
This project analyses and forecasts wind energy adoption in Europe using a structured time series modelling framework. Installed wind capacity is used as a proxy for adoption, capturing long-term growth dynamics in renewable energy expansion.

The analysis begins with exploratory assessment of key economic drivers, including electricity generation (demand proxy), natural gas prices (competitive energy pricing), and wind levelised cost of energy (LCOE). These variables are evaluated to understand their relationship with wind capacity growth.

Pre-modelling diagnostics reveal strong upward trends and autocorrelation in the data, motivating log transformation and time series modelling. Multiple model classes are then constructed, including regression, ARIMA, and ARIMAX specifications.

Model validation using a train-test framework demonstrates that pure time series modelling (ARIMA) outperforms models incorporating external drivers. As a result, the final forecast is generated using an ARIMA model fitted on log-transformed wind capacity.

The project integrates exploratory analysis, statistical modelling, diagnostic validation, and forecasting into a cohesive analytical workflow.

---
## Tools Used
**Time Series Modelling and Forecasting:** `forecast`, `tseries`  
**Statistical Modelling:** Base R (`stats`), `car`, `lmtest`  
**Data Manipulation and Visualisation:** `tidyverse`, `GGally`, `patchwork`, `here`  

---
## Data
The project uses a compiled dataset combining multiple sources related to European energy systems.

**Variables included:**
- Wind installed capacity (GW) — target variable  
- Electricity generation (TWh) — demand proxy  
- Natural gas price ($/MMBtu) — competing energy source  
- Wind LCOE ($/MWh) — technology cost indicator  

The dataset spans **1997–2022 (26 annual observations)**.

---
## Modelling Framework

The modelling strategy follows a structured progression:

### 1. Exploratory Analysis
- Time series visualisation and correlation analysis  
- Identification of strong upward trend and non-linearity  
- Log transformation applied to stabilise variance  

### 2. Stationarity Assessment
- Augmented Dickey-Fuller (ADF) and KPSS tests  
- Differencing applied to address non-stationarity  
- ACF and PACF used to guide model structure  

### 3. Model Construction
The following model classes are evaluated:

- **ARIMA (univariate time series)**
- **ARIMAX (with exogenous drivers)**
  - Full: LCOE, electricity, gas price  
  - Reduced: LCOE, electricity  
- **Regression models (log-log specification)**  

### 4. Model Selection
- Regression diagnostics reveal statistical relationships but poor time-series validity  
- Gas price found to be statistically insignificant and removed in reduced specifications  
- Train-test validation (80–20 split) shows:

  - ARIMA achieves the lowest forecasting error  
  - ARIMAX models perform significantly worse out-of-sample  

→ Final model selected: **ARIMA(0,2,0)**  

---
## Forecast Output
The final model generates forecasts for wind capacity over an **8-year horizon**, following a proportional extension relative to available data.

- Forecast period: **2023–2030**  
- Forecasts are generated in log scale and transformed back to original units  

The results indicate continued growth in wind energy adoption, with widening uncertainty bands over time.

---
## Project Notes
- The project focuses on **forecasting wind energy adoption**, not causal inference  
- Exogenous drivers are explored but excluded from the final model due to limited forecasting performance  
- Log transformation is used to stabilise variance and model exponential growth  
- Time series assumptions are validated using statistical tests and residual diagnostics  
- The dataset is limited to 26 annual observations, influencing model selection and validation design  

---
## Project Structure
- `/scripts` → End-to-end analytical pipeline  
- `/data` → Raw, cleaned, and processed datasets  
- `/models` → Saved model objects  
- `/outputs` → EDA plots, diagnostics, validation results, and forecasts  

---
## Additional Notes
- Detailed modelling logic and technical decisions are documented in `documentation.md`  
- Analytical findings and interpretation are presented in `report.md`  

---
## Sources and References
*To be added*
