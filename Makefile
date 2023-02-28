
all: help

unuran-build: unuran-src
	R CMD build Runuran

unuran-check: unuran-src
	R CMD check Runuran

unuran-src:
	(cd Runuran; autoheader; autoconf)
	(cd ../unuran; \
		test -f configure || ./autogen.sh; \
		test -f src/unuran.h || make; \
		find ./src -type f -name '*.[ch]' -o -name '*.ch' | \
			grep -v "/src/tests/" | \
			grep -v "deprecated_.*\.c" | \
			grep -v "/src/uniform/.*\.c" | \
			cpio -vdump ../R/Runuran/src/unuran-src; \
		rm -v ../R/Runuran/src/unuran-src/src/unuran_config.h; \
		cp -v ./src/unuran.h.in ../R/Runuran/src/unuran-src/src; \
	)
	for f in `find ./Runuran/src/unuran-src/src -type f -name '*.[ch]' -o -name '*.ch'`; do \
		../unuran/scripts/remove_comments.pl $$f; \
	done

clean-runuran:
	rm -rf Runuran.Rcheck
	rm -f Runuran_*
	(cd Runuran; \
		rm -rf configure config.log config.status autom4te.cache)
	(cd Runuran/src; \
		rm -f config.h*; \
		rm -f Runuran.so Runuran.o; \
		rm -rf unuran-src/src )

clean: clean-runuran
	find . -type f -name "*~" -exec rm -v {} ';'

help:
	@echo "clean ... clear working space"

.PHONY: help clean clean-rstream clean-runuran unuran unuran-src unuran-check unuran-build
