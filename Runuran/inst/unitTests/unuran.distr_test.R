#############################################################################
##                                                                         ## 
## Test Runuran distribution classes                                       ## 
##                                                                         ## 
#############################################################################
##                                                                         ##
## Interface for classes                                                   ##
##                                                                         ##
##  - "unuran.cont"         ... univariate continuous distributions        ##
##  - "unuran.discr"        ... univariate discrete distributions          ##
##  - "unuran.cmv"          ... multivariate continuous distributions      ##
##                                                                         ##
## These are extensions of the virtual class "unuran.distr".               ##
##                                                                         ##
## Functions / Methods:                                                    ##
##                                                                         ##
##  - new()                 ... create new instance of class               ##
##  - unuran.cont.new()     ...   shortcut for "unuran.cont"               ##
##  - unuran.discr.new()    ...   shortcut for "unuran.discr"              ##
##  - unuran.cmv.new()      ...   shortcut for "unuran.cmv"                ##
##                                                                         ##
##  - ud()  ... density     ["unuran.cont" and "unuran.discr" only]        ##
##  - up()  ... CDF         ["unuran.cont" and "unuran.discr" only]        ##
##  - uq()  ... quantile    [not implemented]                              ##
##  - ur()  ... rng         [not implemented]                              ##
##                                                                         ##
#############################################################################

## --------------------------------------------------------------------------
##
## class "unuran.cont"
##
## --------------------------------------------------------------------------

## -- shortcut --------------------------------------------------------------

test.000.cont.new.default. <- function () {
  ## test: new("unuran.cont") and unuran.cont.new() have the same defaults.
  ## ('lb' and 'ub' are mandatory)
  d1 <- new("unuran.cont", lb=-Inf, ub=Inf)
  d2 <- unuran.cont.new(lb=-Inf, ub=Inf)
  ## slots 'distr' and 'env' are pointers and unique to each instance
  d2@distr <- d1@distr
  d2@env <- d1@env

  msg <- "\n   new('unuran.cont',...) and unuran.cont.new() have different defaults\n"
  checkIdentical(d1,d2)
}
 
## -- ud() and up(): normal -------------------------------------------------

test.001.ud.cont.......... <- function () {
  ## test: ud() and underlying PDF must give same results.
  distr <- unuran.cont.new(pdf=dnorm, lb=-Inf, ub=Inf)

  msg <- "\n   ud(): discrepancy for special values\n"
  x <- c(NA, NaN, -Inf, Inf)
  checkIdentical(ud(distr,x),dnorm(x), msg)

  msg <- "\n   ud(): discrepancy for random values\n"
  x <- rnorm(1000)
  checkEqualsNumeric(ud(distr,x),dnorm(x), tolerance=100*.Machine$double.eps, msg)
}

test.002.up.cont.......... <- function () {
  ## test: up() and underlying PDF must give same results.
  distr <- unuran.cont.new(cdf=pnorm, lb=-Inf, ub=Inf)

  msg <- "\n   up(): discrepancy for special values\n"
  x <- c(NA, NaN, -Inf, Inf)
  checkIdentical(up(distr,x),pnorm(x), msg)

  msg <- "\n   up(): discrepancy for random values\n"
  x <- rnorm(1000)
  checkEqualsNumeric(up(distr,x),pnorm(x), tolerance=100*.Machine$double.eps, msg)
}

## -- INVALID: unuran.cont.new ----------------------------------------------

