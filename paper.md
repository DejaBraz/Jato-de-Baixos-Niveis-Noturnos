---
title: 'JBNN: A Python-based Tool for the Identification and Mapping of Nocturnal Low-Level Jets over South America'
tags:
  - Python
  - meteorology
  - climatology
  - ERA5
  - low-level jets
  - atmospheric dynamics
authors:
  - name: Dejanira Ferreira Braz
    orcid: 0009-0000-1654-9063
    affiliation: 1
affiliations:
  - name: Institute of Astronomy, Geophysics and Atmospheric Sciences, University of São Paulo (IAG-USP), Brazil
    index: 1
date: 2025-09-01
bibliography: paper.bib
---

# Summary

Nocturnal Low-Level Jets (NLLJs) are low-tropospheric wind maxima that develop during nighttime due to inertial oscillations and radiative cooling of the boundary layer. They are a key driver of meridional moisture transport from tropical to subtropical regions and strongly modulate rainfall patterns, severe weather events, and climate variability. Over South America, NLLJs play a central role in the intensification of the South American Low-Level Jet (SALLJ), influencing the South Atlantic Convergence Zone (SACZ) and contributing to hydrological extremes. Their identification is therefore crucial for weather forecasting, climate monitoring, and risk management in agriculture and infrastructure.  

**JBNN** is an open-source Python-based software that implements the NLLJ index proposed by Rife et al. [@rife2010], adapted for isobaric coordinates (900–650 hPa), to identify and map nocturnal low-level jets over South America. The package provides a complete workflow — from downloading reanalysis data (ERA5) [@era5], preprocessing, and index calculation, to visualization and case-study analysis. The software is distributed under the MIT License, ensuring free use, reproducibility, and modification by the scientific community.

# Statement of need

While several climatological studies have described the occurrence of NLLJs over South America, the methodologies for their objective identification have often remained restricted to individual research groups, with codes that are not publicly available or difficult to reproduce. Most approaches rely on custom implementations combining reanalysis datasets with vertical wind shear diagnostics, limiting accessibility for broader use.  

**JBNN** addresses this gap by providing:  

- A reproducible and transparent pipeline for NLLJ identification based on ERA5 data [@era5].  
- Automated preprocessing routines using Climate Data Operators (CDO) [@cdo].  
- Ready-to-use Python scripts and notebooks for both climatological and case-study analysis.  
- Integration with widely adopted scientific libraries such as xarray [@hoyer2017], Cartopy [@metoffice2018cartopy], Matplotlib [@hunter2007], and NumPy.  
- An open-source implementation that enables reproducibility of climatological studies such as Braz et al. (2021) [@braz2021].  

By lowering the technical barriers for NLLJ analysis, **JBNN** is a valuable tool for meteorologists, climate scientists, and data scientists interested in atmospheric dynamics, moisture transport, and extreme weather events.

# Functionality

The repository provides the following modules and scripts:

- **Data acquisition**: `Download ERA.ipynb` retrieves ERA5 reanalysis datasets directly from the Copernicus Climate Data Store.  
- **Preprocessing**: `run_JBNN.sh` automates daily mean calculations, vertical shear extraction (900–650 hPa), and wind magnitude using CDO [@cdo].  
- **NLLJ index computation**: Implements the Rife et al. (2010) [@rife2010] formulation adapted to isobaric levels, storing results in NetCDF format for easy analysis.  
- **Visualization**:  
  - `Mapa JBNN.py`: plots seasonal maps of the NLLJ index with shapefiles of Brazilian states and South American basins.  
  - `DIAS_NLLJ.py`: generates daily frequency maps of NLLJ occurrences.  
  - `diascomjato.ipynb`: notebook demonstrating case studies and exploratory data analysis.  

The workflow ensures that researchers can replicate climatologies and identify NLLJ cores across South America in a straightforward and automated way.

# Example

As an example, applying **JBNN** to ERA5 reanalysis data during the austral summer (DJF) highlights the climatological core regions of NLLJ activity over central Brazil and northern Argentina. Daily occurrence maps (from `DIAS_NLLJ.py`) can be aggregated into seasonal climatologies (`Mapa JBNN.py`), providing insights into the role of NLLJs in sustaining regional precipitation patterns.  

A typical workflow is as follows:

```bash
# Run preprocessing for ERA5 data
bash run_JBNN.sh

# Plot the seasonal climatology
python Mapa\ JBNN.py
