#! /bin/sh

# ---------------------------------------------------------------------------
# Run this script in the top-level Runuran directory.
# The script copies all required UNU.RAN C files into the Runuran directory.
# ---------------------------------------------------------------------------

UNURAN_DIR="../../unuran"

# Check directory
PACKAGE=`grep -s "Package: Runuran" DESCRIPTION`
test -f DESCRIPTION -a "$PACKAGE" || { \
    echo "You must run this script in the top-level Runuran directory"
    exit 1
}

# Check UNU.RAN directory
test -d "$UNURAN_DIR" || { \
    echo "Cannot find UNU.RAN directory $UNURAN_DIR"
    exit 1
}

# Remove old UNU.RAN files first
echo "Remove old UNU.RAN files ..."
(cd ./src/unuran-src && rm -rf * )
(cd ./inst/include && rm -f Runuran.h Runuran_ext.h unuran.h )

# Generate autotools files
autoheader
autoconf

# Create all files in UNU.RAN directory (if necessary)
echo "Create UNU.RAN files ..."
(cd "$UNURAN_DIR"; \
 test -f configure || ./autogen.sh; \
 test -f src/unuran.h || make; ) || exit 1

# Copy files from UNU.RAN directory
echo "Copy UNU.RAN files ..."
(cd "$UNURAN_DIR/src";
 find ./ -type f -name '*.[ch]' -o -name '*.ch' | \
     grep -v "deprecated_.*\.c" | \
     grep -v "obsolete_.*\.c" | \
     grep -v "uniform/.*\.c" | \
     grep -v "uniform/unuran_.*\.h" | \
     grep -v "specfunct/cephes_.*" | \
     grep -v "tests/chi2test\.c" | \
     grep -v "tests/correlation\.c" | \
     grep -v "tests/moments\.c" | \
     grep -v "tests/printsample\.c" | \
     grep -v "tests/quantiles\.c" | \
     grep -v "tests/tests\.c" | \
     grep -v "tests/timing\.c" | \
     grep -v "unuran_config\.h" ) \
    | cpio -vdump -D "$UNURAN_DIR/src" src/unuran-src;
cp -av "$UNURAN_DIR/src/unuran.h.in" src/unuran-src;
cp -av "$UNURAN_DIR/src/uniform/mrg31k3p.c" src/unuran-src/uniform;

# Strip comments from UNU.RAN files
for f in `find ./src/unuran-src -type f -name '*.[ch]' -o -name '*.ch'`; do
    $UNURAN_DIR/scripts/remove_comments.pl $f;
done

# Copy files into inst/include directory
cp -v ./src/Runuran_ext.h       ./inst/include/
cp -v ./src/Runuran.h           ./inst/include/
cp -v ./src/unuran-src/unuran.h ./inst/include/

# End
exit 0