test.011.new.cont.invalid <- function () {

  ## test: both 'lb' and 'ub' must be given, numeric, and 'lb'<'ub'
  msg <- "\n   unuran.cont: invalid arguments 'lb' and 'ub' not detected\n"
  checkException(unuran.cont.new(),msg)
  checkException(unuran.cont.new(lb=0),        msg)
  checkException(unuran.cont.new(ub=1),        msg)
  checkException(unuran.cont.new(lb=1, ub=0),  msg)
  checkException(unuran.cont.new(lb="a",ub=1), msg)
  checkException(unuran.cont.new(lb=0,ub="a"), msg)

  ## test: 'cdf' must be an R function
  msg <- "\n   unuran.cont: invalid argument 'cdf' not detected\n"
  checkException(unuran.cont.new(cdf=1, lb=0,ub=1), msg)

  ## test: 'pdf' must be an R function
  msg <- "\n   unuran.cont: invalid argument 'pdf' not detected\n"
  checkException(unuran.cont.new(pdf=1, lb=0,ub=1), msg)

  ## test: 'dpdf' must be an R function
  msg <- "\n   unuran.cont: invalid argument 'dpdf' not detected\n"
  checkException(unuran.cont.new(dpdf=1, lb=0,ub=1), msg)

  ## test: 'islog' must be a boolean
  msg <- "\n   unuran.cont: invalid argument 'islog' not detected\n"
  checkException(unuran.cont.new(islog=1, lb=0,ub=1), msg)

  ## test: 'mode' must be numeric
  msg <- "\n   unuran.cont: invalid argument 'mode' not detected\n"
  checkException(unuran.cont.new(mode="a", lb=0,ub=1), msg)

  ## test: 'center' must be numeric
  msg <- "\n   unuran.cont: invalid argument 'center' not detected\n"
  checkException(unuran.cont.new(center="a", lb=0,ub=1), msg)

  ## test: 'area' must be numeric and strictly positive
  msg <- "\n   unuran.cont: invalid argument 'area' not detected\n"
  checkException(unuran.cont.new(area="a", lb=0,ub=1), msg)
  checkException(unuran.cont.new(area=0, lb=0,ub=1),   msg)
  checkException(unuran.cont.new(area=-1, lb=0,ub=1),  msg)

  ## test: 'name' must be a character string
  msg <- "\n   unuran.cont: invalid argument 'name' not detected\n"
  checkException(unuran.cont.new(name=1, lb=0,ub=1), msg)
}

## -- INVALID: ud, up, uq, ur -----------------------------------------------

test.021.ud.cont.invalid.. <- function () {
  ## test: ud() requires PDF
  msg <- "\n   ud(): invalid argument 'obj' not detected\n"
  distr <- unuran.cont.new(cdf=pnorm, dpdf=function(x){-x^2}, lb=-Inf, ub=Inf)
  checkException(ud(distr,0), msg)
}

test.022.up.cont.invalid.. <- function () {
  ## test: up() requires CDF
  msg <- "\n   up(): invalid argument 'obj' not detected\n"
  distr <- unuran.cont.new(pdf=dnorm, dpdf=function(x){-x^2}, lb=-Inf, ub=Inf)
  checkException(up(distr,0), msg)
}

test.023.uq.cont.invalid.. <- function () {
  ## test: uq() requires quantile function (inverse CDF)
  msg <- "\n   uq(): invalid argument 'obj' not detected\n"
  distr <- unuran.cont.new(pdf=dnorm, dpdf=function(x){-x^2}, lb=-Inf, ub=Inf)
  checkException(uq(distr,0), msg)
}

test.024.ur.cont.invalid.. <- function () {
  ## test: ur() requires random variate generator
  msg <- "\n   ur(): invalid argument 'obj' not detected\n"
  distr <- unuran.cont.new(pdf=dnorm, dpdf=function(x){-x^2}, lb=-Inf, ub=Inf)
  checkException(ur(distr,1), msg)
}


## --------------------------------------------------------------------------
##
## class "unuran.discr"
##
## --------------------------------------------------------------------------

## -- shortcut --------------------------------------------------------------

test.100.discr.new.default <- function () {
  ## test: new("unuran.discr") and unuran.discr.new() have the same defaults.
  ## ('lb' and 'ub' are mandatory)
  d1 <- new("unuran.discr", lb=0, ub=100)
  d2 <- unuran.discr.new(lb=0, ub=100)
  ## slots 'distr' and 'env' are pointers and unique to each instance
  d2@distr <- d1@distr
  d2@env <- d1@env

  msg <- "\n   new('unuran.discr',...) and unuran.discr.new() have different defaults\n"
  checkIdentical(d1,d2)
}
 
