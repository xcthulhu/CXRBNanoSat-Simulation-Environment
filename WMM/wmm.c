//---------------------------------------------------------------------------

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <regex.h>
#include "WMMHeader.h"

//---------------------------------------------------------------------------

/* WMM sublibrary is used to make a command prompt program. The program reads location data from command line, performs computations and returns. The program expects the files libwmm.c, WMMHEADER.H,
WMM.COF and EGM9615.BIN to be in the same directory. 

Manoj.C.Nair
Nov 23, 2009

(Modified by Matthew Wampler-Doty March 23, 2011)

 *
 * MODIFICATIONS
 *
 *    Date                 Version
 *    ----                 -----------
 *    Nov 15, 2009         0.1
	Jan 28, 2010	   1.0
       March 23, 2011      1.1

*/

// Checks if a file exists
int
file_exists (char *filename)
{
  struct stat buf;
  return !stat (filename, &buf);
}

// Reads in position data in the form of latitude, longitude, and altitude
int
read_pos (char *latb, char *lonb, char *altb,
	  WMMtype_CoordGeodetic * CoordGeodetic, WMMtype_Geoid * Geoid)
{
  sscanf (latb, "%lf", &CoordGeodetic->phi);
  sscanf (lonb, "%lf", &CoordGeodetic->lambda);
  Geoid->UseGeoid = 1;
  sscanf (altb, "%lf", &CoordGeodetic->HeightAboveGeoid);
  WMM_ConvertGeoidToEllipsoidHeight (CoordGeodetic, Geoid);
  return 1;
}

/***** Date reading routines *****/

// Checks if a regular expression matches
int
match (char *str, char *pat)
{
  int status;
  regex_t re;
  if (regcomp (&re, pat, REG_EXTENDED | REG_NOSUB))
    return 0;
  status = regexec (&re, str, (size_t) 0, NULL, 0);
  regfree (&re);
  return !status;
}

// Checks if a string is a Gregorian decimal year (ie, a floating point number)
int
is_gdy (char *dateb)
{
  return match (dateb, "[-+]?[0-9]*\\.?[0-9]*");
}

// Checks if a string is of the form "YYYY/MM/DD"
int
is_ymd (char *dateb)
{
  return match (dateb, "[0-9][0-9][0-9][0-9]/[0-9]?[0-9]/[0-9]?[0-9]");
}

// The epoch - read from COF file.  We are lazy and make it a global.
int epoch = 0;

// Prints an error message about the form of the date
void
print_date_error ()
{
  fprintf (stderr,
	   "Date must be entered in as YYYY/MM/DD or Gregorian decimal year, and only times after %d/01/01 and before %d/01/01 are supported\n",
	   (int) epoch, (int) epoch + 5);
}

// Reads date from Gregorian decimal year
int
read_gdy (char *dateb, WMMtype_Date * MagneticDate)
{
  sscanf (dateb, "%lf", &MagneticDate->DecimalYear);
  return (epoch <= MagneticDate->DecimalYear
	  && MagneticDate->DecimalYear <= epoch + 5);
}

// Reads date from YYYY/MM/DD
int
read_ymd (char *dateb, WMMtype_Date * MagneticDate)
{
  char Error_Message[255];
  sscanf (dateb, "%d/%d/%d", &MagneticDate->Year, &MagneticDate->Month,
	  &MagneticDate->Day);
  if (!(epoch <= MagneticDate->Year && MagneticDate->Year <= epoch + 5))
    return 0;
  else if (!(WMM_DateToYear (MagneticDate, Error_Message)))
    {
      fprintf (stderr, "%s\n", Error_Message);
      return 0;
    }
  else
    return 1;
}

// Reads in date data
int
read_date (char *dateb, WMMtype_Date * MagneticDate)
{
  int status = 0;
  if (is_ymd (dateb))
    status = read_ymd (dateb, MagneticDate);
  else if (is_gdy (dateb))
    status = read_gdy (dateb, MagneticDate);
  if (status == 0)
    {
      print_date_error ();
      return 0;
    }
  else
    return 1;
}

/***** Usage Warning *****/

