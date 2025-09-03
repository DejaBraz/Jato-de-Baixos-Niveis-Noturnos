#---------------------------------------------------------------------------------------------------------------------------
# Script to plot the LLJs (Nocturnal Low-Level Jets)
# Author: Dejanira F Braz
#--------------------------------------------------------------------------------------------

# 1st Step: Installing the Required Libraries**
#
# In this step we install the libraries necessary for running the scripts. Basically, the libraries will serve the following purposes:
#
# NetCDF4: Read ERA5 data 
# Cartopy: Add maps to plots
#--------------------------------------------------------------------------------------------

# Installing the Cartopy Library
!pip install cartopy
!pip install shapely --no-binary shapely --force
print('\n')

# Installing the Boto3 Library
!pip install boto3
print('\n')

# Installing the NetCDF4 Library
!pip install netcdf4
print('\n')

# Installing / updating the GDAL Library
!apt-add-repository -y ppa:ubuntugis/ubuntugis-unstable
!add-apt-repository -y ppa:ubuntugis/ppa
!apt-get install gdal-bin
!pip install 'gdal==3.0.4'
print('\n')

# Install ImageMagick
!sudo apt install imagemagick
print('\n')

# Other required libraries
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
# 3rd Step: Downloading Auxiliary Files**
#
# In this step it is necessary to download some auxiliary files:
#
# *   br_unidades_da_federacao.zip: Shapefile with Brazilian states
# *   ne_10m_admin_1_states_provinces.zip: Shapefile with worldwide states and provinces
#--------------------------------------------------------------------------------------------

# Download Brazilian states shapefile
!wget -c https://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2019/Brasil/BR/br_unidades_da_federacao.zip
print('\n')

# Unzip Brazilian states shapefile
!unzip -o br_unidades_da_federacao.zip
print('\n')

# Download world states/provinces shapefile
!wget -c https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip
print('\n')

# Unzip world states/provinces shapefile
!unzip -o ne_10m_admin_1_states_provinces.zip
print('\n')

# Download river basin shapefile
!wget -c https://metadados.snirh.gov.br:/geonetwork/srv/api/records/fe192ba0-45a9-4215-90a5-3fba6abea174/attachments/SNIRH_BaciasDNAEE.zip
!unzip -o SNIRH_BaciasDNAEE
print('\n')

#--------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------
# Author: Dejanira F. Braz
#-----------------------------------------------------------------------------------------------------------

# To handle data
#import geopandas as gpd
import pandas as pd 
#import rioxarray
import xarray as xr
import numpy as np
from netCDF4 import Dataset 

# To create maps
from shapely.geometry import mapping
import matplotlib.pyplot as plt
import cartopy, cartopy.crs as ccrs
import cartopy.feature as cfeature
import matplotlib.colors as colors
import cmocean
import cartopy.io.shapereader as shpreader 
import matplotlib 

#--------------------------------------------------------------------------------------------
# OPEN NETCDF FILE

nc1 = Dataset('/content/drive/MyDrive/Samples/Vento/jato.DJF.nc','r+') # input data

data = nc1.variables['u'][:] # variable
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

#-----------------------------------------------------------------------------------------------------------
# Choose the plot size (width x height, in inches)
plt.figure(figsize=(10,10))

# Use the Cylindrical Equidistant projection in cartopy
ax = plt.axes(projection=ccrs.PlateCarree())

# Add shapefile geometry
shapefile = list(shpreader.Reader('/content/drive/MyDrive/Samples/Vento/Shapefile/Bacia_do_Prata.shp').geometries())
ax.add_geometries(shapefile, ccrs.PlateCarree(), edgecolor='red',facecolor='none', linewidth=0.5)

# Define contour interval
data_min = -2
data_max = 12 
interval = 1
levels = np.arange(data_min,data_max,interval)

# Create a custom color palette 
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

# Add a colorbar
plt.colorbar(img, label=' (m/s)', extend='both', orientation='vertical', pad=0.05, fraction=0.05)

# Add a title
plt.title('LLJ Index' , fontweight='bold', fontsize=10, loc='left')

#----------------------------------------------------------------------------------------------------------- 
# Save the image
plt.savefig('image_4.png')

# Show the image
plt.show()

#-----------------------------------------------------------------------------------------------------------
# Custom color palette (used for multiple plots below)
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

