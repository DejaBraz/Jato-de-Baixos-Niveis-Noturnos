load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;load "/data2/FLEXPART/dejanira/Flexpart/Abril/BrasilSE/mapas/cmp_b2r.rgb"

  begin
;************************************************
; open file and read in variable
;***********************************************
  in1  = addfile("forw_comjato.SON.nc.nc","r")
  in2  = addfile("Arg.SON.ERA-INTERIM.nc","r")
  g = addfile("landsea.nc","r")
  tmp1 = in1->var1    ; S�rie temporal.
  tmp2 = in2->precip  ; Dado espacial.
  maskv = g->LSMASK
;************************************************
; calculate cross correlations
;************************************************
  printVarSummary(tmp1) 
  printVarSummary(tmp2)

  x= tmp2
  y= tmp1
  printVarSummary(x) 
  printVarSummary(y) 
  r = escorc_n(x,y,0,0)
  printVarSummary(r)
  var_aux = tmp2(0,:,:)
  copy_VarCoords(var_aux,r)
  dim = dimsizes(tmp2)
  nt = dim(0)
  prob = rtest(r,nt,0) 
  copy_VarCoords(var_aux,prob) ; Copia as dimens�es e as coordenadas de
; var_aux para prob.

 printVarSummary(prob)
 printMinMax(prob,False)
;************************************************
; mask
;************************************************
  mascara = landsea_mask(maskv,r&lat,r&lon)
  so_oceano = mask(r,mascara.eq.0,False)
  copy_VarCoords(r,so_oceano)
  
  mascara1 = landsea_mask(maskv,prob&lat,prob&lon)
  so_oceano1 = mask(prob,mascara.eq.0,False)
  copy_VarCoords(prob,so_oceano1)

;************************************************
; plot the correlations
;************************************************
  plot = new(4,"graphic") 
  wks  = gsn_open_wks("pdf","Arg.SON.cor2")
  ;gsn_define_colormap(wks,"temp_diff_18lev")
  gsn_define_colormap(wks,"BkBlAqGrYeOrReViWh200")

  res                      = True                ; make plot mods
  res = True ; Habilita os recursos do mapa.;
  res@gsnMaximize = False ; A figura ocupa toda a p�gina.
  ;res@mpFillOn = False ; Mapa sem preenchimento.
  ;res@mpOutlineBoundarySets = "National" ; Mostra divis�o dos pa�ses.
  ;res@mpDataSetName = "Earth..4" ; Para a mostrar a divis�o dos estados
  ;res@mpDataBaseVersion = "MediumRes" ; Brasileiros, s�o necess�rias
  ;res@mpOutlineSpecifiers = (/"Brazil:states"/); estas tr�s linhas.
  res@mpMaxLatF = 20.0 ; Latitude sul.
  res@mpMinLatF = -56.0 ; Latitude norte.
  res@mpMinLonF = -90.0 ; Longitude oeste.
  res@mpMaxLonF = -20.0 ; Longitude leste.

  res@cnFillOn             = True                ; turn on color
  ;res@cnFillPalette        = "BlWhRe"            ; set color map
  res@tiMainString = "Seasonal Correlation"
  res@gsnCenterString = "Dotted region: 95% significance."

  res@cnLinesOn            = False               ; turn off contour lines
  res@cnLevelSelectionMode = "ManualLevels"      ; manually set cn levels
  ;res@cnLevels = ispan(-9,9,1)/10.
  res@cnLevels    = (/ -0.9,-0.8,-0.7,-0.6,-0.5,-0.4,-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9/) 
  res@cnFillColors = (/2,177,17,33,49,57,66,81,97,0,0,102,113,129,132,137,145,158,161,167/)   	
	
  res@cnMinLevelValF       = -0.9                 ; min level
  res@cnMaxLevelValF       =  0.9                 ; max level
  res@cnLevelSpacingF      = .1                  ; contour level spacing

  res@cnLabelBarEndStyle   = "ExcludeOuterBoxes" ; remove the two end boxes from the labelbar
  res@pmLabelBarWidthF     = 0.8

  lag                      = 0
  res@tiMainString         = "Correlations at lag "+lag
  plot1 = gsn_csm_contour_map(wks,so_oceano,res) 
;************************************************
  alfa = 0.129 ; Valor tabelado para 95% de signific�ncia e n = 90 = nt.

 res2 = True
 res2@gsnFrame = False ; N�o avan�a o frame.
 res2@gsnDraw = False ; N�o desenha.
 ; Defino a escala dos contornos do meu jeito.
 res2@cnLevelSelectionMode = "ExplicitLevels"
 res2@cnLinesOn = False ; Desabilita as linhas de contorno.
 res2@cnLineLabelsOn = False ; Desabilita os r�tulos dos contornos.
 res2@cnFillScaleF = 0.7 ; Densidade do pontilhado
 ; no mapa. Quanto menor o valor,
 ; maior ser� a densidade de pontos.
 
  ; Cria o mapa da probabilidade.
 plot2 = gsn_csm_contour(wks,so_oceano1,res2)

 res2@cnLevelSelectionMode = "ManualLevels"
 res2@cnMinLevelValF = 0.2
 res2@cnMaxLevelValF = 1.0
 res2@cnLevelSpacingF = 0.1
 res2@cnLevelSelectionMode = "ExplicitLevels"
 res2@cnLevels = alfa
 res2@cnInfoLabelOn = False ; Desabilita as informa��es de
 ; contorno.
 

 ; Preenche todas as regi�es menores do que alfa com
 ; o padr�o 17 (pontilhado). 
 plot2 = ShadeLtContour(plot2,alfa,17)

 overlay (plot1, plot2) ; Sobrep�e os campos, plot2 sobre o plot1.

 draw(wks)

end