void
print_usage (char *progname)
{
  fprintf (stderr, "\nUsage:\n"
	   "%s <lattidue> <longitude> <altitude> YYYY/MM/DD\n"
	   // "- WMM.COF is a file containing world magnetic model spherical harmonic coefficients\n"
	   "- lattitude and longitude are given in (signed) degrees\n"
	   "- altitude is given in kilometers\n"
	   "\n"
	   "OUTPUTS: X, Y, and Z components of geomagnetic field vector, seperated by spaces\n"
	   "- X is the northerly intensity in nanoteslas\n"
	   "- Y is the easterly intensity in nanoteslas\n"
	   "- Z is the verticle intensity, positive downwards in nanoteslas\n", progname);
}

int
main (int argc, char *argv[])
{

  WMMtype_MagneticModel *MagneticModel, *TimedMagneticModel;
  WMMtype_Ellipsoid Ellip;
  WMMtype_CoordSpherical CoordSpherical;
  WMMtype_CoordGeodetic CoordGeodetic;
  WMMtype_Date UserDate;
  WMMtype_GeoMagneticElements GeoMagneticElements;
  WMMtype_Geoid Geoid;
  int NumTerms;
  char filename[] = "WMM.COF";

  /*** Memory allocation ***/
  NumTerms = ((WMM_MAX_MODEL_DEGREES + 1) * (WMM_MAX_MODEL_DEGREES + 2) / 2);	/* WMM_MAX_MODEL_DEGREES is defined in WMM_Header.h */
  MagneticModel = WMM_AllocateModelMemory (NumTerms);	/* For storing the WMM Model parameters */
  TimedMagneticModel = WMM_AllocateModelMemory (NumTerms);	/* For storing the time modified WMM Model parameters */
  if (MagneticModel == NULL || TimedMagneticModel == NULL)
    WMM_Error (2);
  WMM_SetDefaults (&Ellip, MagneticModel, &Geoid);	/* Set default values and constants */
  /* Check for Geographic Poles */
  if (!file_exists (filename))
    {
      fprintf (stderr, "File %s does not exist\n", argv[1]);
      print_usage (argv[0]);
      exit (EXIT_FAILURE);
    }
  //WMM_readMagneticModel_Large(filename, MagneticModel); //Uncomment this line when using the 740 model, and comment out the  WMM_readMagneticModel line.
  WMM_readMagneticModel (filename, MagneticModel);
  WMM_InitializeGeoid (&Geoid);	/* Read the Geoid file */
  epoch = (int) MagneticModel->epoch;	// Set the epoch
  //WMM_GeomagIntroduction (MagneticModel);     /* Print out the WMM introduction */

  /*** Get parameters from command line ***/
  if (!(argc == 5 &&
	read_pos (argv[1], argv[2], argv[3], &CoordGeodetic, &Geoid) &&
	read_date (argv[4], &UserDate)))
    {
      print_usage (argv[0]);
      exit (EXIT_FAILURE);
    }

  /*** Perform Calculations ***/
  WMM_GeodeticToSpherical (Ellip, CoordGeodetic, &CoordSpherical);	/*Convert from geodeitic to Spherical Equations: 17-18, WMM Technical report */
  WMM_TimelyModifyMagneticModel (UserDate, MagneticModel, TimedMagneticModel);	/* Time adjust the coefficients, Equation 19, WMM Technical report */
  WMM_Geomag (Ellip, CoordSpherical, CoordGeodetic, TimedMagneticModel, &GeoMagneticElements);	/* Computes the geoMagnetic field elements and their time change */
  WMM_CalculateGridVariation (CoordGeodetic, &GeoMagneticElements);

  /*** Output ***/
  //WMM_PrintUserData (GeoMagneticElements, CoordGeodetic, UserDate, TimedMagneticModel, &Geoid);       /* Print the results */
  // Print the three Geogmagnetic elements
  printf ("%lf %lf %lf\n", GeoMagneticElements.X,
	  GeoMagneticElements.Y, GeoMagneticElements.Z);

  /*** Memory Cleanup ***/
  WMM_FreeMagneticModelMemory (MagneticModel);
  WMM_FreeMagneticModelMemory (TimedMagneticModel);

  if (Geoid.GeoidHeightBuffer)
    {
      free (Geoid.GeoidHeightBuffer);
      Geoid.GeoidHeightBuffer = NULL;
    }

  exit (EXIT_SUCCESS);
}
