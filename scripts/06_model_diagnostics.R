# File: 06_model_diagnostics.R
# Project: Wind Energy Adoption Forecasting
# Purpose: Diagnose model assumptions and residual behaviour

# Load libraries
library(readr)
library(forecast)
library(lmtest)
library(here)

# Load models
fit_arima <- readRDS(here("models", "arima.rds"))
fit_arimax_full <- readRDS(here("models", "arimax_full.rds"))
fit_arimax_reduced <- readRDS(here("models", "arimax_reduced.rds"))

model_reg_full <- readRDS(here("models", "regression_full.rds"))
model_reg_reduced <- readRDS(here("models", "regression_reduced.rds"))

# TIME SERIES DIAGNOSTICS

# ARIMA
checkresiduals(fit_arima)

# ARIMAX (full)
checkresiduals(fit_arimax_full)

# ARIMAX (reduced)
checkresiduals(fit_arimax_reduced)

# REGRESSION DIAGNOSTICS

# FULL MODEL
res_full <- residuals(model_reg_full)

plot(fitted(model_reg_full), res_full)
abline(h = 0)

qqnorm(res_full)
qqline(res_full)

bptest(model_reg_full)
dwtest(model_reg_full)
shapiro.test(res_full)

# REDUCED MODEL
res_reduced <- residuals(model_reg_reduced)

plot(fitted(model_reg_reduced), res_reduced)
abline(h = 0)

qqnorm(res_reduced)
qqline(res_reduced)

bptest(model_reg_reduced)
dwtest(model_reg_reduced)
shapiro.test(res_reduced)

# Save Diagnostics
png(here("outputs", "diagnostics", "arima_residuals.png"),
    width = 800, height = 600)
checkresiduals(fit_arima)
dev.off()

png(here("outputs", "diagnostics", "arimax_residuals.png"),
    width = 800, height = 600)
checkresiduals(fit_arimax_full)
dev.off()

sink(here("outputs", "diagnostics", "diagnostic_tests.txt"))

cat("=== Ljung-Box (ARIMA) ===\n")
print(Box.test(residuals(fit_arima), lag = 5, type = "Ljung-Box"))

cat("\n=== Ljung-Box (ARIMAX FULL) ===\n")
print(Box.test(residuals(fit_arimax_full), lag = 5, type = "Ljung-Box"))

cat("\n=== Durbin-Watson (Regression FULL) ===\n")
print(dwtest(model_reg_full))

sink()