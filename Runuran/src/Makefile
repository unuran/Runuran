
UNURAN_DIR := unuran-src
UNURAN_SRC := $(wildcard ${UNURAN_DIR}/src/*/*.c)
UNURAN_CPPFLAGS := -I. -I${UNURAN_DIR}/src -I${UNURAN_DIR}/src/tests -DHAVE_CONFIG_H

## UNURAN_CFLAGS := -Wall -pedantic
UNURAN_CFLAGS := 

all: libRunuran

libRunuran:
	@echo "Create shared library for UNU.RAN"
	PKG_CFLAGS="${UNURAN_CFLAGS}" PKG_CPPFLAGS="${UNURAN_CPPFLAGS}" \
		"${R_HOME}/bin/R" CMD SHLIB Runuran.c ${UNURAN_SRC}

clean:
	@echo "Clear working space"
	rm -f Runuran.o Runuran.so config.h
	find ./unuran-src/src -type f -name '*.o' -exec rm -v {} ';'
