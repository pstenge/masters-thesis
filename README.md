This directory has a number of files:

* electhesis.cls provides a LateX class for generating an ME or PhD
thesis.

* electhesis.bst provides a BibTeX style for formatting references.

* eleccite.sty provides macros for reference citing.

* thesis.tex is a LaTeX example thesis template.  It uses a separate
  file for each chapter.

* Makefile for building the thesis if you have make installed.  Using
this the thesis pdf file (thesis.pdf) is built simply by typing make
at a shell prompt.

If you want to build things the hard way, use:

    pdflatex thesis
    bibtex thesis
    pdflatex thesis
    pdflatex thesis
