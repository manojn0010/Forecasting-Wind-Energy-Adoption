# File: 02_exploratory_data_analysis.R
# Project: Wind Energy Adoption Forecasting
# Purpose: Perform EDA, visualisation, correlation analysis, and transformations

# Load libraries
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(GGally)
library(patchwork)
library(here)

# Load data
master_df <- read_csv(
  here("data", "clean", "master_dataset.csv")
)

# Basic summary
summary(master_df)

# Time Series Visualisation
p1 <- ggplot(master_df, aes(x = year, y = wind_gw)) +
  geom_line(linewidth = 1) +
  labs(title = "Europe Wind Capacity", x = "Year", y = "GW") +
  theme_minimal()

p2 <- ggplot(master_df, aes(x = year, y = electricity_twh)) +
  geom_line(linewidth = 1) +
  labs(title = "Electricity Generation", x = "Year", y = "TWh") +
  theme_minimal()

p3 <- ggplot(master_df, aes(x = year, y = gas_price_usd_per_mmbtu)) +
  geom_line(linewidth = 1) +
  labs(title = "Gas Price", x = "Year", y = "$/MMBtu") +
  theme_minimal()

p4 <- ggplot(master_df, aes(x = year, y = lcoe_usd_per_mwh)) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(title = "Wind LCOE", x = "Year", y = "$/MWh") +
  theme_minimal()

# Combine plots
(p1 | p2) / (p3 | p4)

# Correlation Analysis
eda_vars <- master_df %>%
  select(
    wind_gw,
    electricity_twh,
    gas_price_usd_per_mmbtu,
    lcoe_usd_per_mwh
  )

cor_matrix <- cor(eda_vars, use = "complete.obs")
print(cor_matrix)

ggpairs(eda_vars)

# Log Transformation
eda_log <- master_df %>%
  mutate(
    log_wind = log(wind_gw),
    log_electricity = log(electricity_twh),
    log_gas = log(gas_price_usd_per_mmbtu),
    log_lcoe = log(lcoe_usd_per_mwh)
  )

# Log-based Visualisation
p5 <- ggplot(eda_log, aes(x = year, y = log_wind)) +
  geom_line(linewidth = 1) +
  labs(title = "Log Wind Capacity", x = "Year", y = "log(Wind)") +
  theme_minimal()

p6 <- ggplot(eda_log, aes(x = log_lcoe, y = log_wind)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Wind vs LCOE") +
  theme_minimal()

p7 <- ggplot(eda_log, aes(x = log_electricity, y = log_wind)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Wind vs Electricity") +
  theme_minimal()

p8 <- ggplot(eda_log, aes(x = log_gas, y = log_wind)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Wind vs Gas Price") +
  theme_minimal()

# Combine plots
(p5) / (p6 | p7 | p8)

# Distribution Analysis
p9 <- eda_log %>%
  select(log_wind, log_lcoe, log_electricity, log_gas) %>%
  pivot_longer(cols = everything()) %>%
  ggplot(aes(x = value)) +
  geom_histogram(bins = 20, fill = "steelblue", alpha = 0.7) +
  facet_wrap(~name, scales = "free") +
  theme_minimal()

p9

# Data Quality Check
anyDuplicated(master_df)

# Save time series overview
ggsave(
  here("outputs", "eda", "time_series_overview.png"),
  plot = (p1 | p2) / (p3 | p4),
  width = 10, height = 6
)

# Save log relationships
ggsave(
  here("outputs", "eda", "log_relationships.png"),
  plot = (p5) / (p6 | p7 | p8),
  width = 10, height = 6
)