## -- ud() and up(): binomial -----------------------------------------------

test.101.ud.discr......... <- function () {
  ## test: ud() and underlying PMF must give same results.
  size <- 100; prob <- 0.4 
  distr <- unuran.discr.new(pmf=function(x){dbinom(x,size,prob)}, lb=0, ub=size)

  msg <- "\n   ud(): discrepancy for special values\n"
  x <- c(NA, NaN, -Inf, Inf, 0, 1e300, -1e300)
  checkIdentical(ud(distr,x),dbinom(x,size,prob), msg)

  msg <- "\n   ud(): discrepancy for random values\n"
  x <- 0:size
  checkEqualsNumeric(ud(distr,x),dbinom(x,size,prob), tolerance=100*.Machine$double.eps, msg)
}

test.102.up.discr......... <- function () {
  ## test: up() and underlying CDF must give same results.
  size <- 100; prob <- 0.4 
  distr <- unuran.discr.new(cdf=function(x){pbinom(x,size,prob)}, lb=0, ub=size)

  msg <- "\n   up(): discrepancy for special values\n"
  x <- c(NA, NaN, -Inf, Inf, 0, 1e300, -1e300)
  checkIdentical(up(distr,x),pbinom(x,size,prob), msg)

  msg <- "\n   up(): discrepancy for random values\n"
  x <- 0:size
  checkEqualsNumeric(up(distr,x),pbinom(x,size,prob), tolerance=100*.Machine$double.eps, msg)
}

## -- ud() and up(): geometric ----------------------------------------------

test.103.ud.discr......... <- function () {
  ## test: ud() and underlying PMF must give same results.
  prob <- 0.4; size <- 1000
  distr <- unuran.discr.new(pmf=function(x){dgeom(x,prob)}, lb=0, ub=Inf)

  msg <- "\n   ud(): discrepancy for special values\n"
  x <- c(NA, NaN, -Inf, Inf)
  checkIdentical(ud(distr,x),dgeom(x,prob), msg)

  msg <- "\n   ud(): discrepancy for random values\n"
  x <- 0:size
  checkEqualsNumeric(ud(distr,x),dgeom(x,prob), tolerance=100*.Machine$double.eps, msg)
}

test.104.up.discr......... <- function () {
  ## test: up() and underlying CDF must give same results.
  prob <- 0.4; size <- 100
  distr <- unuran.discr.new(cdf=function(x){pgeom(x,prob)}, lb=0, ub=Inf)

  msg <- "\n   up(): discrepancy for special values\n"
  x <- c(NA, NaN, -Inf, Inf, 0, 1e300, -1e300)
  checkIdentical(up(distr,x),pgeom(x,prob), msg)

  msg <- "\n   up(): discrepancy for random values\n"
  x <- 0:100
  checkEqualsNumeric(up(distr,x),pgeom(x,prob), tolerance=100*.Machine$double.eps, msg)
}

## -- INVALID: unuran.discr.new ---------------------------------------------

