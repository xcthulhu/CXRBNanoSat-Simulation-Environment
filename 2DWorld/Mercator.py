#!/usr/bin/env python
import matplotlib
matplotlib.use('Agg')

from mpl_toolkits.basemap import Basemap
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure

if __name__ == "__main__":
	# Create the basemap
	m = Basemap(llcrnrlon=1, \
        	    llcrnrlat=40.6, \
	            urcrnrlon=8.8, \
	            urcrnrlat = 49.6, \
	            resolution = 'l', \
	            projection = 'tmerc', \
                    lon_0 = 4.9, \
                    lat_0 = 45.1)

	# Set Up the Canvas
	fig = Figure()
	canvas = FigureCanvas(fig)
	m.ax = fig.add_axes([0, 0, 1, 1])
	fig.set_figsize_inches((8/m.aspect, 8.))

	# Draw
	m.drawcoastlines(color='gray')
	m.drawcountries(color='gray')
	m.fillcontinents(color='beige')
	x, y = m(lons, lats)
	m.plot(x, y, 'bo')
	#canvas.print_figure('map.png', dpi=100)
