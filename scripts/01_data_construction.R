# File: 01_data_construction.R
# Project: Wind Energy Adoption Forecasting
# Purpose: Load raw datasets, reshape, merge, and create master dataset

# Load libraries
library(readr)
library(dplyr)
library(tidyr)
library(janitor)
library(here)

# Load raw data
wind_raw <- read_delim(
  here("data", "raw", "Wind Capacity (MW).txt"),
  delim = "\t"
)

electricity_raw <- read_delim(
  here("data", "raw", "Energy Generated TWh.txt"),
  delim = "\t"
)

gas_raw <- read_delim(
  here("data", "raw", "Natural Gas (Europe).txt"),
  delim = "\t"
)

lcoe_raw <- read_delim(
  here("data", "raw", "Onshore LCOE.txt"),
  delim = "\t",
  skip = 1
)

# Transform datasets
wind <- wind_raw %>%
  pivot_longer(
    cols = -1,
    names_to = "year",
    values_to = "wind_mw"
  ) %>%
  mutate(year = as.numeric(year)) %>%
  select(year, wind_mw)

electricity <- electricity_raw %>%
  pivot_longer(
    cols = -1,
    names_to = "year",
    values_to = "electricity_twh"
  ) %>%
  mutate(year = as.numeric(year)) %>%
  select(year, electricity_twh)

gas <- gas_raw %>%
  rename(
    year = 1,
    gas_price_usd_per_mmbtu = 2
  ) %>%
  mutate(
    year = as.numeric(year),
    gas_price_usd_per_mmbtu = as.numeric(gas_price_usd_per_mmbtu)
  ) %>%
  drop_na()

lcoe <- lcoe_raw %>%
  rename(
    year = 'Year',
    lcoe_usd_per_kwh = 'Weighted average'
  ) %>%
  mutate(year = as.numeric(year)) %>%
  select(year, lcoe_usd_per_kwh)

# Merge datasets
master_df <- wind %>%
  left_join(electricity, by = "year") %>%
  left_join(gas, by = "year") %>%
  left_join(lcoe, by = "year") %>%
  clean_names()

# Final transformations
master_df <- master_df %>%
  mutate(
    wind_gw = wind_mw / 1000,
    lcoe_usd_per_mwh = lcoe_usd_per_kwh * 1000
  ) %>%
  select(
    year,
    wind_gw,
    electricity_twh,
    gas_price_usd_per_mmbtu,
    lcoe_usd_per_mwh
  ) %>%
  drop_na()

# Save cleaned dataset
write_csv(
  master_df,
  here("data", "clean", "master_dataset.csv")
)
