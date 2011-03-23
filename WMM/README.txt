World Magnetic Model Software and support documents
=======================================================
Version 1.0, Date January 28, 2010

Files


Sublibrary Files
================
WMM_SubLibrary.c	                  WMM Subroutine library, C functions
WMMHeader.h					WMM Subroutine library, C header file 

Main Programs
===============
wmm_point.c					Command prompt version for single point computation
wmm_point_ISO.c					Command prompt program for single point with WMM ISO file as input
wmm_grid.c					Grid, profile and time series computation, C main function
wmm_file.c					C program which takes a coordinate file as input


Data Files
===============
EGM9615.BIN					EGM96 binary grid for Geoid to Ellipsoid conversion
WMM.COF					WMM Coefficients file


Pre-compiled binaries
=====================


Supporting Documents
=====================
WMM2010_SoftwareDocuments.pdf		Technical documents of the WMM Model and softwares


Excecutables
============
wmm_point.exe				Command Prompt program for single point 
wmm_grid.exe				Grid, time series or profile
wmm_file.exe				File processing 
wmm_point_ISO.exe			Command prompt program for single point with WMM ISO file as input

Test Files
===============
WMM2010testvalues.pdf			Test values for WMM2010
sample_input_file.txt			Sample input file for program wmm_file.exe 
sample_output_file.txt			Sample output file for program  wmmfile.exe



Compiling with gcc
===================
gcc -lm inputfile -o outputfile
For example, the wmm_cmd.c can be compiled as
gcc -lm wmm_cmd.c  -o wmm_cmd.exe
Note: The library files WMM_SubLibrary.c and WMMHeader.h should reside in the same directory for compiling.





Model Software Support
======================

*  National Geophysical Data Center
*  NOAA EGC/2
*  325 Broadway"
*  Boulder, CO 80303 USA
*  Attn: Manoj Nair or Stefan Maus
*  Phone:  (303) 497-4642 or -6522
*  Email:  Manoj.C.Nair@noaa.gov or Stefan.Maus@noaa.gov
For more details about the World Magnetic Model visit 
http://www.ngdc.noaa.gov/geomag/WMM/DoDWMM.shtml
 




       