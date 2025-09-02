---
title: "NLLJs: A Python-based Tool for the Identification and Mapping of Nocturnal Low-Level Jets over South America"
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
    affiliation: "1"
affiliations:
 - name: Institute of Astronomy, Geophysics and Atmospheric Sciences, University of São Paulo (IAG-USP), Brazil
   index: 1
   date: 2025-09-02
bibliography: paper.bib
---

# Summary

Nocturnal Low-Level Jets (NLLJs) are nighttime wind maxima in the lower troposphere, typically forming between 900–650 hPa due to inertial oscillations and radiative cooling of the boundary layer. Over South America, NLLJs play a fundamental role in meridional moisture transport from the Amazon Basin toward subtropical regions, significantly influencing rainfall patterns, severe convective events, and the hydrological cycle [@rife2010; @vera2006; @marengo2004]. Their occurrence is particularly relevant during austral summer, when they contribute to the formation of the South Atlantic Convergence Zone (SACZ) and the development of mesoscale convective systems.

The NLLJs package is an open-source Python implementation of an objective detection method for NLLJs based on the intensity index proposed by Rife et al. [@rife2010], adapted for isobaric levels (900–650 hPa). The tool provides a fully automated workflow, from downloading ERA5 reanalysis data [@era5] and preprocessing with CDO [@cdo], to computing the NLLJ index and generating climatological diagnostics. By combining transparent algorithms with open data, it enables reproducible and accessible studies of low-level jet dynamics across South America.

---

# Motivation and Scientific Relevance

Understanding the dynamics of NLLJs is crucial for regional climate analysis and disaster risk management. These jets enhance low-level moisture flux convergence, fueling convective systems that often lead to extreme precipitation, flooding, and agricultural losses [@braz2021; @montini2019]. Despite their importance, many existing detection methods rely on proprietary codes, lack full documentation, or require advanced computational expertise, limiting their use outside specialized groups. The NLLJs package addresses this gap by providing a reproducible workflow based on open data (ERA5) [@era5] and open-source tools [@cdo]. It offers a modular codebase that integrates seamlessly with the Python scientific ecosystem (xarray [@hoyer2017], cartopy [@metoffice2018cartopy], matplotlib [@hunter2007]) and delivers ready-to-use scripts for both climatological analysis and case studies. Furthermore, the package implements a standardized adaptation of the NLLJ intensity index, ensuring comparability with previous research while extending applicability to South American domains. By lowering technical barriers, it broadens access to NLLJ research, enabling meteorologists, climate scientists, and hydrologists to incorporate low-level jet diagnostics into their workflows and better quantify their role in extreme weather events.

---

# Software Architecture and Implementation

The NLLJs package is organized into modular components that guide the user from raw reanalysis data to meaningful scientific products. Data acquisition is performed through Download ERA.ipynb, which retrieves ERA5 hourly wind and geopotential fields via the Copernicus Climate Data Store API [@era5]. Preprocessing is handled by run_JBNN.sh, which uses Climate Data Operators (CDO) [@cdo] to compute daily means, vertical shear, and wind magnitude. The computation of the NLLJ intensity index is carried out by the function compute_index(), which follows the formulation of Rife et al. [@rife2010] but is adapted for 900–650 hPa levels. Visualization is supported by multiple scripts: Mapa JBNN.py generates seasonal climatology maps of NLLJ frequency and intensity; DIAS_NLLJ.py produces daily maps for case-study analysis; and diascomjato.ipynb provides an interactive Jupyter notebook for exploratory workflows. The design emphasizes readability, parallel processing, and compatibility with NetCDF standards, ensuring that the package is suitable for both academic research and operational applications.

---
# Key Functionalities

The NLLJs package offers several key functionalities. It automates the download and preprocessing of ERA5 data for the South American domain and applies an objective methodology for identifying NLLJ events based on intensity and vertical shear criteria. It can generate climatological maps and time series to investigate long-term variability and also provides event-scale tools for analyzing the role of NLLJs in convective outbreaks. The package outputs export-ready datasets that integrate easily with visualization packages and climate diagnostics. By moving seamlessly from raw data to high-level products, the tool facilitates both discovery and reproducibility in scientific workflows.

# Limitations

Although the NLLJs package provides an accessible and standardized methodology, some limitations remain. The detection is currently restricted to isobaric levels between 900–650 hPa, and extending to model levels would improve vertical resolution. The workflow depends on ERA5 data availability, and adaptation to other reanalyses such as MERRA-2 or JRA-55 would require adjustments. The methodology is designed primarily for research use and may not capture all subtleties relevant to operational forecasting. Additionally, computational costs can be significant when processing multi-decadal datasets, although parallelization strategies help mitigate this issue. Future developments aim to extend compatibility with additional datasets, incorporate uncertainty quantification, and refine thresholds for applications in hydrometeorology and climate extremes.
# Detailed Example

### 1. Data preprocessing
```bash
bash run_JBNN.sh
```

### 2. Index computation
```Python
from nllj import compute_index
compute_index("era5_input.nc", "nllj_index.nc")
```

### 3. Visualization
```python Mapa_JBNN.py
```

# References
