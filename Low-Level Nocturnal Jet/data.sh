#!/bin/bash
# Author: Dejanira F. Braz
#
# Script to process FLEXPART output files:
#  - Convert FLEXPART ASCII .dat files to NetCDF (.nc)
#  - Apply grid remapping and latitude inversion
#  - Adjust calendar and time axis
#  - Scale values if needed
#  - Merge all yearly files into a single NetCDF file
#
# Requirements:
#   - Climate Data Operators (CDO) must be installed and available in $PATH

### Input and Output Directories (edit as needed) ###
# INPUT_DIR="/data2/ERA-5/"
# OUTPUT_DIR="/data2/FLEXPART/dejanira/USP/Janeiro/Argentina_particle/prec"
# cd ${INPUT_DIR}
# cp LLJ_******_backw_025degree.dat ${OUTPUT_DIR}

### Processing Loop ###
for year in $(seq 1980 2016); do
    echo "Processing year: ${year}"

    # 1. Convert .dat to .nc (global grid 1440x720)
    cdo -f nc input,r1440x720, LLJ_${year}02_backw_025degree.nc < LLJ_${year}02_backw_025degree.dat

    # 2. Remap and invert latitude using a reference grid ("dados")
    cdo remapbil,dados -invertlat LLJ_${year}02_backw_025degree.nc tmp.nc
    mv tmp.nc LLJ_${year}02_backw_025degree.nc

    # 3. Ensure consistent grid definition
    cdo setgrid,dados -invertlat LLJ_${year}02_backw_025degree.nc tmp.nc
    mv tmp.nc LLJ_${year}02_backw_025degree.nc

    # 4. Fix time axis (set calendar and starting time)
    cdo -r settaxis,${year}-02-29,18:00:00,1hours -setcalendar,standard \
        LLJ_${year}02_backw_025degree.nc tmp.nc
    mv tmp.nc LLJ_${year}02_backw_025degree.nc

    # 5. Remap to consistent global grid (1440x720)
    cdo remapbil,r1440x720, LLJ_${year}02_backw_025degree.nc tmp.nc
    mv tmp.nc LLJ_${year}02_backw_025degree.nc

    # 6. Scale values (example: multiply by -0.25)
    cdo mulc,-0.25 LLJ_${year}02_backw_025degree.nc tmp.nc
    mv tmp.nc LLJ_${year}02_backw_025degree.nc
done

### Merge all yearly NetCDF files into one ###
echo "Merging yearly NetCDF files into LLJ_02_backw.nc"
cdo mergetime *.nc LLJ_02_backw.nc

### Cleanup ###
echo "Removing original .dat files"
rm *.dat

echo "Processing completed!"
