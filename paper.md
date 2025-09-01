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
    corresponding: true
    affiliation: "1"
affiliations:
 - name: Institute of Astronomy, Geophysics and Atmospheric Sciences, University of São Paulo (IAG-USP), Brazil
   index: 1
   ror: 02en5vm97
date: 01 September 2025
bibliography: paper.bib
---

# Summary

Nocturnal Low-Level Jets (NLLJs) are nighttime wind maxima in the lower troposphere, primarily caused by inertial oscillations and radiative cooling of the boundary layer. These jets play a critical role in meridional moisture transport from tropical to subtropical regions, influencing precipitation patterns, severe weather events, and hydrological extremes in South America.  

**JBNN** is an open-source Python-based tool that implements the NLLJ detection methodology proposed by Rife et al. (2010), adapted for isobaric levels (900–650 hPa). It provides an automated workflow for downloading ERA5 reanalysis data, preprocessing, index computation, and visualization. The software is designed to support both climatological studies and case-specific analyses, enabling reproducibility and open access for the atmospheric science community.

---

# Statement of Need

The objective identification of NLLJs over South America is essential for understanding their influence on moisture transport, precipitation variability, and extreme events. However, existing methods are often not publicly available, rely on rigid thresholds (e.g., Bonner, 1968), and lack reproducibility.  

**JBNN** addresses these limitations by offering:
- A transparent, **open-source workflow** for ERA5-based NLLJ detection.
- Automated **data preprocessing** with Climate Data Operators (CDO).
- Seamless integration with Python scientific libraries (`xarray`, `Cartopy`, `Matplotlib`).
- Tools for **climatology generation** and **event analysis**.

By lowering the technical barriers, JBNN promotes reproducibility and accessibility in atmospheric science.

---

# Scientific Background

NLLJs are low-tropospheric wind maxima typically located near 900 hPa during nighttime hours. They significantly enhance moisture fluxes from the Amazon Basin toward the subtropics, fueling large-scale systems such as the **South American Low-Level Jet (SALLJ)** and the **South Atlantic Convergence Zone (SACZ)**. Their formation is governed by:
- **Inertial oscillations** in the nocturnal boundary layer (Blackadar, 1957).
- **Topographic channeling** east of the Andes, favoring strong jets in the Chaco region.
- **Baroclinic processes and surface heterogeneity**, such as land–sea contrasts.  

Seasonally, NLLJs occur most frequently during austral summer (DJF) and can persist from one night to over a week. Their role in triggering mesoscale convective systems and modulating precipitation extremes makes their monitoring essential for weather prediction, hydrology, and agriculture (Vera et al., 2006; Braz et al., 2021).

---

# Functionality and Workflow

The **JBNN** package provides:
- **Data Acquisition**: `Download ERA.ipynb` retrieves ERA5 wind components (`u`, `v`) and geopotential height.
- **Preprocessing**: `run_JBNN.sh` computes daily means, vertical shear (900–650 hPa), and wind magnitude using **CDO**.
- **Index Computation**: Implements the NLLJ intensity index from Rife et al. (2010), adapted for isobaric levels:
  \[
  \text{NLLJ} = \lambda \phi \sqrt{[(U_{L1}^{00}-U_{L2}^{00})-(U_{L1}^{12}-U_{L2}^{12})]^2+[(V_{L1}^{00}-V_{L2}^{00})-(V_{L1}^{12}-V_{L2}^{12})]^2}
  \]
  where \( L_1 = 900 \,\text{hPa}\) and \( L_2 = 650 \,\text{hPa}\).
- **Visualization**:
  - `Mapa JBNN.py`: Generates seasonal climatology maps.
  - `DIAS_NLLJ.py`: Creates daily frequency maps of NLLJ occurrences.
  - `diascomjato.ipynb`: Interactive case-study analysis.

### **Dependencies**
- Python 3.8+
- `xarray`, `numpy`, `matplotlib`, `cartopy`, `shapely`
- **CDO** for preprocessing

### **Installation**
```bash
git clone https://github.com/DejaBraz/Jato-de-Baixos-Niveis-Noturnos
cd Jato-de-Baixos-Niveis-Noturnos
pip install -r requirements.txt
