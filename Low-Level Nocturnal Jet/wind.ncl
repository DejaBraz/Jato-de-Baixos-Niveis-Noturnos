load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
function add_robinson_labels(wks,map,latspc,lonspc)
local lat_values, lon_values, lat_labels, lon_labels, \
      nlat, nlon, txres, x_in, y_in, x_out, y_out
begin
  minlat =  -90
  maxlat =   90
  minlon = -180
  maxlon =  180

;-- pick some "nice" values for the latitude labels
  lat_values = ispan(minlat,maxlat,latspc) * 1.
  lon_values = ispan(minlon,maxlon,lonspc) * 1.
  nlat       = dimsizes(lat_values)
  nlon       = dimsizes(lon_values)

;-- create the labels; add space before right labels, and after left labels
  lat_labels = where(lat_values.lt.0,abs(lat_values)+"~S~o~N~S",lat_values+"~S~o~N~N")
  lat_labels = where(lat_values.eq.0,"0~S~o~N~",lat_labels)
  lat_labels = where(abs(lat_values).eq.90,"",lat_labels) ;-- no label at lat=abs(90)

;---------------------
;-- latitude labels
;---------------------
  txres                  =  True     ;-- set text resources
  txres@txFontHeightF    =  0.008
  txres@txFontThicknessF =  2

  y_in  = lat_values                         ;-- plot coordinates
  x_in  = new(dimsizes(y_in),float)          ;-- plot coordinates
  x_out = new(dimsizes(x_in),float)          ;-- for NDC coordinates
  y_out = new(dimsizes(y_in),float)          ;-- for NDC coordinates
  
;-- left latitude labels
  txres@txJust = "CenterRight"
  x_in = -180.0
  datatondc(map,x_in,y_in,x_out,y_out)
  gsn_text_ndc(wks, lat_labels, x_out-0.012, y_out, txres)

;-- right latitude labels
  txres@txJust = "CenterLeft"
  x_in = 180.0
  datatondc(map,x_in,y_in,x_out,y_out)
  gsn_text_ndc(wks, lat_labels, x_out+0.012, y_out, txres)

;---------------------
;-- longitude labels
;---------------------
  lon_labels = where(lon_values.lt.0,abs(lon_values)+"~S~o~N~W",lon_values+"~S~o~N~E")
  lon_labels = where(lon_values.eq.0,"0~S~o~N~",lon_labels)
  lon_labels = where(abs(lon_values).eq.180,"",lon_labels) ;-- no label at lon=abs(180)

;-- longitude labels
  txres@txJust           = "CenterCenter"
  txres@txFontHeightF    =  0.008
  txres@txFontThicknessF =  2
  
  x_in  := lon_values
  y_in  := new(dimsizes(x_in),float)
  x_out := new(dimsizes(x_in),float)
  y_out := new(dimsizes(y_in),float)
  
;-- add top longitude labels
  y_in = 90.0
  datatondc(map,x_in,y_in,x_out,y_out)
  gsn_text_ndc(wks, lon_labels, x_out, y_out+0.012, txres)

;-- add bottom longitude labels
  y_in = -90.0
  datatondc(map,x_in,y_in,x_out,y_out)
  gsn_text_ndc(wks, lon_labels, x_out, y_out-0.012, txres)

;-- that's it
  return(map)
  
end   ;-- end function add_robinson_labels


;----------------------------------------------------------------------
; Main code.
;----------------------------------------------------------------------
;------------------------------------------------------------------

begin

begin

;-- read the data

f_llj = addfile("/data2/dejanira/USP/vento/novo/Argcomjato.nc","r") ;-- open file with read
llj = f_llj->olr
;llj@units     = "m*s-1"


