#############################################################################
##                                                                         ##
##   Tests for methods                                                     ##
##                                                                         ##
#############################################################################

## --- Load test routines and test parameters -------------------------------

source("test_routines.R")

## --- CONT: Chi^2 goodness-of-fit test -------------------------------------

## TDR (Transformed Density Rejection)
tdr.norm <- function (n) {
        pdf <- function (x) { exp(-0.5*x^2) }
        dpdf <- function (x) { -x*exp(-0.5*x^2) }
        dist <- new("unuran.cont", pdf=pdf, dpdf=dpdf)
        gen <- unuran.new(dist, "tdr")
        unuran.sample(gen,n)
}
unur.test.cont("norm.S4", rfunc=tdr.norm, pfunc=pnorm)

tdr.norm.withlog <- function (n) {
        logpdf <- function (x) { -0.5*x^2 }
        dlogpdf <- function (x) { -x }
        dist <- new("unuran.cont", pdf=logpdf, dpdf=dlogpdf, islog=TRUE)
        gen <- unuran.new(dist, "tdr")
        unuran.sample(gen,n)
}
unur.test.cont("norm.log.S4", rfunc=tdr.norm.withlog, pfunc=pnorm)

#tdr.norm.wod <- function (n) {
#        pdf <- function (x) { exp(-0.5*x^2) }
#        dist <- new("unuran.cont", pdf=pdf)
#        gen <- unuran.new(dist, "tdr")
#        unuran.sample(gen,n)
#}
#unur.test.cont("norm.S4", rfunc=tdr.norm.wod, pfunc=pnorm)


## --- DISCR: Chi^2 goodness-of-fit test ------------------------------------

## DGT (Discrete Guide Table method)
size <- 100
prob <- 0.3
binom.pmf <- function (x) { dbinom(x, size, prob) }
binom.probs <- dbinom(0:size, size, prob)
dgt.binom <- function (n,lb=0,ub=size) {
        dist <- new("unuran.discr", pv=binom.probs)
        gen <- unuran.new(dist, "dgt")
        unuran.sample(gen,n)
}
unur.test.discr("binomS4", rfunc=dgt.binom, dfunc=binom.pmf, domain=c(0,size))
unur.test.discr("binomS4", rfunc=dgt.binom, pv=binom.probs, domain=c(0,size))

## -- Print statistics ------------------------------------------------------

unur.test.statistic()

## -- End -------------------------------------------------------------------
