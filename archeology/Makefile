FC=gfortran
FFLAGS=-ffixed-line-length-none

OBJ=allmag.o avec.o cross.o elaz.o geomag.o mvec.o newmagnav.o \
	orb.o orbel.o rotate.o sasorb.o vector.o

newmagnav : $(OBJ)
	$(FC) $(OBJ) -o newmagnav

clean :
	rm -f $(OBJ) newmagnav a.out
