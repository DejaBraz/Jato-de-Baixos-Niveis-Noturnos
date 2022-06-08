load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;load "/data2/FLEXPART/dejanira/Flexpart/Abril/BrasilSE/mapas/cmp_b2r.rgb"

begin

;-- read the data
;f_u = addfile("/data2/FLEXPART/dejanira/Flexpart/Janeiro/Argentina/mapas/uwnd.jan.nc","r") ;-- open file with read
;level_u = f_u->u
;uu = f_u->u(0,6,:,:) ;-- first time step


;f_v = addfile("/data2/FLEXPART/dejanira/Flexpart/Janeiro/Argentina/mapas/vwnd.jan.nc","r") ;-- open file with read
;level_v = f_v->v
;vv = f_v->v(0,6,:,:) ;-- first time step


f_llj = addfile("/data2/FLEXPART/dejanira/USP/Janeiro/Argentina_particle/media/Argentina_forw_comjato.nc","r") ;-- open file with read
llj = f_llj->var1


;;create plots;;
   wks_type = "pdf"
   ;wks_type@wkWidth = 2000
   ;wks_type@wkHeight = 2000
   wks = gsn_open_wks(wks_type,"BrasilSE_climatology_comjato")

        
        ;gsn_define_colormap(wks,"NCV_gebco")
        ;gsn_define_colormap(wks,"perc2_9lev")
        ;gsn_define_colormap(wks,"rainbow")
	;gsn_define_colormap(wks,"cmp_b2r")
	;gsn_define_colormap(wks,"GMT_jet")

        gsn_define_colormap(wks,"BlueWhiteOrangeRed")

        res                = True
        res@gsnDraw        = False   	;--don't draw the plot
        res@gsnFrame       = False	;--don't advance the frame	
        res@gsnMaximize    = False	;-- maxmize plot in frame
        res@tmXTOn         = False	;--no tick marks on top x-axis
        res@tmYROn         = True	;--no tick marks on top y-axis
        ;res@gsnLeftString = "NLLJ index (06UTC)" ; change left string
        res@gsnRightString = llj@units ;-- assign right string
        res@tiMainString   = "BrasilSE Oct"


; Mapa
        mpres                             = res
        mpres@mpGeophysicalLineThicknessF = 2          ;-- grosor de la linea contorno de continentes
       	mpres = True ; Habilita os recursos do mapa.;
	mpres@gsnMaximize = False ; A figura ocupa toda a página.
	mpres@gsnFrame = False ; Não avança o frame.;
	mpres@gsnDraw = False ; Não desenha.
	mpres@mpFillOn = False ; Mapa sem preenchimento.
	mpres@mpOutlineBoundarySets = "National" ; Mostra divisão dos países.
	mpres@mpDataSetName = "Earth..4" ; Para a mostrar a divisão dos estados
	mpres@mpDataBaseVersion = "MediumRes" ; brasileiros, são necessárias
	mpres@mpOutlineSpecifiers = (/"Brazil:states"/); estas três linhas.
	mpres@mpMinLatF = -60. ; Latitude sul.
	mpres@mpMaxLatF = 20. ; Latitude norte.
	mpres@mpMinLonF = -90. ; Longitude oeste.
	mpres@mpMaxLonF = -10. ; Longitude leste.
	mpres@gsnMajorLonSpacing = 10 ; Espaçamento do eixo x da longitude.
	mpres@gsnMajorLatSpacing = 10 ; Espaçamento do eixo y da latitude.
	mpres@tmXBMinorOn = False ; Desabilita os traços secundários dos
	mpres@tmYLMinorOn = False ; eixos x e y.
;Contorno
        cnres                             = res
        cnres@cnFillDrawOrder             = "PreDraw"   ;-- mostra contorno de mapa
        cnres@cnFillOn                    = True        ;-- don't draw contour fill
        cnres@cnLinesOn                   = False       ;-- don't draw contour lines
       
		cnres@pmLabelBarWidthF            = 0.65         ;-- escala cores
        cnres@pmLabelBarHeightF           = 0.08
        cnres@pmLabelBarOrthogonalPosF    = 0.1
        cnres@lbLabelFontHeightF          = 0.015 
        cnres@lbLabelAngleF               = 0

;selecciona escala de colores manual
   		cnres@cnLevelSelectionMode = "ExplicitLevels"     ; set manual contour levels
		;cnres@cnLevels    = (/ -5, -4.,-3.,-2., -1.,-0.5,0,0.5,1.,2.,3.,4.,5./)   ; set levels
		cnres@cnLevels    = (/-40,-35,-30.,-25.,-20, -10.,-5.,-2.5,-1.,-0.5,0,0.5,1.,2.5,5.,10.,20.,25.,30.,35,40/)   ; set levels
  		cnres@cnMinLevelValF       =  -30                ; set min contour level
 		cnres@cnMaxLevelValF       =  15                ; set max contour level
 		cnres@cnLevelSpacingF      = 1           ; set contour spacing
  		cnres@cnFillColors = (/2,15,25,30,33,49,55,65,70,76,86,0,0,161,165,177,191,209,215,220,225,230,255/)  ; set the colors to be used
  	       
  		
  		cnres@cnLinesOn = False ;-- turn lines on  lineas de contorno en cada nivel
       	        cnres@lbTitleOn = True ; Habilita um título para a legenda.
		cnres@lbTitleString = "(mm/day)" ; Título da legenda.
		cnres@lbTitleFontHeightF = 0.025 ; Tamanho da fonte do título da legenda.
		cnres@pmLabelBarOrthogonalPosF = 0.15 
		cnres@lbLabelFontHeightF = 0.025 ; Tamanho dos valores da; legenda.
;-- polymarker
		pmres = True
		
		pmres@gsMarkerIndex = 5 ;-- use marker 1
		pmres@gsMarkerSizeF = 0.02 ;-- set size of marker 
		;pmres@gsLineThicknessF = 10 ;-- marker line thickness
		pmres@gsMarkerThicknessF = 4  ;grosor figura

;Vectores
        res_vc                            = res
        res_vc@vcGlyphStyle               = "CurlyVector";Efeito de curvatura nos	; vetores.
        res_vc@vcLineArrowThicknessF      = 1	;--grosor de las flechas
       	res_vc@vcRefMagnitudeF = 40.0 ; Magnitude de vetor.
		res_vc@vcRefLengthF = 0.1 ; Comprimento do vetor.
		res_vc@vcMinDistanceF = 0.014 ; Espessura dos vetores.
		;res_vc@vcRefAnnoOrthogonalPosF = -0.43 
	
        wrf_smooth_2d (llj, 2) ;-- realizada suavizado

;Plot
        map     = gsn_csm_map(wks,mpres)
        contour = gsn_csm_contour(wks,llj(0,:,:),cnres)
        ;marker = gsn_add_polymarker(wks, map, -49, -22, pmres)  ; .outubro el pto maximo
        ;vector  = gsn_csm_vector(wks,uu,vv,res_vc)

;;overlay filled contours and vectors on the map;;
	
        overlay(map,contour)
        ;overlay(map,vector)


;;drawing "map" will draw everything: map, contours, vectors, and text;;
        draw(map)
        frame(wks)
end