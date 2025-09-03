#!/bin/bash

# Author: Dejanira F Braz

# Calculation of the NLLJ Index
pathi="/data2/dejanira/JBNN/"

# Step 1: Split data by month
for month in $(seq 1 12); do
  cdo splitmonth ${pathi}/uwnd.${month}.nc u.${month}.
  cdo splitmonth ${pathi}/vwnd.${month}.nc v.${month}.
done

# Step 2: Merge time for 00-06h and 12-18h
for month in $(seq 1 12); do
  cdo -f nc2 mergetime u.${month}.00.nc u.${month}.06.nc u.${month}.00-06.nc 
  cdo -f nc2 mergetime u.${month}.12.nc u.${month}.18.nc u.${month}.12-18.nc 
  cdo -f nc2 mergetime v.${month}.00.nc v.${month}.06.nc v.${month}.00-06.nc 
  cdo -f nc2 mergetime v.${month}.12.nc v.${month}.18.nc v.${month}.12-18.nc 

  rm u.${month}.??.nc v.${month}.??.nc
done

# Step 3: Daily means
for month in $(seq 1 12); do
  cdo -f nc2 daymean u.${month}.00-06.nc u.${month}.00-06_daymean.nc 
  cdo -f nc2 daymean u.${month}.12-18.nc u.${month}.12-18_daymean.nc  
  cdo -f nc2 daymean v.${month}.00-06.nc v.${month}.00-06_daymean.nc 
  cdo -f nc2 daymean v.${month}.12-18.nc v.${month}.12-18_daymean.nc  

  rm u.${month}.00-06.nc u.${month}.12-18.nc v.${month}.00-06.nc v.${month}.12-18.nc
done

