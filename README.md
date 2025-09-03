
# Nocturnal Low-Level Jets

[![DOI](https://img.shields.io/badge/DOI-10.3389/fenvs.2021.657764-informational?style=flat&logo=doi&logoColor=white&color=CC2927)](https://doi.org/10.3389/fenvs.2021.657764)
![Python](https://img.shields.io/badge/python-3.9+-blue?style=flat&logo=python&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)
![Conda](https://img.shields.io/badge/environment-conda-orange?logo=anaconda)



## Identification

The identification of the NLLJ follows the method proposed by Rife et al. (2010), which evaluates the temporal evolution of a vertical structure of horizontal wind (zonal and meridional components, *u* and *v*, respectively) according to the expression:

$$
\text{NLLJ} = \lambda \, \phi \, \sqrt{\left[(U_{00}^{L1} - U_{00}^{L2}) - (U_{12}^{L1} - U_{12}^{L2})\right]^2 + \left[(V_{00}^{L1} - V_{00}^{L2}) - (V_{12}^{L1} - V_{12}^{L2})\right]^2}
$$

where the subscripts `00` and `12` correspond, respectively, to 00:00 (midnight) and 12:00 (noon) local time (LT); L1 and L2 represent, respectively, the near-surface level (originally 500 m AGL) and the mid-level (originally 4000 m AGL); λ and φ are binary indicators that compare, respectively, the temporal evolution of wind speed and its vertical shear.

Lambda is defined as:

$$
\lambda =
\begin{cases}
0, & \text{if } W_{00}^{L1} \leq W_{12}^{L1} \\
1, & \text{if } W_{00}^{L1} > W_{12}^{L1}
\end{cases}
$$

That is, λ compares the near-surface wind speed (W) at midnight LT and at noon LT. According to the equation, λ = 1 indicates that the near-surface wind speed at midnight LT is greater than at noon LT; otherwise, λ = 0.

Similarly, φ is defined as:

$$
\phi =
\begin{cases}
0, & \text{if } W_{00}^{L1} \leq W_{00}^{L2} \\
1, & \text{if } W_{00}^{L1} > W_{00}^{L2}
\end{cases}
$$

That is, φ compares the near-surface wind speed (L1) and the mid-level wind speed (L2) at midnight LT. φ = 1 requires that the near-surface wind speed be greater than that at mid-levels; otherwise, φ = 0. In this way, φ ensures the existence of a vertical jet-like structure at midnight LT.

---

## Adaptation for This Study

For the present study, the NLLJ index is adapted using vertical levels in an isobaric coordinate system instead of altitude, as originally proposed by Rife et al. (2010), or sigma levels, as in Algarra et al. (2019).  

- The two pressure levels selected for calculating the NLLJ index are **900 and 650 hPa**, corresponding approximately to 1,000 and 4,000 m above sea level, respectively.  
- These two levels proved to be more suitable for defining a vertical jet structure at midnight than other tested two-level combinations in the region (1000–650, 1000–700, 1000–750, 1000–850, 1000–900, 900–850, 900–700, 900–650, 850–650, and 850–700 hPa; not shown).  
- With these combinations, it was possible to verify that NLLJ cores for the six regions are more evident (stronger) when using the 900–650 hPa levels.  

Thus, the levels that best represent the NLLJ indices in South America in terms of spatial scale and wind speed intensity are 900–650 hPa.  

The wind components at 00:00 LT are obtained by averaging **00:00 and 06:00 UTC** (~21:00 and 03:00 LT in most of the continent), while 12:00 LT is given by the average of **12:00 and 18:00 UTC** (~09:00 and 15:00 LT in most of the continent).  

Using these adaptations, the NLLJ index is calculated for each grid point using **ERA-Interim data** over South America, which allows the identification of regions with NLLJ activity.  

The application of the equation results in a **daily NLLJ index**, which is used to obtain the **seasonal climatology** of the NLLJ and the associated **moisture sources and sinks** for the selected areas with high frequency of NLLJ occurrence.

## License
This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

## Practical Usage

To reproduce the analysis, follow these steps:

1. **Create an account at the Copernicus Climate Data Store (CDS)**  
   - Register for free at [CDS Registration](https://cds.climate.copernicus.eu/user/register).  
   - Once registered, generate your **API key** (`.cdsapirc` file) following the instructions at:  
     [CDS API: How to use](https://cds.climate.copernicus.eu/api-how-to).  

2. **Download ERA5 data**  
   - Install the CDS API client in Python:  
     ```bash
     pip install cdsapi
     ```  
   - Use the CDS API to download the required ERA5 reanalysis variables (u- and v-wind components) at the pressure levels of interest (900 and 650 hPa).  
   - An example Python script is provided in this repository to automate the download process.  

3. **Run the NLLJ index calculation**  
   - Execute the processing script:  
     ```bash
     bash run_NLLJ.sh
     ```  
   - This script calculates the **daily NLLJ index** for each grid point based on ERA5 data.  

4. **Plot the results**  
   - Once the index is computed, use the provided Python plotting scripts to visualize the **spatial distribution**, **seasonal climatology**, and other diagnostics of the NLLJ over South America.  

---
