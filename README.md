# Desert Bloom & Aridity Dynamics: NDVI–Precipitation Analysis

This repository contains code and notebooks for detecting and analyzing **blooming desert events** and vegetation dynamics in arid regions using **MODIS NDVI/EVI**, **CHIRPS precipitation**. The workflow combines Python notebooks for data access, processing, and correlation analysis with an R script for **phenology-based anomaly detection** (via `npphen`).

> **TL;DR**  
> - Load and clean precipitation and vegetation time series  
> - Quantify NDVI–precipitation relationships and lags  
> - Detect extreme greening anomalies (bloom events) with `npphen`  
> - Visualize and export results for GIS and further analysis  


## 📦 Datasets

This project typically uses the following data sources (adjust paths in notebooks/R script as needed):

- **MODIS NDVI/EVI** (e.g., MOD13Q1 or MYD13Q1, 16‑day) for vegetation dynamics.  
- **CHIRPS** daily precipitation (can be aggregated to 16‑day/monthly) for rainfall forcing.  



## 🗺️ Typical Outputs

- Time series plots (NDVI/EVI and precipitation)
- Lagged correlation curves and tables
- Phenology reference plots (RFD)
- Anomaly time series and **bloom event flags**
- CSV exports for downstream stats; optional GeoTIFF/NetCDF for maps
