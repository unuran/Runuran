

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

.PHONY: all help clean \
	unuran-clean unuran-src unuran-check unuran-build unuran-devel

# --- Runuran ---------------------------------------------------------------

unuran-build: unuran-src
	$(R) CMD build Runuran

unuran-devel: unuran-src
	$(R) CMD build --no-vignettes --no-manual Runuran

unuran-check: unuran-src
	(unset TEXINPUTS; _R_CHECK_TIMINGS_=0 $(R) CMD check --as-cran --timings Runuran_*.tar.gz)

unuran-src:
	if test -d Runuran; then \
		(cd Runuran && ./src/scripts/update-sources.sh); \
		(cd Runuran && ./src/scripts/update-API.pl > inst/include/Runuran_API.h) \
	fi

unuran-clean:
	rm -rf Runuran.Rcheck
	rm -f Runuran_*
	if test -d Runuran; then \
		(cd Runuran &&  ./scripts/clean-sources.sh) \
	fi

# --- Clear working space ---------------------------------------------------

clean: unuran-clean 
	find . -type f -name "*~" -exec rm -v {} ';'

# --- End -------------------------------------------------------------------