test.111.new.discr.invali <- function () {

  ## test: both 'lb' and 'ub' must be given, numeric, and 'lb'<'ub'
  msg <- "\n   unuran.discr: invalid arguments 'lb' and 'ub' not detected\n"
  checkException(unuran.discr.new(),            msg)
  checkException(unuran.discr.new(ub=0),        msg)
  checkException(unuran.discr.new(lb=0),        msg)
  checkException(unuran.discr.new(lb=1,ub=0),   msg)
  checkException(unuran.discr.new(lb="a",ub=1), msg)
  checkException(unuran.discr.new(lb=0,ub="a"), msg)

  ## test: if 'pv' is given then, 'lb' must be given and numeric
  checkException(unuran.discr.new(pv=1:3,ub=0), msg)

  ## test: 'cdf' must be an R function
  msg <- "\n   unuran.discr: invalid argument 'cdf' not detected\n"
  checkException(unuran.discr.new(cdf=1, lb=0,ub=10), msg)

  ## test: 'pmf' must be an R function
  msg <- "\n   unuran.discr: invalid argument 'pmf' not detected\n"
  checkException(unuran.discr.new(pmf=0:10, lb=0,ub=10), msg)

  ## test: 'pv' must be a numeric array
  msg <- "\n   unuran.discr: invalid argument 'pv' not detected\n"
  checkException(unuran.discr.new(pv=rbinom, lb=0,ub=10), msg)

  ## test: 'mode' must be numeric
  msg <- "\n   unuran.discr: invalid argument 'mode' not detected\n"
  checkException(unuran.discr.new(mode="a", lb=0,ub=10), msg)

  ## test: 'sum' must be numeric and strictly positive
  msg <- "\n   unuran.discr: invalid argument 'sum' not detected\n"
  checkException(unuran.discr.new(sum="a", lb=0,ub=1), msg)
  checkException(unuran.discr.new(sum=0, lb=0,ub=1),   msg)
  checkException(unuran.discr.new(sum=-1, lb=0,ub=1),  msg)

  ## test: 'name' must be a character string
  msg <- "\n   unuran.discr: invalid argument 'name' not detected\n"
  checkException(unuran.discr.new(name=1, lb=0,ub=1), msg)
}

## -- INVALID: ud, up, uq, ur -----------------------------------------------

test.121.ud.discr.invalid. <- function () {
  ## test: ud() requires PMF
  msg <- "\n   ud(): invalid argument 'obj' not detected\n"
  distr <- unuran.discr.new(cdf=function(x){pbinom(x,10,0.5)}, pv=1:10, lb=0, ub=10)
  checkException(ud(distr,0), msg)
}

test.122.up.discr.invalid. <- function () {
  ## test: up() requires CDF
  msg <- "\n   up(): invalid argument 'obj' not detected\n"
  distr <- unuran.discr.new(pmf=function(x){dbinom(x,10,0.5)}, lb=0, ub=10)
  checkException(up(distr,0), msg)
}

test.123.uq.discr.invalid. <- function () {
  ## test: uq() requires quantile function (inverse CDF)
  msg <- "\n   uq(): invalid argument 'obj' not detected\n"
  distr <- unuran.discr.new(pmf=function(x){dbinom(x,10,0.5)}, lb=0, ub=10)
  checkException(uq(distr,0), msg)
}

test.124.ur.discr.invalid. <- function () {
  ## test: ur() requires random variate generator
  msg <- "\n   ur(): invalid argument 'obj' not detected\n"
  distr <- unuran.discr.new(pmf=function(x){dbinom(x,10,0.5)}, lb=0, ub=10)
  checkException(ur(distr,1), msg)
}


## --------------------------------------------------------------------------
##
## class "unuran.cmv"
##
## --------------------------------------------------------------------------

## -- shortcut --------------------------------------------------------------

test.200.cmv.new.default.. <- function () {
  ## test: new("unuran.cmv") and unuran.cmv.new() have the same defaults.
  d1 <- new("unuran.cmv")
  d2 <- unuran.cmv.new()
  ## slots 'distr' and 'env' are pointers and unique to each instance
  d2@distr <- d1@distr
  d2@env <- d1@env

  msg <- "\n   new('unuran.cmv',...) and unuran.cmv.new() have different defaults\n"
  checkIdentical(d1,d2)
}
 
## -- ud() ------------------------------------------------------------------

#test.001.ud.cont.......... <- function () {
#  ## test: ud() and underlying PDF must give same results.
#  distr <- unuran.cont.new(pdf=dnorm, lb=-Inf, ub=Inf)

#  msg <- "\n   ud(): discrepancy for special values\n"
#  x <- c(NA, NaN, -Inf, Inf)
#  checkIdentical(ud(distr,x),dnorm(x), msg)

#  msg <- "\n   ud(): discrepancy for random values\n"
#  x <- rnorm(1000)
#  checkEqualsNumeric(ud(distr,x),dnorm(x), tolerance=100*.Machine$double.eps, msg)
#}

## -- INVALID: unuran.cmv.new ---------------------------------------------..

