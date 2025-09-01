#---------------------------------------------------------------------------------------------------------------------------
# Scriprit para plotar os JBN
# Author: Dejanira F Braz
#--------------------------------------------------------------------------------------------

#1° Passo: Instalando as Bibliotecas Necessárias**

#Neste passo instalamos as bibliotecas necessárias para a execução dos scripts. Basicamente, as bibliotecas terão a seguinte finalidade:

#NetCDF4: Ler os dados do Era-5 Cartopy: Adicionar mapas aos plots
#--------------------------------------------------------------------------------------------
# Instalando a Biblioteca Cartopy
!pip install cartopy
!pip install shapely --no-binary shapely --force
print('\n')

# Instalando a Biblioteca Boto3
!pip install boto3
print('\n')

# Instalando a Biblioteca NetCDF4
!pip install netcdf4
print('\n')

# Instalando / atualizando a Biblioteca GDAL
!apt-add-repository -y ppa:ubuntugis/ubuntugis-unstable
!add-apt-repository -y ppa:ubuntugis/ppa
!apt-get install gdal-bin
!pip install 'gdal==3.0.4'
print('\n')

# Install ImageMagick
!sudo apt install imagemagick
print('\n')
!pip install pandas
!pip install matplotlib
!pip install numpy
!pip install cartopy
!pip install geopandas
!pip install rioxarray
!pip install cmocean
!pip install descartes
!pip install dask
!pip install arm-pyart
!apt-get install libproj-dev proj-data proj-bin
!apt-get install libgeos-dev
!pip install netCDF4
#--------------------------------------------------------------------------------------------
#3° Passo: Baixando Arquivos Auxiliares**
#
# Neste passo será necessário baixar alguns arquivos auxiliares
#
# *   br_unidades_da_federacao.zip: Shapefile com os estados brasileiros
# *   ne_10m_admin_1_states_provinces.zip: Shapefile com os estados e províncias mundiais
#--------------------------------------------------------------------------------------------
# Baixando o shapefile dos estados brasileiros
!wget -c https://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2019/Brasil/BR/br_unidades_da_federacao.zip
print('\n')

# Descomprimindo o arquivo de shapefile dos estados brasileiros
!unzip -o br_unidades_da_federacao.zip
print('\n')

# Baixando o shapefile dos estados / províncias mundiais
!wget -c https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip
print('\n')

# Descomprimindo o arquivo de shapefile dos estados / províncias mundiais
!unzip -o ne_10m_admin_1_states_provinces.zip
print('\n')

!wget -c https://metadados.snirh.gov.br:/geonetwork/srv/api/records/fe192ba0-45a9-4215-90a5-3fba6abea174/attachments/SNIRH_BaciasDNAEE.zip
!unzip -o SNIRH_BaciasDNAEE
print('\n')
#--------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------
# Author: Dejanira F. Braz
#-----------------------------------------------------------------------------------------------------------
# Para manipular dados
#import geopandas as gpd
import pandas as pd 
#import rioxarray
import xarray as xr
import numpy as np
from netCDF4 import Dataset 


# Para criar mapas
from shapely.geometry import mapping
import matplotlib.pyplot as plt
import cartopy, cartopy.crs as ccrs
import cartopy.feature as cfeature
import matplotlib.colors as colors
import cmocean
import cartopy.io.shapereader as shpreader 
import matplotlib 

#--------------------------------------------------------------------------------------------
# ABRE DE ARQUIVO NETCDF

nc1 = Dataset('/content/drive/MyDrive/Samples/Vento/jato.DJF.nc','r+') #dados de entrada

data = nc1.variables['u'][:] #variavel
lat = nc1.variables['lat'][:]
lon = nc1.variables['lon'][:]
time = nc1.variables['time'][:]

# Return a reshaped matrix
data = data.squeeze()

# Flip the y axis
data = np.flipud(data)
# Select the extent [min. lon, min. lat, max. lon, max. lat]
extent = [-60.0, 0.00, -10.00, 18.00]

# Define the image extent [min. lon, max. lon, min. lat, max. lat]
img_extent = [ extent[0], extent[1],extent[2]+360, extent[3]+360]

#------------------------------------------------------------------------------------------------------

# Choose the plot size (width x height, in inches)
plt.figure(figsize=(10,10))


# Plot the image
plt.imshow(data, origin='lower', extent=img_extent, cmap='jet')
#------------------------------------------------------------------------------------------------------
# Save the image
plt.savefig('image_1.png')
# Show the image
plt.show()

# Select the extent [min. lon, min. lat, max. lon, max. lat]
extent = [-93.0, -20.00, -60.00, 18.00]

# Read the data for a specific region
#data, lats, lons = grb.data(lat1=extent[1],lat2=extent[3],lon1=extent[0]+360,lon2=extent[2]+360)

