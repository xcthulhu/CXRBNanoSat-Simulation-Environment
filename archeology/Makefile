FC=gfortran
FFLAGS=-ffixed-line-length-none

OBJ=allmag.o avec.o cross.o elaz.o geomag.o mvec.o newmagnav.o \
	orb.o orbel.o rotate.o sasorb.o vector.o

all : newmagnav newmagnav.pdf

newmagnav : $(OBJ)
	$(FC) $(OBJ) -o newmagnav

newmagnav.pdf : newmagnav.tex
	pdflatex $<

clean :
	rm -f $(OBJ) newmagnav a.out *.aux *.log newmagnav.pdf