test.211.new.cmv.invalid. <- function () {

  ## test; 'dim' must be an integer, 1 <= 'dim' <= 10000
  msg <- "\n   unuran.cmv: invalid argument 'dim' not detected\n"
  checkException(unuran.cmv.new(dim=0),      msg)
  checkException(unuran.cmv.new(dim=-1),     msg)
  checkException(unuran.cmv.new(dim=100001), msg)
  checkException(unuran.cmv.new(dim=2.5),    msg)
  checkException(unuran.cmv.new(dim="a"),    msg)

  ## test: 'pdf' must be an R function
  msg <- "\n   unuran.cmv: invalid argument 'pdf' not detected\n"
  checkException(unuran.cmv.new(pdf=1), msg)

  ## test: 'll' must be a numeric array of size 'dim'
  msg <- "\n   unuran.cmv: invalid argument 'll' not detected\n"
  checkException(unuran.cmv.new(dim=2, ll="a"), msg)
  checkException(unuran.cmv.new(dim=2, ll=1),   msg)
  checkException(unuran.cmv.new(dim=2, ll=1:3), msg)

  ## test: 'ur' must be a numeric array of size 'dim'
  msg <- "\n   unuran.cmv: invalid argument 'ur' not detected\n"
  checkException(unuran.cmv.new(dim=2, ur="a"), msg)
  checkException(unuran.cmv.new(dim=2, ur=1),   msg)
  checkException(unuran.cmv.new(dim=2, ur=1:3), msg)

  ## test: 'll' < 'ur'
  msg <- "\n   unuran.cmv: invalid argmuments 'll' and 'ur' not detected\n"
  checkException(unuran.cmv.new(dim=2, ll=c(1,1), ur=c(1,2)), msg)

  ## test: 'mode' must be a numeric array of size 'dim'
  msg <- "\n   unuran.cmv: invalid argument 'mode' not detected\n"
  checkException(unuran.cmv.new(dim=2, mode="a"), msg)
  checkException(unuran.cmv.new(dim=2, mode=1),   msg)
  checkException(unuran.cmv.new(dim=2, mode=1:3), msg)

  ## test: 'center' must be a numeric array of size 'dim'
  msg <- "\n   unuran.cmv: invalid argument 'center' not detected\n"
  checkException(unuran.cmv.new(dim=2, center="a"), msg)
  checkException(unuran.cmv.new(dim=2, center=1),   msg)
  checkException(unuran.cmv.new(dim=2, center=1:3), msg)

  ## test: 'name' must be a character string
  msg <- "\n   unuran.cmv: invalid argument 'name' not detected\n"
  checkException(unuran.cmv.new(name=1), msg)
}

## -- INVALID: ud, up, uq, ur -----------------------------------------------

test.221.ud.cmv.invalid... <- function () {
  ## test: ud() requires PDF
  msg <- "\n   ud(): invalid argument 'obj' not detected\n"
  distr <- unuran.cmv.new(dim=2, pdf=function(x){exp(-sum(x^2))})
  checkException(ud(distr,0), msg)
}

test.222.up.cmv.invalid... <- function () {
  ## test: up() requires CDF
  msg <- "\n   up(): invalid argument 'obj' not detected\n"
  distr <- unuran.cmv.new(dim=2, pdf=function(x){exp(-sum(x^2))})
  checkException(up(distr,0), msg)
}

test.223.uq.cmv.invalid... <- function () {
  ## test: uq() requires quantile function (inverse CDF)
  msg <- "\n   uq(): invalid argument 'obj' not detected\n"
  distr <- unuran.cmv.new(dim=2, pdf=function(x){exp(-sum(x^2))})
  checkException(uq(distr,1), msg)
}

test.224.ur.cmv.invalid... <- function () {
  ## test: ur() requires random variate generator
  msg <- "\n   ur(): invalid argument 'obj' not detected\n"
  distr <- unuran.cmv.new(dim=2, pdf=function(x){exp(-sum(x^2))})
  checkException(ur(distr,1), msg)
}

## -- End -------------------------------------------------------------------