#-----------------------------------------------------------------------------------------------------------
# Panel [0,0]
shapefile = list(shpreader.Reader('BR_UF_2019.shp').geometries())
axs[0,0].add_geometries(shapefile, ccrs.PlateCarree(), edgecolor='gray',facecolor='none', linewidth=0.3)
axs[0,0].coastlines(resolution='10m', color='black', linewidth=0.8)
axs[0,0].add_feature(cartopy.feature.BORDERS, edgecolor='black', linewidth=0.5)

gl = axs[0,0].gridlines(crs=ccrs.PlateCarree(), color='lightgray', alpha=1.0, linestyle='--', linewidth=0.25, xlocs=np.arange(-180, 180, 10), ylocs=np.arange(-90, 90, 5), draw_labels=True)
gl.top_labels = False
gl.right_labels = False

# Plot the contours
img1 = axs[0,0].imshow(data, origin='lower', extent=extent, cmap=cmap)     

#-----------------------------------------------------------------------------------------------------------
# Panel [0,1]
shapefile = list(shpreader.Reader('BR_UF_2019.shp').geometries())
axs[0,1].add_geometries(shapefile, ccrs.PlateCarree(), edgecolor='gray',facecolor='none', linewidth=0.3)
axs[0,1].coastlines(resolution='10m', color='black', linewidth=0.8)
axs[0,1].add_feature(cartopy.feature.BORDERS, edgecolor='black', linewidth=0.5)

gl = axs[0,1].gridlines(crs=ccrs.PlateCarree(), color='lightgray', alpha=1.0, linestyle='--', linewidth=0.25, xlocs=np.arange(-180, 180, 10), ylocs=np.arange(-90, 90, 5), draw_labels=True)
gl.top_labels = False
gl.right_labels = False

# Plot the contours
img3 = axs[0,1].imshow(data, origin='lower', extent=extent, cmap=cmap)    

#-----------------------------------------------------------------------------------------------------------
# Panel [1,0]
shapefile = list(shpreader.Reader('BR_UF_2019.shp').geometries())
axs[1,0].add_geometries(shapefile, ccrs.PlateCarree(), edgecolor='gray',facecolor='none', linewidth=0.3)
axs[1,0].coastlines(resolution='10m', color='black', linewidth=0.8)
axs[1,0].add_feature(cartopy.feature.BORDERS, edgecolor='black', linewidth=0.5)

gl = axs[1,0].gridlines(crs=ccrs.PlateCarree(), color='lightgray', alpha=1.0, linestyle='--', linewidth=0.25, xlocs=np.arange(-180, 180, 10), ylocs=np.arange(-90, 90, 5), draw_labels=True)
gl.top_labels = False
gl.right_labels = False

# Plot the contours
img3 = axs[1,0].imshow(data, origin='lower', extent=extent, cmap=cmap)    

#----------------------------------------------------------------------------------------------------------- 
# Panel [1,1]
shapefile = list(shpreader.Reader('BR_UF_2019.shp').geometries())
axs[1,1].add_geometries(shapefile, ccrs.PlateCarree(), edgecolor='gray',facecolor='none', linewidth=0.3)
axs[1,1].coastlines(resolution='10m', color='black', linewidth=0.8)
axs[1,1].add_feature(cartopy.feature.BORDERS, edgecolor='black', linewidth=0.5)

gl = axs[1,1].gridlines(crs=ccrs.PlateCarree(), color='lightgray', alpha=1.0, linestyle='--', linewidth=0.25, xlocs=np.arange(-180, 180, 10),ylocs=np.arange(-90, 90, 5),  draw_labels=True)
gl.top_labels = False
gl.right_labels = False

# Plot the contours
img1 = axs[1,1].imshow(data, origin='lower', extent=extent, cmap=cmap)     

# Colorbar and levels
cbar_ax = fig.add_axes([0.86, 0.25, 0.02, 0.60])
fig.colorbar(img1, cax=cbar_ax,ax=axs[1,0], pad=0.009, extend='max', ticks=np.arange(0,13,1), orientation='vertical', label='(m/s)')

# Adjust subplot layout
fig.subplots_adjust(top=0.95,wspace=-0.15, hspace=0.05)

#-----------------------------------------------------------------------------------------------------------

# Save the image
plt.savefig('/content/drive/MyDrive/Samples/Vento/image.pdf')

# Show the image
plt.show()  
