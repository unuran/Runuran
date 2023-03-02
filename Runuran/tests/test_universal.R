#############################################################################
##                                                                         ##
##   Tests for methods                                                     ##
##                                                                         ##
#############################################################################

## --- Load test routines and test parameters -------------------------------

source("test_routines.R")

#############################################################################
##                                                                          #
##  CONT: Chi^2 goodness-of-fit test                                        #
##                                                                          #
#############################################################################

## --- ARS (Adaptive Rejection Sampling) ------------------------------------

ur.ars.norm.wl <- function (n) {
        logpdf <- function (x) { -0.5*x^2 }
        dlogpdf <- function (x) { -x }
        gen <- ars.new(logpdf=logpdf, dlogpdf=dlogpdf)
        ur(gen,n)
}
unur.test.cont("ur.ars.norm.wl", rfunc=ur.ars.norm.wl, pfunc=pnorm)
rm(ur.ars.norm.wl)

ur.ars.norm.wlwod <- function (n) {
        logpdf <- function (x) { -0.5*x^2 }
        gen <- ars.new(logpdf=logpdf)
        ur(gen,n)
}
unur.test.cont("ur.ars.norm.wlwod", rfunc=ur.ars.norm.wlwod, pfunc=pnorm)
rm(ur.ars.norm.wlwod)

## test arguments passed to PDF
ur.ars.norm.param <- function (n) {
        logpdf <- function (x,a) { a*x^2 }
        gen <- ars.new(logpdf=logpdf, a=-1/2)
        ur(gen,n)
}
unur.test.cont("ur.ars.norm.param", rfunc=ur.ars.norm.param, pfunc=pnorm)
rm(ur.ars.norm.param)


## --- TDR (Transformed Density Rejection) ----------------------------------

ur.tdr.norm <- function (n) {
        pdf <- function (x) { exp(-0.5*x^2) }
        dpdf <- function (x) { -x*exp(-0.5*x^2) }
        gen <- tdr.new(pdf=pdf, dpdf=dpdf)
        ur(gen,n)
}
unur.test.cont("ur.tdr.norm", rfunc=ur.tdr.norm, pfunc=pnorm)
rm(ur.tdr.norm)

ur.tdr.norm.wod <- function (n) {
        pdf <- function (x) { exp(-0.5*x^2) }
        gen <- tdr.new(pdf=pdf)
        ur(gen,n)
}
unur.test.cont("ur.tdr.norm.wod", rfunc=ur.tdr.norm.wod, pfunc=pnorm)
rm(ur.tdr.norm.wod)

ur.tdr.norm.wl <- function (n) {
        logpdf <- function (x) { -0.5*x^2 }
        dlogpdf <- function (x) { -x }
        gen <- tdr.new(pdf=logpdf, dpdf=dlogpdf, islog=TRUE)
        ur(gen,n)
}
unur.test.cont("ur.tdr.norm.wl", rfunc=ur.tdr.norm.wl, pfunc=pnorm)
rm(ur.tdr.norm.wl)

ur.tdr.norm.wlwod <- function (n) {
        logpdf <- function (x) { -0.5*x^2 }
        gen <- tdr.new(pdf=logpdf, islog=TRUE)
        ur(gen,n)
}
unur.test.cont("ur.tdr.norm.wlwod", rfunc=ur.tdr.norm.wlwod, pfunc=pnorm)
rm(ur.tdr.norm.wlwod)

## test arguments passed to PDF
ur.tdr.norm.param <- function (n) {
        pdf <- function (x,a) { exp(a*x^2) }
        gen <- tdr.new(pdf=pdf, a=-1/2)
        ur(gen,n)
}
unur.test.cont("ur.tdr.norm.param", rfunc=ur.tdr.norm.param, pfunc=pnorm)
rm(ur.tdr.norm.param)

ur.tdr.norm.R <- function (n) {
        gen <- tdr.new(pdf=dnorm)
        ur(gen,n)
}
unur.test.cont("ur.tdr.norm.R", rfunc=ur.tdr.norm.R, pfunc=pnorm)
rm(ur.tdr.norm.R)

ur.tdr.t.R <- function (n,df) {
        gen <- tdr.new(pdf=dt, df=df)
        ur(gen,n)
}
unur.test.cont("ur.tdr.t.R", rfunc=ur.tdr.t.R, pfunc=pt, df=8)
rm(ur.tdr.t.R)


#############################################################################
##                                                                          #
##  DISCR: Chi^2 goodness-of-fit test                                       #
##                                                                          #
#############################################################################

## --- DAU (Discrete Alias-Urn method) --------------------------------------

size <- 100
prob <- 0.3
binom.pmf <- function (x) { dbinom(x, size, prob) }
binom.probs <- dbinom(0:size, size, prob)
ur.dau.binom <- function (n,lb=0,ub=size) {
        gen <- dau.new(pv=binom.probs,from=lb)
        ur(gen,n)
}
unur.test.discr("ur.dau.binom", rfunc=ur.dau.binom, dfunc=binom.pmf, domain=c(0,size))
unur.test.discr("ur.dau.binom", rfunc=ur.dau.binom, pv=binom.probs, domain=c(0,size))
rm(ur.dau.binom)
rm(size,prob,binom.pmf,binom.probs)


## --- DGT (Discrete Guide Table method) ------------------------------------

size <- 100
prob <- 0.3
binom.pmf <- function (x) { dbinom(x, size, prob) }
binom.probs <- dbinom(0:size, size, prob)
ur.dgt.binom <- function (n,lb=0,ub=size) {
        gen <- dgt.new(pv=binom.probs,from=lb)
        ur(gen,n)
}
unur.test.discr("ur.dgt.binom", rfunc=ur.dgt.binom, dfunc=binom.pmf, domain=c(0,size))
unur.test.discr("ur.dgt.binom", rfunc=ur.dgt.binom, pv=binom.probs, domain=c(0,size))
rm(ur.dgt.binom)
rm(size,prob,binom.pmf,binom.probs)


#############################################################################
##                                                                          #
##  CMV: Chi^2 goodness-of-fit test                                         #
##                                                                          #
#############################################################################

samplesize <- 1.e4

## --- HITRO (Hit-and-Run + Ratio-of-Uniforms) ------------------------------

ur.hitro.norm <- function (n) {
        pdf <- function (x) { exp(-0.5*sum(x^2)) }
        gen <- hitro.new(dim=2, pdf=pdf, mode=c(0,0), thinning=10)
        ur(gen,n)
}
unur.test.cmv("ur.hitro.norm", rfunc=ur.hitro.norm, pfunc=pnorm)
rm(ur.hitro.norm)


## -- Print statistics ------------------------------------------------------

unur.test.statistic()

## -- End -------------------------------------------------------------------
