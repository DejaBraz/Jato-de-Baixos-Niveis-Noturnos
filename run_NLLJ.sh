#!/bin/bash

#Dejanira F Braz

#Calculo do índice do JBNN
pathi="/data2/dejanira/JBNN/"

for mes in $(seq 1 12); do
cdo splitmonth ${pathi}/uwnd.${mes}.nc u.${mes}.
cdo splitmonth ${pathi}/vwnd.${mes}.nc v.${mes}.

##
done

for mes in $(seq 1 12); do
cdo -f nc2 mergetime u.${mes}.00.nc u.${mes}.06.nc u.${mes}.00-06.nc 
cdo -f nc2 mergetime u.${mes}.12.nc u.${mes}.18.nc u.${mes}.12-18.nc 
cdo -f nc2 mergetime v.${mes}.00.nc v.${mes}.06.nc v.${mes}.00-06.nc 
cdo -f nc2 mergetime v.${mes}.12.nc v.${mes}.18.nc v.${mes}.12-18.nc 

rm u.${mes}.00.nc
rm u.${mes}.06.nc
rm u.${mes}.12.nc
rm u.${mes}.18.nc
rm v.${mes}.00.nc
rm v.${mes}.06.nc
rm v.${mes}.12.nc
rm v.${mes}.18.nc

done
for mes in $(seq 1 12); do
#Tem que ter 2294 tempos
cdo -f nc2 daymean u.${mes}.00-06.nc u.${mes}.00-06_daymean.nc 
cdo -f nc2 daymean u.${mes}.12-18.nc u.${mes}.12-18_daymean.nc  
cdo -f nc2 daymean v.${mes}.00-06.nc v.${mes}.00-06_daymean.nc 
cdo -f nc2 daymean v.${mes}.12-18.nc v.${mes}.12-18_daymean.nc  
#


rm u.${mes}.00-06.nc
rm u.${mes}.12-18.nc
rm v.${mes}.00-06.nc
rm v.${mes}.12-18.nc
#
done

for mes in $(seq 1 12); do
echo
echo "Sera selecionado os dois niveis e depois sera feito a subtraçao dos arquivos da média horaria de cada dia, em niveis diferentes Fazendo X1=(u00_900hPa - u00_650hPa)"
cdo sellevel,900  u.${mes}.00-06_daymean.nc u.${mes}.00-06_900hPa_daymean.nc
cdo sellevel,650  u.${mes}.00-06_daymean.nc u.${mes}.00-06_650hPa_daymean.nc
cdo sub u.${mes}.00-06_900hPa_daymean.nc u.${mes}.00-06_650hPa_daymean.nc u.${mes}.00-06_900-650hPa_daymean.nc

echo
echo "Fazendo X2=(u12_900hPa - u12_650hPa)"
cdo sellevel,900  u.${mes}.12-18_daymean.nc u.${mes}.12-18_900hPa_daymean.nc
cdo sellevel,650  u.${mes}.12-18_daymean.nc u.${mes}.12-18_650hPa_daymean.nc
cdo sub u.${mes}.12-18_900hPa_daymean.nc u.${mes}.12-18_650hPa_daymean.nc u.${mes}.12-18_900-650hPa_daymean.nc

echo
echo "Fazendo X= X1-X2 "
cdo sub u.${mes}.00-06_900-650hPa_daymean.nc u.${mes}.12-18_900-650hPa_daymean.nc u.${mes}.x900-650hPa_daymean.nc

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




