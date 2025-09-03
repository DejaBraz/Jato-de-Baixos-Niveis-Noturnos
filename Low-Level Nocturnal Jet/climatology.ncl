load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;load "/data2/FLEXPART/dejanira/Flexpart/Abril/BrasilSE/mapas/cmp_b2r.rgb"
;Author : Dejanira F. Braz
begin

;-- read the data
;f_u = addfile("/data2/FLEXPART/dejanira/Flexpart/Janeiro/Argentina/mapas/uwnd.jan.nc","r") ;-- open file for reading
;level_u = f_u->u
;uu = f_u->u(0,6,:,:) ;-- first time step

;f_v = addfile("/data2/FLEXPART/dejanira/Flexpart/Janeiro/Argentina/mapas/vwnd.jan.nc","r") ;-- open file for reading
;level_v = f_v->v
;vv = f_v->v(0,6,:,:) ;-- first time step

f_llj = addfile("/data2/FLEXPART/dejanira/USP/Janeiro/Argentina_particle/media/Argentina_forw_comjato.nc","r") ;-- open file for reading
llj = f_llj->var1

;; create plots ;;
   wks_type = "pdf"
   wks = gsn_open_wks(wks_type,"BrasilSE_climatology_comjato")

   ;gsn_define_colormap(wks,"NCV_gebco")
   ;gsn_define_colormap(wks,"perc2_9lev")
   ;gsn_define_colormap(wks,"rainbow")
   ;gsn_define_colormap(wks,"cmp_b2r")
   ;gsn_define_colormap(wks,"GMT_jet")

   gsn_define_colormap(wks,"BlueWhiteOrangeRed")

   res                = True
   res@gsnDraw        = False   	;-- don't draw the plot
   res@gsnFrame       = False	    ;-- don't advance the frame	
   res@gsnMaximize    = False	    ;-- maximize plot in frame
   res@tmXTOn         = False	    ;-- no tick marks on top x-axis
   res@tmYROn         = True	    ;-- tick marks on right y-axis
   ;res@gsnLeftString = "NLLJ index (06UTC)" ; change left string
   res@gsnRightString = llj@units   ;-- assign right string
   res@tiMainString   = "BrasilSE Oct"

; Map
   mpres                             = res
   mpres@mpGeophysicalLineThicknessF = 2          ;-- continent outline thickness
   mpres = True                      ;-- enable map resources
   mpres@gsnMaximize = False         ;-- figure does not fill the page
   mpres@gsnFrame = False            ;-- do not advance the frame
   mpres@gsnDraw = False             ;-- do not draw
   mpres@mpFillOn = False            ;-- no map fill
   mpres@mpOutlineBoundarySets = "National" ;-- show country boundaries
   mpres@mpDataSetName = "Earth..4" 
   mpres@mpDataBaseVersion = "MediumRes" 
   mpres@mpOutlineSpecifiers = (/"Brazil:states"/) ;-- show Brazilian state boundaries
   mpres@mpMinLatF = -60.            ;-- southern latitude
   mpres@mpMaxLatF = 20.             ;-- northern latitude
   mpres@mpMinLonF = -90.            ;-- western longitude
   mpres@mpMaxLonF = -10.            ;-- eastern longitude
   mpres@gsnMajorLonSpacing = 10     ;-- longitude axis spacing
   mpres@gsnMajorLatSpacing = 10     ;-- latitude axis spacing
   mpres@tmXBMinorOn = False         ;-- disable minor ticks on x-axis
   mpres@tmYLMinorOn = False         ;-- disable minor ticks on y-axis

; Contour
   cnres                             = res
   cnres@cnFillDrawOrder             = "PreDraw"   ;-- draw before map outlines
   cnres@cnFillOn                    = True        ;-- enable contour fill
   cnres@cnLinesOn                   = False       ;-- disable contour lines
   
   cnres@pmLabelBarWidthF            = 0.65        ;-- colorbar width
   cnres@pmLabelBarHeightF           = 0.08        ;-- colorbar height
   cnres@pmLabelBarOrthogonalPosF    = 0.1
   cnres@lbLabelFontHeightF          = 0.015 
   cnres@lbLabelAngleF               = 0

   ; set manual contour levels
   cnres@cnLevelSelectionMode = "ExplicitLevels"    
   cnres@cnLevels    = (/-40,-35,-30.,-25.,-20, -10.,-5.,-2.5,-1.,-0.5,0,0.5,1.,2.5,5.,10.,20.,25.,30.,35,40/) 
   cnres@cnMinLevelValF       = -30                
   cnres@cnMaxLevelValF       =  15                
   cnres@cnLevelSpacingF      = 1           
   cnres@cnFillColors = (/2,15,25,30,33,49,55,65,70,76,86,0,0,161,165,177,191,209,215,220,225,230,255/)  
   cnres@cnLinesOn = False                 ;-- disable contour lines
   cnres@lbTitleOn = True                  ;-- enable colorbar title
   cnres@lbTitleString = "(mm/day)"        ;-- colorbar title
   cnres@lbTitleFontHeightF = 0.025        ;-- title font size
   cnres@pmLabelBarOrthogonalPosF = 0.15 
   cnres@lbLabelFontHeightF = 0.025        ;-- label font size

; Polymarker
   pmres = True
   pmres@gsMarkerIndex = 5                 ;-- marker type
   pmres@gsMarkerSizeF = 0.02              ;-- marker size
   ;pmres@gsLineThicknessF = 10 
   pmres@gsMarkerThicknessF = 4            ;-- marker thickness

; Vectors
   res_vc                            = res
   res_vc@vcGlyphStyle               = "CurlyVector" ;-- curly vector style
   res_vc@vcLineArrowThicknessF      = 1             ;-- arrow thickness
   res_vc@vcRefMagnitudeF            = 40.0          ;-- reference magnitude
   res_vc@vcRefLengthF               = 0.1           ;-- reference arrow length
   res_vc@vcMinDistanceF             = 0.014         ;-- minimum distance between vectors

   wrf_smooth_2d (llj, 2) ;-- smoothing applied

; Plot
   map     = gsn_csm_map(wks,mpres)
   contour = gsn_csm_contour(wks,llj(0,:,:),cnres)
   ;marker = gsn_add_polymarker(wks, map, -49, -22, pmres)  ; October max point
   ;vector  = gsn_csm_vector(wks,uu,vv,res_vc)

;; overlay filled contours and vectors on the map ;;
   overlay(map,contour)
   ;overlay(map,vector)

;; drawing "map" will draw everything: map, contours, vectors, and text ;;
   draw(map)
   frame(wks)
end
