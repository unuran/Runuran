
#############################################################################
#
#  Makefile for building and checking R package 'Runuran'
#
#############################################################################

# --- Constants -------------------------------------------------------------

# name of project
project = Runuran

# name of R program
R = R

# --- Help (default target) -------------------------------------------------

help:
	@echo ""
	@echo "  build    ... build package '${project}'"
	@echo "  check    ... check package '${project}' (run 'R CMD check')"
	@echo "  "
	@echo "  src      ... copy (update) source files from UNU.RAN directory and run autotools"
	@echo "  version  ... update version number and release date in documentation"
	@echo "  roxy     ... update help pages (roxygenize package)"
	@echo ""
	@echo "  develbuild ... build without vignettes etc (faster)"
	@echo "  develcheck ... check package '${project}' in NOT_ON_CRAN mode"
	@echo "  valgrind ... check package '${project}' using valgrind (very slow!)"
	@echo ""
	@echo "  clean    ... clear working space"
	@echo "  very-clean ... clear working space and submodules"
	@echo ""

# --- Phony targets ---------------------------------------------------------

.PHONY: help  build check clean devel roxy src version

# --- Runuran ---------------------------------------------------------------

src:
	(cd ${project} && ../scripts/update-sources.sh);
	(cd ${project} && ../scripts/update-API.pl > inst/include/Runuran_API.h)

roxy:
##	echo "library(roxygen2); roxygenize(\"Runuran\",roclets=\"rd\");" | ${R} --vanilla
	(cd ${project} && echo "devtools::document(roclets=\"rd\")" | ${R} --vanilla)

version:
	(cd ${project} && ../scripts/update-docu.pl -u)

build:
	${R} CMD build ${project}

develbuild:
	${R} CMD build --no-build-vignettes --no-manual ${project}

check:
	(unset TEXINPUTS; _R_CHECK_TIMINGS_=0 ${R} CMD check --as-cran --timings ${project}_*.tar.gz)

develcheck:
	(unset TEXINPUTS; \
	export NOT_CRAN="true"; \
	_R_CHECK_TIMINGS_=0 ${R} CMD check --timings ${project}_*.tar.gz)

valgrind:
	(unset TEXINPUTS; \
	export NOT_CRAN="true"; \
	_R_CHECK_TIMINGS_=0 ${R} CMD check --use-valgrind --timings ${project}_*.tar.gz)

	@echo -e "\n * Valgrind output ..."
	@for Rout in `find ${project}.Rcheck/ -name *.Rout`; \
		do echo -e "\n = $$Rout:\n"; \
		grep -e '^==[0-9]\{3,\}== ' $$Rout; \
	done

# --- Clear working space ---------------------------------------------------

clean:
# Remove autotools files (except ./configure and ./src/config.h.in)
	@(cd ./${project} && rm -rf config.log config.status autom4te.cache)
	@(cd ./${project}/src && rm -rf Makevars config.h)
# Remove compiled files
	@(cd ./${project}/src && rm -rf *.so *.o)
	@(cd ./${project}/src/unuran-src && rm -rf */*.o)
# Remove R package files
	rm -rf ${project}.Rcheck
	rm -f ${project}_*.tar.gz
# Remove emacs backup files
	find . -type f -name "*~" -exec rm -v {} ';'

very-clean: clean
# Clean UNU.RAN submodules
	@(cd ./unuran && test -f Makefile && make maintainer-clean || true)

# --- End -------------------------------------------------------------------
