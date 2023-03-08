

# --- Constants -------------------------------------------------------------

# name of R program
R = R

# --- Default target --------------------------------------------------------

all: help

# --- Help ------------------------------------------------------------------

help:
	@echo ""
	@echo "unuran-build  ... build Runuran package"
	@echo "unuran-check  ... check Runuran package"
	@echo ""
	@echo "clean         ... clear working space"
	@echo ""

# --- Phony targets ---------------------------------------------------------

.PHONY: all help clean unuran-clean unuran-src unuran-check unuran-build

# --- Runuran ---------------------------------------------------------------

unuran-build: unuran-src
	$(R) CMD build Runuran

unuran-check: unuran-src
	(unset TEXINPUTS; $(R) CMD check Runuran)

unuran-src:
	(cd Runuran; autoheader; autoconf)
	(cd ../unuran; \
		test -f configure || ./autogen.sh; \
		test -f src/unuran.h || make; )
	if [[ ! -f Runuran/src/unuran-src/unuran.h ]]; then \
		(cd ../unuran/src; \
			find ./ -type f -name '*.[ch]' -o -name '*.ch' | \
				grep -v "deprecated_.*\.c" | \
				grep -v "/uniform/.*\.c" | \
				cpio -vdump ../../R/Runuran/src/unuran-src; \
			cp -v ./unuran.h.in ../../R/Runuran/src/unuran-src; \
		); \
		rm -vf ./Runuran/src/unuran-src/unuran_config.h; \
		for f in `find ./Runuran/src/unuran-src -type f -name '*.[ch]' -o -name '*.ch'`; do \
			../unuran/scripts/remove_comments.pl $$f; \
		done; \
	fi

unuran-clean:
	rm -rf Runuran.Rcheck
	rm -f Runuran_*
	(cd Runuran; \
		rm -rf configure config.log config.status autom4te.cache)
	(cd Runuran/src; \
		rm -f Makevars; \
		rm -f config.h*; \
		rm -f Runuran.so Runuran.o Runuran_distr.o Runuran_pinv.o performance.o distributions.o)
	(cd Runuran/src/unuran-src; \
		rm -rf * )
	(cd Runuran/inst/doc; \
		rm -f *.aux *.bbl *.blg *.log *.out *.toc; \
		rm -f Runuran.R Runuran.pdf Runuran.tex )

# --- Clear working space ---------------------------------------------------

clean: unuran-clean 
	find . -type f -name "*~" -exec rm -v {} ';'

# --- End -------------------------------------------------------------------