# Step 4: Vertical wind shear and index calculation
for month in $(seq 1 12); do
  echo "Selecting two levels and computing differences: X1=(u00_900hPa - u00_650hPa)"
  cdo sellevel,900 u.${month}.00-06_daymean.nc u.${month}.00-06_900hPa_daymean.nc
  cdo sellevel,650 u.${month}.00-06_daymean.nc u.${month}.00-06_650hPa_daymean.nc
  cdo sub u.${month}.00-06_900hPa_daymean.nc u.${month}.00-06_650hPa_daymean.nc u.${month}.00-06_900-650hPa_daymean.nc

  echo "Computing X2=(u12_900hPa - u12_650hPa)"
  cdo sellevel,900 u.${month}.12-18_daymean.nc u.${month}.12-18_900hPa_daymean.nc
  cdo sellevel,650 u.${month}.12-18_daymean.nc u.${month}.12-18_650hPa_daymean.nc
  cdo sub u.${month}.12-18_900hPa_daymean.nc u.${month}.12-18_650hPa_daymean.nc u.${month}.12-18_900-650hPa_daymean.nc

  echo "Computing X = X1 - X2"
  cdo sub u.${month}.00-06_900-650hPa_daymean.nc u.${month}.12-18_900-650hPa_daymean.nc u.${month}.x900-650hPa_daymean.nc
  cdo sqr u.${month}.x900-650hPa_daymean.nc u.${month}.x2_900-650hPa_daymean.nc

  echo "Computing Y1 and Y2 for v-component, then Y = Y1 - Y2"
  cdo sellevel,900 v.${month}.00-06_daymean.nc v.${month}.00-06_900hPa_daymean.nc
  cdo sellevel,650 v.${month}.00-06_daymean.nc v.${month}.00-06_650hPa_daymean.nc
  cdo sub v.${month}.00-06_900hPa_daymean.nc v.${month}.00-06_650hPa_daymean.nc v.${month}.00-06_900-650hPa_daymean.nc

  cdo sellevel,900 v.${month}.12-18_daymean.nc v.${month}.12-18_900hPa_daymean.nc
  cdo sellevel,650 v.${month}.12-18_daymean.nc v.${month}.12-18_650hPa_daymean.nc
  cdo sub v.${month}.12-18_900hPa_daymean.nc v.${month}.12-18_650hPa_daymean.nc v.${month}.12-18_900-650hPa_daymean.nc

  cdo sub v.${month}.00-06_900-650hPa_daymean.nc v.${month}.12-18_900-650hPa_daymean.nc v.${month}.x_900-650hPa_daymean.nc
  cdo sqr v.${month}.x_900-650hPa_daymean.nc v.${month}.x2_900-650hPa_daymean.nc

  echo "Computing sqrt(X² + Y²)"
  cdo add u.${month}.x2_900-650hPa_daymean.nc v.${month}.x2_900-650hPa_daymean.nc con.${month}.x2y2_900-650hPa_daymean.nc
  cdo sqrt con.${month}.x2y2_900-650hPa_daymean.nc con.${month}.sqrtx2y2_900-650hPa_daymean.nc

  echo "Wind speed at 900 hPa (00-06h = V1, 12-18h = V2) and at 650 hPa (00-06h = V3)"
  # V1
  cdo sqr u.${month}.00-06_900hPa_daymean.nc u.${month}.00-06_900hPa_daymean_sqr.nc
  cdo sqr v.${month}.00-06_900hPa_daymean.nc v.${month}.00-06_900hPa_daymean_sqr.nc
  cdo add u.${month}.00-06_900hPa_daymean_sqr.nc v.${month}.00-06_900hPa_daymean_sqr.nc soma1.nc
  cdo sqrt soma1.nc windmag.${month}.00-06_900hPa_daymean_sqr.nc

  # V2
  cdo sqr u.${month}.12-18_900hPa_daymean.nc u.${month}.12-18_900hPa_daymean_sqr.nc
  cdo sqr v.${month}.12-18_900hPa_daymean.nc v.${month}.12-18_900hPa_daymean_sqr.nc
  cdo add u.${month}.12-18_900hPa_daymean_sqr.nc v.${month}.12-18_900hPa_daymean_sqr.nc soma2.nc 
  cdo sqrt soma2.nc windmag.${month}.12-18_900hPa_daymean_sqr.nc

  # V3
  cdo sqr u.${month}.00-06_650hPa_daymean.nc u.${month}.00-06_650hPa_daymean_sqr.nc
  cdo sqr v.${month}.00-06_650hPa_daymean.nc v.${month}.00-06_650hPa_daymean_sqr.nc
  cdo add u.${month}.00-06_650hPa_daymean_sqr.nc v.${month}.00-06_650hPa_daymean_sqr.nc soma3.nc 
  cdo sqrt soma3.nc windmag.${month}.00-06_650hPa_daymean_sqr.nc

  rm u.${month}.* v.${month}.*

  echo "Comparing V1 vs V2 and V1 vs V3"
  cdo gt windmag.${month}.00-06_900hPa_daymean_sqr.nc windmag.${month}.12-18_900hPa_daymean_sqr.nc lambda.nc
  cdo gt windmag.${month}.00-06_900hPa_daymean_sqr.nc windmag.${month}.00-06_650hPa_daymean_sqr.nc phi.nc

  echo "Calculating the index"
  cdo mul phi.nc lambda.nc constant.nc
  cdo mul constant.nc con.${month}.sqrtx2y2_900-650hPa_daymean.nc index.${month}.nc

  cdo monmean index.${month}.nc index_monmean.${month}.nc
  cdo timmean index.${month}.nc jet.${month}.nc

  rm windmag.* con.* 
done
echo
echo "Fazendo X ao quadrado"
cdo sqr u.${mes}.x900-650hPa_daymean.nc u.${mes}.x2_900-650hPa_daymean.nc


echo
echo
echo "Fazendo Y1=(v00_900hPa - v00_650hPa)"
cdo sellevel,900  v.${mes}.00-06_daymean.nc v.${mes}.00-06_900hPa_daymean.nc
cdo sellevel,650  v.${mes}.00-06_daymean.nc v.${mes}.00-06_650hPa_daymean.nc
cdo sub v.${mes}.00-06_900hPa_daymean.nc v.${mes}.00-06_650hPa_daymean.nc v.${mes}.00-06_900-650hPa_daymean.nc


echo
echo "Fazendo Y2=(v12_900hPa - v12_650hPa)"
cdo sellevel,900  v.${mes}.12-18_daymean.nc v.${mes}.12-18_900hPa_daymean.nc
cdo sellevel,650  v.${mes}.12-18_daymean.nc v.${mes}.12-18_650hPa_daymean.nc
cdo sub v.${mes}.12-18_900hPa_daymean.nc v.${mes}.12-18_650hPa_daymean.nc v.${mes}.12-18_900-650hPa_daymean.nc

