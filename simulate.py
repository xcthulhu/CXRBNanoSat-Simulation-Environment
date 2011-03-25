import ephem
from sys import argv
from os.path import dirname, abspath,sep
from os import popen

# Source Directory
src_dir = dirname(abspath(__file__)) + sep

def degrees(rads):
    "Converts radians to degrees"
    return rads / ephem.pi * 180

def getorb(tlefile,date):
    "Get the orbital position of CXRBNanoSat at a particular date, given a TLE file describing the orbit"
    f = open(tlefile,'r')
    tle = f.readlines()
    cxrb = ephem.readtle(tle[0],tle[1],tle[2])
    cxrb.compute(date)
    return cxrb

def jd2gdy(julian_date):
    "Converts a Julian date to a Gregorian Decimal Year"
    return (julian_date - ephem.julian_date('2000/1/1')) / 365.25 + 2000

if __name__ == "__main__":
    date = argv[1]
    cxrb = getorb(src_dir + "/cxrb.tle", date)
    cmd = " ".join(map(format,
                       [src_dir + "/WMM/wmm", 
                        src_dir + "/WMM/WMM.COF", 
                        degrees(cxrb.sublong), 
                        degrees(cxrb.sublat), 
                        cxrb.elevation/1000 , 
                        jd2gdy(ephem.julian_date(date))
                        ]))
    #print cmd
    print popen(cmd).readlines()
    
