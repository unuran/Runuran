#############################################################################
##                                                                         ##
##   Tests for class 'unuran'                                              ##
##                                                                         ##
#############################################################################

## --- Test Parameters ------------------------------------------------------

samplesize <- 1e4

## --- Load library ---------------------------------------------------------

library(Runuran)

## --- Run tests ------------------------------------------------------------

## Create an object
unr <- new("unuran", "normal()")

## Draw a sample
x <- unuran.sample(unr, samplesize)

## Run a chi-square GoF test
chisq.test( hist(pnorm(x),plot=FALSE)$density )

## --- End ------------------------------------------------------------------