;;create plots;;
   wks_type = "pdf"
   ;wks_type@wkWidth = 2000
   ;wks_type@wkHeight = 2000
   wks = gsn_open_wks(wks_type,"BraS.01.geo")

        
        ;gsn_define_colormap(wks,"NCV_gebco")
        ;gsn_define_colormap(wks,"perc2_9lev")
        ;gsn_define_colormap(wks,"rainbow")
	;gsn_define_colormap(wks,"cmp_b2r")
	;gsn_define_colormap(wks,"ncl_default")
	gsn_define_colormap(wks,"BlueWhiteOrangeRed")

        ;gsn_define_colormap(wks,"posneg_2")

        res                = True
        res@gsnDraw        = False   	;--don't draw the plot
        res@gsnFrame       = False	;--don't advance the frame	
        res@gsnMaximize    = False	;-- maxmize plot in frame
        res@tmXTOn         = False	;--no tick marks on top x-axis
        res@tmYROn         = True	;--no tick marks on top y-axis
        ;res@gsnLeftString = "NLLJ index (06UTC)" ; change left string
        res@gsnRightString = llj@units ;-- assign right string
        res@tiMainString   = "Arg"


; Mapa
        
        mpres                     = res
        mpres@gsnPolarSH          = True ; specify the hemisphere
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
	;mpres@mpMinLatF = -60. ; Latitude sul.
	;mpres@mpMaxLatF = 20. ; Latitude norte.
	;mpres@mpMinLonF = -100. ; Longitude oeste.
	;mpres@mpMaxLonF = -20. ; Longitude leste.
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
		;cnres@cnLevels    = (/-350,-300,-250,-200,-180,-150,-100,-80,-60,-40,0,40,60,80,100,150,180,200,250,300,350/)   ; set levels
  		cnres@cnLevels    = (/-300,-270,-240,-210,-180,-150,-120,-90,-60,-30,0,30,60,90,120,150,180,210,240,270,300/)  
		cnres@cnMinLevelValF       =  -1000                ; set min contour level
 		cnres@cnMaxLevelValF       =  1000                ; set max contour level
 		cnres@cnLevelSpacingF      = 1           ; set contour spacing
  		cnres@cnFillColors = (/2,5,10,30,40,60,70,80,90,104,0,0,156,177,185,200,210,219,220,236,250,255/)  ; set the colors to be used
  	        cnres@cnFillON = True
		cnres@cnLevelSpacingF = 3
  		cnres@cnLinesOn = False ;-- turn lines on  lineas de contorno en cada nivel
       	        cnres@lbTitleOn = True ; Habilita um título para a legenda.
		cnres@lbTitleString = "(hPa)" ; Título da legenda.
		cnres@lbTitleFontHeightF = 0.015 ; Tamanho da fonte do título da legenda.
		cnres@pmLabelBarOrthogonalPosF = 0.15 
		cnres@lbLabelFontHeightF = 0.015 ; Tamanho dos valores da; legenda.
;geo 
        
        ;res_geo = True
	;res_geo@cnLevelSelectionMode = "AUTOMATICLEVELS"; defina manualmente os níveis de contorno com os 3 recursos a seguir
  	;res_geo@cnMinLevelValF = 100. ; definir o nível de contorno mínimo
  	;res_geo@cnMaxLevelValF = 30.; definir o nível máximo de contorno
  	;res_geo@cnLevelSpacingF = 2000.; definir o intervalo entre os contornos
	

        wrf_smooth_2d (llj, 2) ;-- realizada suavizado

;Plot
        map     = gsn_csm_map(wks,mpres)
        contour = gsn_csm_contour(wks,llj(0,1,:,:),cnres)
        ;marker = gsn_add_polymarker(wks, map, -61.6, -26.3, pmres)  ; marco el pto maximo
       	;geo = gsn_csm_contour(wks,g1,res_geo)                  
        plot = gsn_csm_contour_map_polar(wks,llj(0,21,:,:),res)  ; create plot one


;;overlay filled contours and vectors on the map;;
	
        overlay(map,contour)
       	;overlay(map,geo)


;;drawing "map" will draw everything: map, contours, vectors, and text;;
        draw(map)
        frame(wks)
end