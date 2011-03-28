all : coordinate-translation.pdf 

coordinate-translation.pdf : coordinate-translation.tex
	pdflatex $<
	pdflatex $<

clean :
	rm -f *.aux *.log coordinate-translation.pdf
