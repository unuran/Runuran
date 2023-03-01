
# --- Default target --------------------------------------------------------

all: help

help:
	@echo "clean ... clear working space"

# --- Phony targets ---------------------------------------------------------

.PHONY: all help clean clean-runuran unuran-src unuran-check unuran-build

# --- Runuran ---------------------------------------------------------------

unuran-build: unuran-src
	R CMD build Runuran

unuran-check: unuran-src
	(unset TEXINPUTS; R CMD check Runuran)

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

# --- Clear working space ---------------------------------------------------

clean: clean-runuran
	find . -type f -name "*~" -exec rm -v {} ';'

clean-runuran:
	rm -rf Runuran.Rcheck
	rm -f Runuran_*
	(cd Runuran; \
		rm -rf configure config.log config.status autom4te.cache)
	(cd Runuran/src; \
		rm -f Makevars; \
		rm -f config.h*; \
		rm -f Runuran.so Runuran.o Runuran_distr.o; \
		rm -rf unuran-src/* )

# --- End -------------------------------------------------------------------
