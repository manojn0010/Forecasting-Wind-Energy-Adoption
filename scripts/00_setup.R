# File: 00_setup.R
# Project: Wind Energy Adoption Forecasting
# Purpose: Install and load required R packages

# Object for Required Packages
required_packages <- c(
  "tidyverse",
  "readr",
  "forecast",
  "tseries",
  "GGally",
  "patchwork",
  "car",
  "lmtest",
  "here"
)

installed_packages <- rownames(installed.packages())

# Install missing packages
for (pkg in required_packages) {
  if (!pkg %in% installed_packages) {
    install.packages(
      pkg,
      dependencies = TRUE
    )
  }
}
