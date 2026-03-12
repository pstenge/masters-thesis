# Example Makefile to build thesis
# Michael Hayes, UCECE
# 9 March 2009
#
# To generate a more sophisticated Makefile that adds dependencies
# for included files see mtexrules.py

all: thesis.pdf

.SUFFIXES:

%.pdf: %.aux %.bbl %.ind
	pdflatex $*; pdflatex $*

%.ind: %.aux
	-makeindex $*

%.bbl: %.aux
	-bibtex $*

%.aux: %.tex $(wildcard *.tex) references.bib
	pdflatex $*

.PHONY: clean
clean:
	-rm *.aux *.log *.bbl *.blg *.ps *.toc

.PHONY: realclean
realclean: clean
	-rm thesis.pdf *~