#-----------------------------------------------------------------------------------------------------------
# Choose the plot size (width x height, in inches)
plt.figure(figsize=(10,10))

# Use the Cilindrical Equidistant projection in cartopy
ax = plt.axes(projection=ccrs.PlateCarree())

# Define the image extent [min. lon, max. lon, min. lat, max. lat]
#img_extent = [extent[0], extent[2], extent[1], extent[3]]

shapefile = list(shpreader.Reader('/content/drive/MyDrive/Samples/Vento/Shapefile/Bacia_do_Prata.shp').geometries())
ax.add_geometries(shapefile, ccrs.PlateCarree(), edgecolor='red',facecolor='none', linewidth=0.5)

# Define de contour interval
data_min = -2
data_max = 12 
interval = 1
levels = np.arange(data_min,data_max,interval)

# Create a custom color palette 
# The reference color palette may be found at the following page: http://wxmaps.org/pix/temp8
# You may get the hex files st the following page: https://imagecolorpicker.com/
colors = ["#d3d2d2", "#bcbcbc", "#969696", "#1464d2", "#1e6eeb", "#2882f0", 
"#3c96f5", "#50a5f5", "#78b9fa", "#96d2fa", "#b4f0fa", "#1eb41e", "#37d23c", 
"#50f050", "#78f573", "#96f58c", "#b4faaa", "#c8ffbe", "#ffe878", "#ffc03c", 
"#ffa000", "#ff6000", "#ff3200", "#e11400", "#c00000", "#a50000", "#785046", 
"#8c6359", "#b48b82", "#e1beb4"]
cmap = matplotlib.colors.ListedColormap(colors)
cmap.set_over('#fadad5')
cmap.set_under('#e5e5e5')

# Add coastlines, borders and gridlines
ax.coastlines(resolution='10m', color='black', linewidth=0.8)
ax.add_feature(cartopy.feature.BORDERS, edgecolor='black', linewidth=0.5)


gl = ax.gridlines(crs=ccrs.PlateCarree(), color='gray', alpha=1.0, linestyle='--', linewidth=0.25, xlocs=np.arange(-180, 180, 5), ylocs=np.arange(-90, 90, 5), draw_labels=True)

gl.top_labels = False
gl.right_labels = False

# Plot the image
img = ax.imshow(data, origin='lower', extent=extent, cmap=cmap)
#plt.contourf(lon, lat, data,  cmap='jet',origin='lower')
# Add a colorbar
plt.colorbar(img, label=' (m/s)', extend='both', orientation='vertical', pad=0.05, fraction=0.05)

# Add a title
plt.title('Índice do JBNNs ' , fontweight='bold', fontsize=10, loc='left')

#----------------------------------------------------------------------------------------------------------- 
# Save the image
plt.savefig('image_4.png')

# Show the image
plt.show()

#-----------------------------------------------------------------------------------------------------------
# Create a custom color palette 
colors = ["#d3d2d2", "#bcbcbc", "#969696", "#1464d2", "#1e6eeb", "#2882f0", 
"#3c96f5", "#50a5f5", "#78b9fa", "#96d2fa", "#b4f0fa", "#1eb41e", "#37d23c", 
"#50f050", "#78f573", "#96f58c", "#b4faaa", "#c8ffbe", "#ffe878", "#ffc03c", 
"#ffa000", "#ff6000", "#ff3200", "#e11400", "#c00000", "#a50000", "#785046", 
"#8c6359", "#b48b82", "#e1beb4"]
cmap = matplotlib.colors.ListedColormap(colors)
cmap.set_over('#fadad5')
cmap.set_under('#e5e5e5')

#-----------------------------------------------------------------------------------------------------------

# Choose the plot size (width x height, in inches)
fig, axs = plt.subplots(2,2, figsize=(13, 11), sharex=True, sharey=True ,subplot_kw={'projection': ccrs.PlateCarree()})
#gridspec_kw = {'wspace':-0.3, 'hspace':0.2}
#-----------------------------------------------------------------------------------------------------------


# Add a shapefile
# https://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2019/Brasil/BR/br_unidades_da_federacao.zip
shapefile = list(shpreader.Reader('BR_UF_2019.shp').geometries())
axs[0,0].add_geometries(shapefile, ccrs.PlateCarree(), edgecolor='gray',facecolor='none', linewidth=0.3)

# Add coastlines, borders and gridlines
axs[0,0].coastlines(resolution='10m', color='black', linewidth=0.8)
axs[0,0].add_feature(cartopy.feature.BORDERS, edgecolor='black', linewidth=0.5)

