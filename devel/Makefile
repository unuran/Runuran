## --------------------------------------------------------------------------
## Install R package from directory and run test suite
## --------------------------------------------------------------------------

## --- Constants ------------------------------------------------------------

SHELL := /bin/bash

TOP   = ../Runuran                  ## top directory of package
PKG   = ${shell cd ${TOP};pwd}      ## name of top directory
SUITE = runalltests.R
R     = R

## --- Help (default target) ------------------------------------------------

help:
	@echo ""
	@echo "  src    ... copy (update) source files from UNU.RAN directory and run autotools"
	@echo "  inst   ... install package from directory 'Runuran'"
	@echo "  check  ... run testthat suite in 'Runuran/test'"
	@echo "  test   ... same as 'check'"
	@echo "  clean  ... clear working space"
	@echo ""

## --- Phony targets --------------------------------------------------------

.PHONY: all check clean inst test

## --- Install and test -----------------------------------------------------

all: src inst test

src:
# Copy unuran src files
	(cd ${TOP} && ../scripts/update-sources.sh); \
	(cd ${TOP} && ../scripts/update-API.pl > inst/include/Runuran_API.h)

inst:
# Install package
	${R} CMD INSTALL ${PKG}

test:
# Run unit tests
	${R} --vanilla --slave < ${SUITE}

check: # same as 'test'
	make test 

clean:
	@echo "clear working space ..."
	@rm -vf .RData Rplots.pdf *~
	@(cd ${TOP} && rm -vf ./tests/testthat/.RData ../../tests/testthat/Rplots.pdf)

# --- End -------------------------------------------------------------------
