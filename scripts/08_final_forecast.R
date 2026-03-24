# File: 08_final_forecast.R
# Project: Wind Energy Adoption Forecasting
# Purpose: Generate final forecasts and plot full timeline

# Load libraries
library(readr)
library(forecast)
library(ggplot2)
library(dplyr)
library(here)

# Load data
model_df <- read_csv(
  here("data", "processed", "model_df.csv")
)

# Load final model (ARIMA)
fit_arima <- readRDS(
  here("models", "arima.rds")
)

# FORECAST HORIZON
h <- 8

# FORECAST (LOG SCALE)
fc <- forecast(fit_arima, h = h)

# CONVERT TO ORIGINAL SCALE
fc_mean  <- exp(fc$mean)
fc_lower <- exp(fc$lower[,1])
fc_upper <- exp(fc$upper[,1])

# CREATE FORECAST DATAFRAME
forecast_df <- data.frame(
  year = (max(model_df$year) + 1):(max(model_df$year) + h),
  forecast_gw = as.numeric(fc_mean),
  lower_80 = as.numeric(fc_lower),
  upper_80 = as.numeric(fc_upper)
)

# HISTORICAL DATA (ORIGINAL SCALE)
historical_df <- model_df %>%
  select(year, wind_gw)

# COMBINE DATA FOR PLOTTING
plot_df <- bind_rows(
  historical_df %>%
    mutate(type = "Historical"),
  
  forecast_df %>%
    rename(wind_gw = forecast_gw) %>%
    mutate(type = "Forecast")
)

# PLOT FULL TIMELINE
ggplot() +
  # Historical line
  geom_line(
    data = historical_df,
    aes(x = year, y = wind_gw),
    linewidth = 1
  ) +
  
  # Forecast line
  geom_line(
    data = forecast_df,
    aes(x = year, y = forecast_gw),
    linetype = "dashed",
    linewidth = 1
  ) +
  
  # Confidence interval
  geom_ribbon(
    data = forecast_df,
    aes(x = year, ymin = lower_80, ymax = upper_80),
    alpha = 0.2
  ) +
  
  labs(
    title = "Europe Wind Capacity: Historical and Forecast",
    x = "Year",
    y = "Wind Capacity (GW)"
  ) +
  theme_minimal()

ggsave(
  here("outputs", "forecast", "forecast_plot.png"),
  width = 10, height = 6
)

# Save forecast table
write_csv(
  forecast_df,
  here("outputs", "forecast", "forecast_values.csv")
)
