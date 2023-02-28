
all: help

help:
	@echo "clean ... clear working space"

clean: clean-runuran
	find . -type f -name "*~" -exec rm -v {} ';'

unuran-build: unuran-src
	R CMD build Runuran

unuran-check: unuran-src
	R CMD check Runuran

unuran-src:
	(cd Runuran; autoheader; autoconf)
	(cd ../unuran; \
		test -f configure || ./autogen.sh; \
		test -f src/unuran.h || make; )
	(cd ../unuran/src; \
		find ./ -type f -name '*.[ch]' -o -name '*.ch' | \
			grep -v "/tests/" | \
			grep -v "deprecated_.*\.c" | \
			grep -v "/uniform/.*\.c" | \
			cpio -vdump ../../R/Runuran/src/unuran-src; \
		cp -v ./unuran.h.in ../../R/Runuran/src/unuran-src; \
	)
	rm -v ./Runuran/src/unuran-src/unuran_config.h
	for f in `find ./Runuran/src/unuran-src -type f -name '*.[ch]' -o -name '*.ch'`; do \
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
		rm -rf unuran-src/* )

.PHONY: help clean clean-rstream clean-runuran unuran unuran-src unuran-check unuran-build
