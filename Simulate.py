import ephem
import os
import numpy as np
from sys import argv
from os.path import dirname, abspath,sep
from string import split

# Source Directory
src_dir = dirname(abspath(__file__)) + sep

def degrees(rads):
    "Converts radians to degrees"
    return rads / ephem.pi * 180

def getcxrb(tlefile,date):
    "Get the a pyephem object representing the CXRBNanoSat at a particular date, given a TLE file describing the orbit"
    f = open(tlefile,'r')
    tle = f.readlines()
    f.close()
    cxrb = ephem.readtle(tle[0],tle[1],tle[2])
    cxrb.compute(date)
    return cxrb

def jd2gdy(julian_date):
    "Converts a Julian date to a Gregorian Decimal Year"
    return (julian_date - ephem.julian_date('2000/1/1')) / 365.25 + 2000

def getmagfield(lat,lon,alt,date):
    """Return a numpy array containing the geomagnetic field vector at a particular latitude, longitude, altitude and date.
  - Latitude and longitude must be in signed degrees, 
  - Altitude must be in kilometers from average sea level
  - Date must be in Gregorian decimal years"""
    oldpwd = os.getcwd()
    os.chdir(src_dir + sep + "WMM")
    cmd = " ".join(map(format, ["./wmm", lat, lon, alt, date]))
    wmm = os.popen(cmd)
    out = split(wmm.read(),' ')
    wmm.close()
    magfield = np.array(map(float,out))
    os.chdir(oldpwd)
    return magfield

# Main routine if we are called as a script
if __name__ == "__main__":
    date = argv[1]
    cxrb = getcxrb(src_dir + sep + "cxrb.tle", date)
    print getmagfield(degrees(cxrb.sublat), 
                      degrees(cxrb.sublong), 
                      cxrb.elevation/1000, 
                      jd2gdy(ephem.julian_date(date)))
