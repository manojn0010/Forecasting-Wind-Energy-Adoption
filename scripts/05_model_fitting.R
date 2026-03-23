# File: 05_model_fitting.R
# Project: Wind Energy Adoption Forecasting
# Purpose: Fit ARIMA, ARIMAX, and regression models

# Load libraries
library(readr)
library(dplyr)
library(forecast)
library(car)
library(here)

# Load data
model_df <- read_csv(
  here("data", "processed", "model_df.csv")
)

# Create time series (LOG LEVELS)
start_year <- min(model_df$year)

ts_log_wind <- ts(model_df$log_wind, start = start_year, frequency = 1)

# XREG matrices
xreg_full <- model_df %>%
  select(log_lcoe, log_electricity, log_gas) %>%
  as.matrix()

xreg_reduced <- model_df %>%
  select(log_lcoe, log_electricity) %>%
  as.matrix()

# MODELS

# ARIMA
fit_arima <- auto.arima(ts_log_wind)

# ARIMAX (full)
fit_arimax_full <- auto.arima(
  ts_log_wind,
  xreg = xreg_full
)

# ARIMAX (reduced)
fit_arimax_reduced <- auto.arima(
  ts_log_wind,
  xreg = xreg_reduced
)

# Regression models
model_reg_full <- lm(
  log_wind ~ log_lcoe + log_electricity + log_gas,
  data = model_df
)

model_reg_reduced <- lm(
  log_wind ~ log_lcoe + log_electricity,
  data = model_df
)

# Inspect time series models
fit_arima
fit_arimax_full
fit_arimax_reduced

# Diagnostics (for inspection, not validation)
summary(model_reg_full)
summary(model_reg_reduced)

vif(model_reg_full)
vif(model_reg_reduced)

# Save models
saveRDS(fit_arima, here("models", "arima.rds"))
saveRDS(fit_arimax_full, here("models", "arimax_full.rds"))
saveRDS(fit_arimax_reduced, here("models", "arimax_reduced.rds"))
saveRDS(model_reg_full, here("models", "regression_full.rds"))
saveRDS(model_reg_reduced, here("models", "regression_reduced.rds"))