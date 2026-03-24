# File: 07_model_validation.R
# Project: Wind Energy Adoption Forecasting
# Purpose: Compare model performance using train-test validation (log scale)

# Load libraries
library(readr)
library(dplyr)
library(forecast)
library(here)

# Load data
model_df <- read_csv(
  here("data", "processed", "model_df.csv")
)

# TRAIN / TEST SPLIT (80-20)
n <- nrow(model_df)
train_size <- floor(0.8 * n)

train_df <- model_df[1:train_size, ]
test_df  <- model_df[(train_size + 1):n, ]

# TIME SERIES
ts_train <- ts(
  train_df$log_wind,
  start = min(train_df$year),
  frequency = 1
)

ts_test <- ts(
  test_df$log_wind,
  start = min(test_df$year),
  frequency = 1
)

# XREG MATRICES

# FULL (with gas)
xreg_train_full <- train_df %>%
  select(log_lcoe, log_electricity, log_gas) %>%
  as.matrix()

xreg_test_full <- test_df %>%
  select(log_lcoe, log_electricity, log_gas) %>%
  as.matrix()

# REDUCED (no gas)
xreg_train_reduced <- train_df %>%
  select(log_lcoe, log_electricity) %>%
  as.matrix()

xreg_test_reduced <- test_df %>%
  select(log_lcoe, log_electricity) %>%
  as.matrix()

# MODEL FITTING

# TRAIN

# ARIMA
fit_arima <- auto.arima(ts_train)

# ARIMAX (full)
fit_arimax_full <- auto.arima(
  ts_train,
  xreg = xreg_train_full
)

# ARIMAX (reduced)
fit_arimax_reduced <- auto.arima(
  ts_train,
  xreg = xreg_train_reduced
)

# TEST

h <- length(ts_test)

fc_arima <- forecast(fit_arima, h = h)

fc_arimax_full <- forecast(
  fit_arimax_full,
  xreg = xreg_test_full,
  h = h
)

fc_arimax_reduced <- forecast(
  fit_arimax_reduced,
  xreg = xreg_test_reduced,
  h = h
)

# ACCURACY (LOG SCALE ONLY)
acc_arima <- accuracy(fc_arima, ts_test)
acc_arimax_full <- accuracy(fc_arimax_full, ts_test)
acc_arimax_reduced <- accuracy(fc_arimax_reduced, ts_test)

# OUTPUT
acc_arima
acc_arimax_full
acc_arimax_reduced

# Save Accuracy as Table
validation_df <- data.frame(
  model = c("ARIMA", "ARIMAX_FULL", "ARIMAX_REDUCED"),
  RMSE = c(acc_arima[2,"RMSE"],
           acc_arimax_full[2,"RMSE"],
           acc_arimax_reduced[2,"RMSE"]),
  MAE = c(acc_arima[2,"MAE"],
          acc_arimax_full[2,"MAE"],
          acc_arimax_reduced[2,"MAE"])
)

write_csv(
  validation_df,
  here("outputs", "validation", "model_accuracy.csv")
)
