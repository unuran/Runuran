
#############################################################################
##                                                                         ##
##   Tests for class 'unuran'                                              ##
##                                                                         ##
#############################################################################

## --- Test Parameters ------------------------------------------------------

samplesize <- 1e4

## --- Load library ---------------------------------------------------------

library(Runuran)

## --- Continuous distributions ---------------------------------------------

## Create an object
unr <- new("unuran", "normal()")

## Print object
unr
print(unr)

## Draw samples
unuran.sample(unr)
unuran.sample(unr,10)
x <- unuran.sample(unr, samplesize)

## Run a chi-square GoF test
chisq.test( hist(pnorm(x),plot=FALSE)$density )

## Create an object
unr <- unuran.new("normal()")

## Draw samples
unuran.sample(unr)
unuran.sample(unr,10)
x <- unuran.sample(unr, samplesize)

## Run a chi-square GoF test
chisq.test( hist(pnorm(x),plot=FALSE)$density )

## --- Continuous distributions - S4 distribution object --------------------

gausspdf <- function (x) { exp(-0.5*x^2) }
gaussdpdf <- function (x) { -x*exp(-0.5*x^2) }

gauss <- new("unuran.cont", pdf=gausspdf, dpdf=gaussdpdf)

unr <- unuran.new(gauss, "tdr")
x <- unuran.sample(unr, samplesize)
chisq.test( hist(pnorm(x),plot=FALSE)$density )

## --- Discrete distributions -----------------------------------------------

## Create an object
unr <- new("unuran", "binomial(20,0.5)", "dgt")

## Draw samples
unuran.sample(unr)
unuran.sample(unr,10)
x <- unuran.sample(unr, samplesize)

## --- End ------------------------------------------------------------------
