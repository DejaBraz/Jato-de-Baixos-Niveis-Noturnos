#
# Author: Dejanira F. Braz
#
import netCDF4 as nc4

import numpy as np
import matplotlib.pyplot as plt

from cartopy import config
import cartopy.crs as ccrs


nc1 = nc4.Dataset('DJF.nc','r+') 

nc = nc4.Dataset('1.nc','r+') 


temp = nc1.variables['u'][:] #variavel
lat = nc1.variables['latitude'][:]
lon = nc1.variables['longitude'][:]
time = nc1.variables['time'][:]
uu = nc.variables['u'][:]


ix = 67
jy = 54
z = 1
t= 3340

tsize = time.size
u_reesc = np.zeros((jy,ix))
u_cor = np.zeros((1,z,jy,ix))
print(tsize)


for t in range(tsize):
    for i in range(ix):
        for j in range(jy):
            if(temp[t,0,j,i] > 0.0):
                u_reesc[j,i] = u_reesc[j,i]+1
                print(t)


ax = plt.axes(projection=ccrs.PlateCarree())
ax.coastlines()
#colorb=np.arange(985, 1020, 50.0)
#ax.set_extent([-120, 24, -60, 20], crs=ccrs.PlateCarree())
plt.contourf(lon, lat, u_reesc, 60, transform=ccrs.PlateCarree(), cmap='jet')
cb = plt.colorbar()
#plt.clim(990, 1030)
plt.show()


u_cor[0,0,:,:] = u_reesc[:,:]
nc.variables['u'][:] = u_cor[:,:,:,:]

nc.close()  
nc1.close()
