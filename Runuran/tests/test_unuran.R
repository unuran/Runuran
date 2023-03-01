
#############################################################################
##                                                                         ##
##   Tests for class 'unuran'                                              ##
##                                                                         ##
#############################################################################

## --- Test Parameters ------------------------------------------------------

## size of sample for test
samplesize <- 1.e4

## break points for chi^2 GoF test
nbins <- as.integer(sqrt(samplesize))
breaks <- (0:nbins)/nbins

## level of significance
alpha <- 1.e-3

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
chisq.test( hist(pnorm(x),plot=FALSE,breaks=breaks)$density )

## Create an object
unr <- unuran.new("normal()")

## Draw samples
unuran.sample(unr)
unuran.sample(unr,10)
x <- unuran.sample(unr, samplesize)

## Run a chi-square GoF test
pval <- chisq.test( hist(pnorm(x),plot=FALSE,breaks=breaks)$density )$p.value
if (pval < alpha) stop("chisq test FAILED!  p-value=",signif(pval))

## --- Continuous distributions - S4 distribution object --------------------

## use PDF
gausspdf <- function (x) { exp(-0.5*x^2) }
gaussdpdf <- function (x) { -x*exp(-0.5*x^2) }
gauss <- new("unuran.cont", pdf=gausspdf, dpdf=gaussdpdf)
unr <- unuran.new(gauss, "tdr")
x <- unuran.sample(unr, samplesize)
pval <- chisq.test( hist(pnorm(x),plot=FALSE,breaks=breaks)$density )$p.value
if (pval < alpha) stop("chisq test FAILED!  p-value=",signif(pval))

## use logPDF
gausspdf <- function (x) { -0.5*x^2 }
gaussdpdf <- function (x) { -x }
gauss <- new("unuran.cont", pdf=gausspdf, dpdf=gaussdpdf, islog=TRUE)
unr <- unuran.new(gauss, "tdr")
x <- unuran.sample(unr, samplesize)
pval <- chisq.test( hist(pnorm(x),plot=FALSE,breaks=breaks)$density )$p.value
if (pval < alpha) stop("chisq test FAILED!  p-value=",signif(pval))

## --- Discrete distributions -----------------------------------------------

## Create an object
unr <- new("unuran", "binomial(20,0.5)", "dgt")

## Draw samples
unuran.sample(unr)
unuran.sample(unr,10)
x <- unuran.sample(unr, samplesize)

## --- End ------------------------------------------------------------------
