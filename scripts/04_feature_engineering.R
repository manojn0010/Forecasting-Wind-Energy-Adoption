# File: 04_feature_engineering.R
# Project: Wind Energy Adoption Forecasting
# Purpose: Create log-transformed variables for modelling

# Load libraries
library(readr)
library(dplyr)
library(here)

# Load data
master_df <- read_csv(
  here("data", "clean", "master_dataset.csv")
)

# Feature engineering (log transformation)
model_df <- master_df %>%
  mutate(
    log_wind = log(wind_gw),
    log_electricity = log(electricity_twh),
    log_gas = log(gas_price_usd_per_mmbtu),
    log_lcoe = log(lcoe_usd_per_mwh)
  )

# Keep only required columns for modelling clarity
model_df <- model_df %>%
  select(
    year,
    wind_gw,
    log_wind,
    log_electricity,
    log_gas,
    log_lcoe
  )

# Save processed dataset
write_csv(
  model_df,
  here("data", "processed", "model_df.csv")
)