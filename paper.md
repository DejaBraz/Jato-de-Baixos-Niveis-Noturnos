Nocturnal Low-Level Jets (NLLJs) are atmospheric circulation features characterized by strong wind maxima in the lower troposphere during nighttime. They play a fundamental role in transporting heat and moisture, influencing rainfall patterns, severe weather, and climate variability across South America. Despite their importance, tools for their objective identification and visualization remain limited in accessibility and reproducibility.

**JBNN** is an open-source Python-based software that implements the NLLJ index proposed by Rife et al. (2010), adapted for isobaric coordinates (900–650 hPa), to identify and map nocturnal low-level jets over South America. The package provides a complete workflow — from downloading reanalysis data (ERA5), preprocessing, and index calculation, to visualization and case-study analysis. The software is distributed under the MIT License, ensuring free use and modification by the scientific community.

# Statement of need

Research on low-level jets in South America has traditionally relied on complex methodologies and reanalysis datasets, often requiring advanced expertise in atmospheric modeling and command-line tools. However, reproducible and user-friendly implementations are scarce. **JBNN** addresses this gap by:

- Offering a reproducible and transparent pipeline for NLLJ identification based on ERA5 data.  
- Providing ready-to-use scripts and notebooks for both climatological and case-study analysis.  
- Facilitating integration with Python scientific libraries (xarray, Cartopy, Matplotlib, NumPy).  
- Supporting reproducibility of climatological studies such as Braz et al. (2021).  

The tool is relevant for meteorologists, climate scientists, and data scientists interested in atmospheric dynamics, water cycle studies, and extreme weather events.

# Functionality

The repository provides the following modules and scripts:

- **Data acquisition**: `Download ERA.ipynb` retrieves ERA5 reanalysis datasets.  
- **Preprocessing**: `run_JBNN.sh` automates daily mean calculations, vertical shear extraction (900–650 hPa), and wind magnitude using Climate Data Operators (CDO).  
- **NLLJ index computation**: Implements the Rife et al. (2010) formulation adapted to isobaric levels.  
- **Visualization**:  
  - `Mapa JBNN.py`: plots maps of the NLLJ index with shapefiles of Brazilian states and South American basins.  
  - `DIAS_NLLJ.py`: generates daily frequency maps of NLLJ occurrences.  
  - `diascomjato.ipynb`: notebook demonstrating case studies.  

The workflow ensures that researchers can replicate climatologies and identify NLLJ cores across South America in a straightforward and automated way.

# Example

An example workflow is as follows:

```bash
# Run preprocessing for ERA5 data
bash run_JBNN.sh

# Plot the seasonal climatology
python Mapa\ JBNN.py
