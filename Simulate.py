#!/usr/bin/env python
import ephem
import os
import numpy as np
import numpy.linalg as la
import cgkit.cgtypes.quat as quat
import csv
import datetime
from sys import argv
from os.path import dirname, abspath,sep
from string import split
from math import sin, cos

# Source Directory
src_dir = dirname(abspath(__file__)) + sep

# Spacecraft orbit from TLE file
tle_file = src_dir + sep + "cxrb.tle"

def degrees(rads):
    "Converts radians to degrees"
    return rads / ephem.pi * 180

def jd2gdy(julian_date):
    "Converts a Julian date to a Gregorian Decimal Year"
    return (julian_date - ephem.julian_date('2000/1/1')) / 365.25 + 2000

def getmagfield(lat,lon,alt,date):
    """Return a numpy array containing the geomagnetic field vector at a particular latitude, longitude, altitude and date.
  - Latitude and longitude must be in signed degrees, 
  - Altitude must be in kilometers from average sea level
  - Date must be in Gregorian decimal years"""
    oldpwd = os.getcwd()
    os.chdir(src_dir + sep + "WMM") # hack to deal with local file references
    cmd = " ".join(map(format, ["./wmm", lat, lon, alt, date]))
    wmm = os.popen(cmd)
    out = split(wmm.read(),' ')
    wmm.close()
    magfield = np.array(map(float,out))
    os.chdir(oldpwd)
    return magfield

def wmm2eci(ra, dec, wwmvec):
    "Converts a WMM geomagnetic field vector to Earth Centered Inertial coordinates; assumes the epoch is J2000"
    # See Documentation for meaning of this
    return np.dot(
        [[-cos(dec), 0, sin(dec)],
         [sin(dec)*cos(ra), -sin(ra), -cos(dec)*cos(ra)],
         [sin(dec)*sin(ra), cos(ra), -cos(dec)*sin(ra)]], wmmvec)

def getinvmoitensor(filename):
   "Extracts a moment of inertia tensor from a tab seperated value file, and returns the inverse"
   fp = open(filename)
   tsv = csv.reader(fp, delimiter='\t')
   fp.close()
   return la.inv(map(lambda x: map(float,x), tsv))

def getsat(tlefile,date):
    "Get the a pyephem object representing a earth satellite at a particular date, given a TLE file describing the orbit"
    f = open(tlefile,'r')
    tle = f.readlines()
    f.close()
    sat = ephem.readtle(tle[0],tle[1],tle[2])
    sat.compute(date)
    return cxrb

class AttitudeSat:
    # Satellite's time
    date = ephem.now()
    # Quaternion representing the satellite's orientation in Earth centered inertial coordinates
    q = quat.quat(np.eye(3))
    # Vector representing the satellite's 

    def setasttime(self, asttime=ephem.now()):
        "Sets the satellite's time to a given astronomical time; uses current time if unspecified"
        self.date = ephem.Date(asttime)

    def gdy(self, asttime=self.date):
        "Returns the Gregorian Decimal Year, for a given date;  uses object date if unspecified"
        return jd2gdy(ephem.julian_date(asttime)))

# Main routine if we are called as a script
if __name__ == "__main__":
    date = argv[1]
    # Get object representing the CXRB sattelite from a TLE file
    cxrb = getsat(tle_file, date)
    # Get the magnetic field vector at the position of the sattelite
    wmmvec = getmagfield(degrees(cxrb.sublat), 
                         degrees(cxrb.sublong), 
                         cxrb.elevation/1000, 
                         jd2gdy(ephem.julian_date(date)))
    # Get Equatorial coordinates of the CXRB at the J2000 epoch
    eqcxrb = ephem.Equatorial(cxrb, epoch=ephem.J2000)
    # Convert the WMM geomagnetic field vector to the Earth Centered Inertial Fram
    print wmm2eci(eqcxrb.ra, eqcxrb.dec, wmmvec)
