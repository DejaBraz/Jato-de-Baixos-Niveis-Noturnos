#!/bin/bash
# Dejanira F. Braz
#Programa para formatar os dados de .dat para .nc,fazer mascara

#converte de .dat para .nc

###Diretorio inicial###
#pathi="/data2/ERA-5/"

###Diretorio final###
#patho="/data2/FLEXPART/dejanira/USP/Janeiro/Argentina_particle/prec"
#cd ${pathi} 
#cp LLJ_******_backw_025degree.dat ${patho}
for year in $(seq 1980 2016); do

cdo -f nc input,r1440x720, LLJ_${year}02_backw_025degree.nc <  LLJ_${year}02_backw_025degree.dat
cdo remapbil,dados -invertlat LLJ_${year}02_backw_025degree.nc teste.nc
mv teste.nc LLJ_${year}02_backw_025degree.nc
cdo setgrid,dados -invertlat LLJ_${year}02_backw_025degree.nc teste.nc
mv teste.nc LLJ_${year}02_backw_025degree.nc
cdo -r settaxis,${year}-02-29,18:00:00,1hours -setcalendar,standard LLJ_${year}02_backw_025degree.nc teste.nc
mv teste.nc LLJ_${year}02_backw_025degree.nc
cdo remapbil,r1440x720, LLJ_${year}02_backw_025degree.nc teste.nc
mv teste.nc LLJ_${year}02_backw_025degree.nc
cdo mulc,-0.25 LLJ_${year}02_backw_025degree.nc teste.nc
mv teste.nc LLJ_${year}02_backw_025degree.nc
done

cdo mergetime *.nc LLJ_02_backw.nc
rm *.dat


