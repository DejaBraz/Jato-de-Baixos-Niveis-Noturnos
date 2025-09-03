load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;load "/data2/FLEXPART/dejanira/Flexpart/Abril/BrasilSE/mapas/cmp_b2r.rgb"

begin
;************************************************
; Open files and read variables
;************************************************
  in1  = addfile("forw_comjato.SON.nc.nc","r")
  in2  = addfile("Arg.SON.ERA-INTERIM.nc","r")
  g    = addfile("landsea.nc","r")
  tmp1 = in1->var1    ; Time series
  tmp2 = in2->precip  ; Spatial data
  maskv = g->LSMASK

;************************************************
; Calculate cross correlations
;************************************************
  printVarSummary(tmp1) 
  printVarSummary(tmp2)

  x = tmp2
  y = tmp1
  printVarSummary(x) 
  printVarSummary(y) 

  r = escorc_n(x,y,0,0)
  printVarSummary(r)

  var_aux = tmp2(0,:,:)
  copy_VarCoords(var_aux,r)
  dim = dimsizes(tmp2)
  nt  = dim(0)

  prob = rtest(r,nt,0) 
  copy_VarCoords(var_aux,prob) ; Copy dimensions and coordinates from var_aux to prob

  printVarSummary(prob)
  printMinMax(prob,False)

;************************************************
; Mask
;************************************************
  mascara  = landsea_mask(maskv,r&lat,r&lon)
  so_oceano = mask(r,mascara.eq.0,False)
  copy_VarCoords(r,so_oceano)
  
  mascara1  = landsea_mask(maskv,prob&lat,prob&lon)
  so_oceano1 = mask(prob,mascara.eq.0,False)
  copy_VarCoords(prob,so_oceano1)

;************************************************
; Plot correlations
;************************************************
  plot = new(4,"graphic") 
  wks  = gsn_open_wks("pdf","Arg.SON.cor2")

  ;gsn_define_colormap(wks,"temp_diff_18lev")
  gsn_define_colormap(wks,"BkBlAqGrYeOrReViWh200")

  res                  = True                ; Plot resources
  res                  = True
  res@gsnMaximize      = False               ; Do not maximize plot
  ;res@mpFillOn        = False               ; Map without fill
  ;res@mpOutlineBoundarySets = "National"    ; Show country borders
  ;res@mpDataSetName   = "Earth..4"          ; To show states division
  ;res@mpDataBaseVersion = "MediumRes"       ; Required for Brazilian states
  ;res@mpOutlineSpecifiers = (/"Brazil:states"/)
  res@mpMaxLatF        = 20.0                ; Northern latitude
  res@mpMinLatF        = -56.0               ; Southern latitude
  res@mpMinLonF        = -90.0               ; Western longitude
  res@mpMaxLonF        = -20.0               ; Eastern longitude

  res@cnFillOn         = True                ; Enable color shading
  res@tiMainString     = "Seasonal Correlation"
  res@gsnCenterString  = "Dotted region: 95% significance."

  res@cnLinesOn        = False               ; Disable contour lines
  res@cnLevelSelectionMode = "ManualLevels"  ; Set contour levels manually
  res@cnLevels         = (/ -0.9,-0.8,-0.7,-0.6,-0.5,-0.4,-0.3,-0.2,-0.1,0, \
                             0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9/) 
  res@cnFillColors     = (/2,177,17,33,49,57,66,81,97,0,0,102,113,129,132,137,145,158,161,167/)   	
	
  res@cnMinLevelValF   = -0.9
  res@cnMaxLevelValF   =  0.9
  res@cnLevelSpacingF  =  0.1

  res@cnLabelBarEndStyle = "ExcludeOuterBoxes" ; Remove outer label bar boxes
  res@pmLabelBarWidthF   = 0.8

  lag = 0
  res@tiMainString  = "Correlations at lag "+lag
  plot1 = gsn_csm_contour_map(wks,so_oceano,res) 

;************************************************
; Significance test
;************************************************
  alfa = 0.129 ; Tabulated value for 95% significance with n = 90 = nt

  res2 = True
  res2@gsnFrame = False ; Do not advance frame
  res2@gsnDraw  = False ; Do not draw

  res2@cnLevelSelectionMode = "ExplicitLevels"
  res2@cnLinesOn        = False ; Disable contour lines
  res2@cnLineLabelsOn   = False ; Disable contour labels
  res2@cnFillScaleF     = 0.7   ; Density of dots in the map
                                 ; Smaller values → denser dots

  ; Create the probability map
  plot2 = gsn_csm_contour(wks,so_oceano1,res2)

  res2@cnLevelSelectionMode = "ManualLevels"
  res2@cnMinLevelValF = 0.2
  res2@cnMaxLevelValF = 1.0
  res2@cnLevelSpacingF = 0.1
  res2@cnLevelSelectionMode = "ExplicitLevels"
  res2@cnLevels = alfa
  res2@cnInfoLabelOn = False ; Disable contour info labels

  ; Fill all regions below alfa with pattern 17 (dotted)
  plot2 = ShadeLtContour(plot2,alfa,17)

  ; Overlay probability field on correlation field
  overlay (plot1, plot2)

  draw(wks)

end