echo
echo "Fazendo Y= Y1-Y2"
cdo sub v.${mes}.00-06_900-650hPa_daymean.nc v.${mes}.12-18_900-650hPa_daymean.nc v.${mes}.x_900-650hPa_daymean.nc

echo
echo "Fazendo Y ao quadrado"
cdo sqr v.${mes}.x_900-650hPa_daymean.nc v.${mes}.x2_900-650hPa_daymean.nc



echo
echo
echo "Fazendo  a soma de X ao quadrado mais Y ao quadrado"
cdo add u.${mes}.x2_900-650hPa_daymean.nc v.${mes}.x2_900-650hPa_daymean.nc con.${mes}.x2y2_900-650hPa_daymean.nc

echo "Fazendo a raiz de x2+y2" 
cdo sqrt con.${mes}.x2y2_900-650hPa_daymean.nc con.${mes}.sqrtx2y2_900-650hPa_daymean.nc




#########

echo
echo
echo "Fazendo o calculo da velocidade do vento da média das 00hs_06hs no nivel de 900hPa = V1"

cdo sqr u.${mes}.00-06_900hPa_daymean.nc u.${mes}.00-06_900hPa_daymean_sqr.nc
cdo sqr v.${mes}.00-06_900hPa_daymean.nc v.${mes}.00-06_900hPa_daymean_sqr.nc
cdo add u.${mes}.00-06_900hPa_daymean_sqr.nc v.${mes}.00-06_900hPa_daymean_sqr.nc soma1.nc
cdo sqrt soma1.nc windmag.${mes}.00-06_900hPa_daymean_sqr.nc


echo
echo
echo "Fazendo o calculo da velocidade do vento da média das 12hs_18hs no nivel de 900hPa = V2"

cdo sqr u.${mes}.12-18_900hPa_daymean.nc u.${mes}.12-18_900hPa_daymean_sqr.nc
cdo sqr v.${mes}.12-18_900hPa_daymean.nc v.${mes}.12-18_900hPa_daymean_sqr.nc
cdo add u.${mes}.12-18_900hPa_daymean_sqr.nc v.${mes}.12-18_900hPa_daymean_sqr.nc soma2.nc 
cdo sqrt soma2.nc windmag.${mes}.12-18_900hPa_daymean_sqr.nc


echo
echo
echo "Fazendo o calculo da velocidade do vento da média das 00hs_06hs no nivel de 650hPa = V3"

cdo sqr u.${mes}.00-06_650hPa_daymean.nc u.${mes}.00-06_650hPa_daymean_sqr.nc
cdo sqr v.${mes}.00-06_650hPa_daymean.nc v.${mes}.00-06_650hPa_daymean_sqr.nc
cdo add u.${mes}.00-06_650hPa_daymean_sqr.nc v.${mes}.00-06_650hPa_daymean_sqr.nc soma3.nc 
cdo sqrt soma3.nc windmag.${mes}.00-06_650hPa_daymean_sqr.nc

rm u.${mes}.*
rm v.${mes}.*

echo
echo
echo "Comparando o V1 com o V2 e o V1 com o V3 "

cdo gt windmag.${mes}.00-06_900hPa_daymean_sqr.nc windmag.${mes}.12-18_900hPa_daymean_sqr.nc lambida.nc

cdo gt windmag.${mes}.00-06_900hPa_daymean_sqr.nc windmag.${mes}.00-06_650hPa_daymean_sqr.nc phi.nc



echo
echo
echo "CALCULANDO O INDICE"

cdo mul phi.nc lambida.nc constante.nc

cdo mul constante.nc con.${mes}.sqrtx2y2_900-650hPa_daymean.nc indice.${mes}.nc


echo
#echo "Calculo da média mensal"

cdo monmean indice.${mes}.nc indice_monmean.${mes}.nc


echo
echo
echo "Calculo da média anual"
cdo timmean indice.${mes}.nc jato.${mes}.nc
#


rm windmag.*
rm con.*
#rm indice_monmean.${mes}.nc
#
#

done




