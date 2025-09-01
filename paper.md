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

Nocturnal Low-Level Jets (NLLJs) are nighttime wind maxima in the lower troposphere driven by inertial oscillations and radiative cooling of the boundary layer. These jets play a central role in the meridional transport of moisture from tropical to subtropical regions, influencing precipitation patterns, severe weather, and hydrological extremes across South America.  

**JBNN** is an open-source Python-based tool for identifying and mapping NLLJs using ERA5 reanalysis data. It implements the Rife et al. (2010) intensity index adapted for isobaric coordinates (900–650 hPa) and provides an automated workflow from data acquisition to visualization. The package supports climatological analysis and event-based diagnostics, ensuring reproducibility and accessibility for the scientific community.

---

# Statement of Need

Although several studies have characterized NLLJs in South America, objective and reproducible methodologies for their detection remain limited. Most implementations are private or rely on rigid thresholds (e.g., Bonner, 1968), making replication difficult.  

**JBNN** addresses these issues by offering:
- An **open-source**, fully automated pipeline for ERA5-based NLLJ detection.
- **Standardized preprocessing** using CDO and Python libraries (`xarray`, `Cartopy`, `Matplotlib`).
- Tools for both **climatology** and **case-study analysis**.
- **Reproducibility** of previous research, such as Braz et al. (2021), enabling consistent comparisons across studies.

---

# Scientific Background

NLLJs exhibit strong nocturnal wind maxima typically near 900 hPa and are key drivers of moisture transport that feed large-scale systems such as the **South American Low-Level Jet (SALLJ)** and the **South Atlantic Convergence Zone (SACZ)**. They modulate seasonal precipitation and contribute to extreme weather events and agricultural impacts.  

Mechanisms of formation include:
- **Inertial oscillation** in the nocturnal boundary layer (Blackadar, 1957).
- **Topographic channeling** east of the Andes (e.g., Chaco Jet).
- **Baroclinicity and surface heterogeneity** (land–sea contrasts, vegetation gradients).  

NLLJs over South America display a marked seasonality, with peak frequency in austral summer (DJF) and persistence varying from 1–2 days to over a week in northeastern Brazil. They influence mesoscale convective systems, cyclogenesis in the La Plata Basin, and the hydrological cycle (Vera et al., 2006; Braz et al., 2021).

---

# Functionality and Workflow

The **JBNN** package provides:
- **Data Acquisition**: `Download ERA.ipynb` retrieves ERA5 u/v wind components and geopotential for pressure levels.
- **Preprocessing**: `run_JBNN.sh` computes daily means, vertical wind shear (900–650 hPa), and wind magnitude using **CDO**.
- **Index Computation**: Implements Rife et al. (2010) index adapted for pressure levels:
  \[
  \text{NLLJ} = \lambda \phi \sqrt{[(U_{L1}^{00}-U_{L2}^{00})-(U_{L1}^{12}-U_{L2}^{12})]^2+[(V_{L1}^{00}-V_{L2}^{00})-(V_{L1}^{12}-V_{L2}^{12})]^2}
  \]
  where \( L_1 = 900 \,\text{hPa}\) and \( L_2 = 650 \,\text{hPa}\).
- **Visualization**:
  - `Mapa JBNN.py`: Plots seasonal climatologies with shapefiles of Brazilian states and basins.
  - `DIAS_NLLJ.py`: Generates daily frequency maps of NLLJ occurrences.
  - `diascomjato.ipynb`: Interactive notebook for case studies.

### **Dependencies**
- Python 3.8+
- `xarray`, `numpy`, `matplotlib`, `cartopy`, `shapely`
- **CDO** for preprocessing

### **Installation**
```bash
git clone https://github.com/DejaBraz/Jato-de-Baixos-Niveis-Noturnos
cd Jato-de-Baixos-Niveis-Noturnos
pip install -r requirements.txt
