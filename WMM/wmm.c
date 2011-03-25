//---------------------------------------------------------------------------

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <sys/stat.h>
#include "WMMHeader.h"

//---------------------------------------------------------------------------

/* WMM sublibrary is used to make a command prompt program. The program reads location data from command line, performs computations and returns. The program expects the files WMM_SubLibrary.c, WMMHEADER.H,
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

int
file_exists (char *fileName)
{
  struct stat buf;
  return !stat (fileName, &buf);
}

int
readpos (char *latb, char *lonb, char *altb,
	 WMMtype_CoordGeodetic * CoordGeodetic, WMMtype_Geoid * Geoid)
{
  sscanf (latb, "%lf", &CoordGeodetic->phi);
  sscanf (lonb, "%lf", &CoordGeodetic->lambda);
  Geoid->UseGeoid = 1;
  sscanf (altb, "%lf", &CoordGeodetic->HeightAboveGeoid);
  WMM_ConvertGeoidToEllipsoidHeight (CoordGeodetic, Geoid);
  return 1;
}

int
readdate (char *dateb, WMMtype_MagneticModel * MagneticModel,
	  WMMtype_Date * MagneticDate)
{
  char Error_Message[255];
  sscanf (dateb, "%d/%d/%d", &MagneticDate->Year, &MagneticDate->Month,
	  &MagneticDate->Day);
  if (!(2010 < MagneticDate->Year && MagneticDate->Year < 2015))
    {
      fprintf (stderr,
	       "This software only supports times after 2010/01/01 and before 2015/01/01\n");
      return 0;
    }
  if (!(WMM_DateToYear (MagneticDate, Error_Message)))
    {
      fprintf (stderr, "%s\n", Error_Message);
      fprintf (stderr, "Time must be specified in YYYY/MM/DD\n");
      return 0;
    }
  if (MagneticDate->DecimalYear > MagneticModel->epoch + 5
      || MagneticDate->DecimalYear < MagneticModel->epoch)
    {
      switch (WMM_Warnings (4, MagneticDate->DecimalYear, MagneticModel))
	{
	case 0:
	  return 0;
	case 1:
	  fprintf (stderr, "Time must be specified in YYYY/MM/DD\n");
	  return 0;
	default:
	  break;
	}
    }
  return 1;
}

void
print_usage (char *progname)
{
  fprintf (stderr, "\nUsage:\n"
	   "%s <WMM.COF> <lattidue> <longitude> <altitude> YYYY/MM/DD\n"
	   "- WMM.COF is a file containing world magnetic model spherical harmonic coefficients\n"
	   "- lattitude and longitude are given in (signed) degrees\n"
	   "- altitude is given in kilometers\n"
	   "\n"
	   "OUTPUTS: X, Y, and Z components of geomagnetic field vector, seperated by spaces\n"
	   "- X is the northerly intensity\n"
	   "- Y is the easterly intensity\n"
	   "- Z is the verticle intensity, positive downwards\n", progname);
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

  /*** Memory allocation ***/
  NumTerms = ((WMM_MAX_MODEL_DEGREES + 1) * (WMM_MAX_MODEL_DEGREES + 2) / 2);	/* WMM_MAX_MODEL_DEGREES is defined in WMM_Header.h */
  MagneticModel = WMM_AllocateModelMemory (NumTerms);	/* For storing the WMM Model parameters */
  TimedMagneticModel = WMM_AllocateModelMemory (NumTerms);	/* For storing the time modified WMM Model parameters */
  if (MagneticModel == NULL || TimedMagneticModel == NULL)
    WMM_Error (2);
  WMM_SetDefaults (&Ellip, MagneticModel, &Geoid);	/* Set default values and constants */
  /* Check for Geographic Poles */
  //WMM_readMagneticModel_Large(filename, MagneticModel); //Uncomment this line when using the 740 model, and comment out the  WMM_readMagneticModel line.
  if (!file_exists (argv[1]))
    {
      fprintf (stderr, "File %s does not exist\n", argv[1]);
      print_usage (argv[0]);
      exit (EXIT_FAILURE);
    }

  WMM_readMagneticModel (argv[1], MagneticModel);
  WMM_InitializeGeoid (&Geoid);	/* Read the Geoid file */
  //WMM_GeomagIntroduction (MagneticModel);     /* Print out the WMM introduction */

  /*** Get parameters from command line ***/
  if (!(argc == 6 &&
	readpos (argv[2], argv[3], argv[4], &CoordGeodetic, &Geoid) &&
	readdate (argv[5], MagneticModel, &UserDate)))
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
  printf ("%-9.1lf %-9.1lf %-9.1lf\n", GeoMagneticElements.X,
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
