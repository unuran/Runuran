

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

UNURAN_TARGETS = \
	unuran-src unuran-roxy unuran-build unuran-devel unuran-check unuran-clean
SHORTCUT_TARGETS = \
	src roxy build devel check clean

.PHONY: all help $(UNURAN_TARGETS) $(SHORTCUT_TARGETS)

# --- Runuran ---------------------------------------------------------------

unuran-src:
	if test -d Runuran; then \
		(cd Runuran && ../scripts/update-sources.sh); \
		(cd Runuran && ../scripts/update-API.pl > inst/include/Runuran_API.h) \
	fi

unuran-roxy:
##	echo "library(roxygen2); roxygenize(\"Runuran\",roclets=\"rd\");" | $(R) --vanilla  
	(cd Runuran && echo "devtools::document(roclets=\"rd\")" | $(R) --vanilla)

unuran-build: ## unuran-src
	$(R) CMD build Runuran

unuran-devel: ## unuran-src
	$(R) CMD build --no-build-vignettes --no-manual Runuran

unuran-check: ## unuran-src
	(unset TEXINPUTS; _R_CHECK_TIMINGS_=0 $(R) CMD check --as-cran --timings Runuran_*.tar.gz)

unuran-clean:
	# Remove autotools files
	(cd ./Runuran && rm -rf configure config.log config.status autom4te.cache)
	(cd ./Runuran/src && rm -rf Makevars config.h* )
	# Remove compiled files
	(cd ./Runuran/src && rm -rf Runuran.so *.o )
	#(cd ./Runuran/inst/doc && \
	#    rm -f *.aux *.bbl *.blg *.log *.out *.toc && \
	#    rm -f Runuran.R Runuran.pdf Runuran.tex )
	# Remove R package files
	rm -rf Runuran.Rcheck
	rm -f Runuran_*
	# Remove emacs backup files
	find . -type f -name "*~" -exec rm -v {} ';'

# --- Short cuts ------------------------------------------------------------

src:   unuran-src
roxy:  unuran-roxy
build: unuran-build
devel: unuran-devel
check: unuran-check
clean: unuran-clean

# --- End -------------------------------------------------------------------
