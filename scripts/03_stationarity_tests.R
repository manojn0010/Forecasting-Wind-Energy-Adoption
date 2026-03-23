# File: 03_stationarity_tests.R
# Project: Wind Energy Adoption Forecasting
# Purpose: Create time series objects, test stationarity, and prepare transformed series

# Load libraries
library(readr)
library(dplyr)
library(tseries)
library(forecast)
library(patchwork)
library(here)

# Load data
master_df <- read_csv(
  here("data", "clean", "master_dataset.csv")
)

# Create time series objects
start_year <- min(master_df$year)

ts_wind <- ts(master_df$wind_gw, start = start_year, frequency = 1)
ts_electricity <- ts(master_df$electricity_twh, start = start_year, frequency = 1)
ts_gas <- ts(master_df$gas_price_usd_per_mmbtu, start = start_year, frequency = 1)
ts_lcoe <- ts(master_df$lcoe_usd_per_mwh, start = start_year, frequency = 1)

# Stationarity tests (level)
adf.test(ts_wind)
adf.test(ts_electricity)
adf.test(ts_gas)
adf.test(ts_lcoe)

kpss.test(ts_wind)
kpss.test(ts_electricity)
kpss.test(ts_gas)
kpss.test(ts_lcoe)

# Log transformation
log_wind <- log(ts_wind)
log_electricity <- log(ts_electricity)
log_gas <- log(ts_gas)
log_lcoe <- log(ts_lcoe)

# Differencing
diff_wind <- diff(log_wind)
diff_electricity <- diff(log_electricity)
diff_gas <- diff(log_gas)
diff_lcoe <- diff(log_lcoe)

# Stationarity tests (transformed)
adf.test(diff_wind)
adf.test(diff_electricity)
adf.test(diff_gas)
adf.test(diff_lcoe)

kpss.test(diff_wind)
kpss.test(diff_electricity)
kpss.test(diff_gas)
kpss.test(diff_lcoe)

# ACF plots
acf_wind <- ggAcf(diff_wind) + ggtitle("ACF: Diff Log Wind")
acf_electricity <- ggAcf(diff_electricity) + ggtitle("ACF: Diff Log Electricity")
acf_gas <- ggAcf(diff_gas) + ggtitle("ACF: Diff Log Gas")
acf_lcoe <- ggAcf(diff_lcoe) + ggtitle("ACF: Diff Log LCOE")

(acf_wind | acf_electricity) / (acf_gas | acf_lcoe)

# PACF plots
pacf_wind <- ggPacf(diff_wind) + ggtitle("PACF: Diff Log Wind")
pacf_electricity <- ggPacf(diff_electricity) + ggtitle("PACF: Diff Log Electricity")
pacf_gas <- ggPacf(diff_gas) + ggtitle("PACF: Diff Log Gas")
pacf_lcoe <- ggPacf(diff_lcoe) + ggtitle("PACF: Diff Log LCOE")

(pacf_wind | pacf_electricity) / (pacf_gas | pacf_lcoe)