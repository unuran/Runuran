

# --- Constants -------------------------------------------------------------

# name of R program
R = R

# --- Help (default target) -------------------------------------------------

help:
	@echo ""
	@echo "  build   ... build Runuran package"
	@echo "  check   ... check Runuran package (run 'R CMD check')"
	@echo "  "
	@echo "  devel   ... build without vignettes etc (faster)"
	@echo "  src     ... copy (update) source files from UNU.RAN directory and run autotools"
	@echo "  version ... update version number and release date in documentation"
	@echo "  roxy    ... update help pages (roxygenize package)"
	@echo ""
	@echo "  clean   ... clear working space"
	@echo ""

# --- Phony targets ---------------------------------------------------------

UNURAN_TARGETS = \
	unuran-build unuran-check unuran-clean unuran-devel unuran-roxy unuran-src unuran-version
SHORTCUT_TARGETS = \
	build check clean devel roxy src version

.PHONY: help $(UNURAN_TARGETS) $(SHORTCUT_TARGETS)

# --- Runuran ---------------------------------------------------------------

unuran-src:
	if test -d Runuran; then \
		(cd Runuran && ../scripts/update-sources.sh); \
		(cd Runuran && ../scripts/update-API.pl > inst/include/Runuran_API.h) \
	fi

unuran-roxy:
##	echo "library(roxygen2); roxygenize(\"Runuran\",roclets=\"rd\");" | $(R) --vanilla  
	(cd Runuran && echo "devtools::document(roclets=\"rd\")" | $(R) --vanilla)

unuran-version:
	(cd Runuran && ../scripts/update-docu.pl -u)

unuran-build: ## unuran-src
	$(R) CMD build Runuran

unuran-devel: ## unuran-src
	$(R) CMD build --no-build-vignettes --no-manual Runuran

unuran-check: ## unuran-src
	(unset TEXINPUTS; _R_CHECK_TIMINGS_=0 $(R) CMD check --as-cran --timings Runuran_*.tar.gz)

unuran-clean:
# Remove autotools files (except ./configure and ./src/config.h.in)
	(cd ./Runuran && rm -rf config.log config.status autom4te.cache)
	(cd ./Runuran/src && rm -rf Makevars config.h)
# Remove compiled files
	(cd ./Runuran/src && rm -rf Runuran.so *.o )
	(cd ./Runuran/src/unuran-src && rm -rf */*.o )
#(cd ./Runuran/inst/doc && \
#       rm -f *.aux *.bbl *.blg *.log *.out *.toc && \
#       rm -f Runuran.R Runuran.pdf Runuran.tex )
# Remove R package files
	rm -rf Runuran.Rcheck
	rm -f Runuran_*
# Remove emacs backup files
	find . -type f -name "*~" -exec rm -v {} ';'

# --- Short cuts ------------------------------------------------------------

build:   unuran-build
check:   unuran-check
clean:   unuran-clean
devel:   unuran-devel
roxy:    unuran-roxy
src:     unuran-src
version: unuran-version

# --- End -------------------------------------------------------------------