gl = axs[0,0].gridlines(crs=ccrs.PlateCarree(), color='lightgray', alpha=1.0, linestyle='--', linewidth=0.25, xlocs=np.arange(-180, 180, 10), ylocs=np.arange(-90, 90, 5), draw_labels=True)
gl.top_labels = False
gl.right_labels = False

# Define de contour interval
data_min = -2
data_max = 14
interval = 1
levels = np.arange(data_min,data_max,interval)

# Plot the contours
img1 = axs[0,0].imshow(data, origin='lower', extent=extent, cmap=cmap)     


#-----------------------------------------------------------------------------------------------------------



# Add a shapefile
# https://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2019/Brasil/BR/br_unidades_da_federacao.zip
shapefile = list(shpreader.Reader('BR_UF_2019.shp').geometries())
axs[0,1].add_geometries(shapefile, ccrs.PlateCarree(), edgecolor='gray',facecolor='none', linewidth=0.3)

# Add coastlines, borders and gridlines
axs[0,1].coastlines(resolution='10m', color='black', linewidth=0.8)
axs[0,1].add_feature(cartopy.feature.BORDERS, edgecolor='black', linewidth=0.5)

gl = axs[0,1].gridlines(crs=ccrs.PlateCarree(), color='lightgray', alpha=1.0, linestyle='--', linewidth=0.25, xlocs=np.arange(-180, 180, 10), ylocs=np.arange(-90, 90, 5), draw_labels=True)
gl.top_labels = False
gl.right_labels = False

# Define de contour interval
data_min = 0
data_max = 14
interval = 1
levels = np.arange(data_min,data_max,interval)

# Plot the contours
img3 = axs[0,1].imshow(data, origin='lower', extent=extent, cmap=cmap)    



#-----------------------------------------------------------------------------------------------------------


# Add a shapefile
# https://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2019/Brasil/BR/br_unidades_da_federacao.zip
shapefile = list(shpreader.Reader('BR_UF_2019.shp').geometries())
axs[1,0].add_geometries(shapefile, ccrs.PlateCarree(), edgecolor='gray',facecolor='none', linewidth=0.3)

# Add coastlines, borders and gridlines
axs[1,0].coastlines(resolution='10m', color='black', linewidth=0.8)
axs[1,0].add_feature(cartopy.feature.BORDERS, edgecolor='black', linewidth=0.5)

gl = axs[1,0].gridlines(crs=ccrs.PlateCarree(), color='lightgray', alpha=1.0, linestyle='--', linewidth=0.25, xlocs=np.arange(-180, 180, 10), ylocs=np.arange(-90, 90, 5), draw_labels=True)
gl.top_labels = False
gl.right_labels = False

# Define de contour interval
data_min = 0
data_max = 14 
interval = 1
levels = np.arange(data_min,data_max,interval)


# Plot the contours
img3 = axs[1,0].imshow(data, origin='lower', extent=extent, cmap=cmap)    


#--------------------------------------------------------------------------------------------------------- 
#-----------------------------------------------------------------------------------------------------------


# Add a shapefile
# https://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2019/Brasil/BR/br_unidades_da_federacao.zip
shapefile = list(shpreader.Reader('BR_UF_2019.shp').geometries())
axs[1,1].add_geometries(shapefile, ccrs.PlateCarree(), edgecolor='gray',facecolor='none', linewidth=0.3)

# Add coastlines, borders and gridlines
axs[1,1].coastlines(resolution='10m', color='black', linewidth=0.8)
axs[1,1].add_feature(cartopy.feature.BORDERS, edgecolor='black', linewidth=0.5)

gl = axs[1,1].gridlines(crs=ccrs.PlateCarree(), color='lightgray', alpha=1.0, linestyle='--', linewidth=0.25, xlocs=np.arange(-180, 180, 10),ylocs=np.arange(-90, 90, 5),  draw_labels=True)
gl.top_labels = False
gl.right_labels = False


# Define de contour interval
data_min = 0
data_max = 14 
interval = 1
levels = np.arange(data_min,data_max,interval)

# Plot the contours
img1 = axs[1,1].imshow(data, origin='lower', extent=extent, cmap=cmap)     


# Barra de cores e niveis
cbar_ax = fig.add_axes([0.86, 0.25, 0.02, 0.60])
fig.colorbar(img1, cax=cbar_ax,ax=axs[1,0], pad=0.009, extend='max', ticks=np.arange(0,13,1), orientation='vertical', label='(m/s)')
# Titulo do painel
#plt.suptitle('JBNNs Observada Trimestral 2020', fontsize=20, ha='center', y=0.95)
fig.subplots_adjust(top=0.95,wspace=-0.15, hspace=0.05)

#-----------------------------------------------------------------------------------------------------------

# Save the image
plt.savefig('/content/drive/MyDrive/Samples/Vento/image.pdf')

# Show the image
plt.show() 