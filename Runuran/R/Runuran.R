#############################################################################
##                                                                         ##
##   Class: unuran                                                         ##
##                                                                         ##
#############################################################################
##                                                                         ##
##   Interface to the UNU.RAN library for                                  ##
##   Universal Non-Uniform RANdom variate generators                       ##
##                                                                         ##
#############################################################################

## Initialize global variables ----------------------------------------------

## Class --------------------------------------------------------------------

setClass( "unuran", 
         ## slots:
         representation( 
                        distr   = "character",     # distribution
                        method  = "character",     # generation method
                        unur    = "externalptr"    # pointer to UNU.RAN object
                        ),
         ## defaults for slots
         prototype = list(
                 distr  = character(),
                 method = "auto",
                 unur   = NULL
                 ),
         ## misc
         sealed = TRUE
         )

## Initialize ---------------------------------------------------------------

setMethod( "initialize", "unuran",  
          function(.Object, distr=NULL, method="auto") {

                  ## Check entries
                  if (is.null(distr)) {
                          stop("no distribution given", call.=FALSE) }
                  if (!is.character(distr)) {
                          stop("'distr' must be a character string", call.=FALSE) }
                  if (!is.character(method)) {
                          stop("'method' must be a character string", call.=FALSE) }

                  ## Store informations 
                  .Object@distr <- distr
                  .Object@method <- method

                  ## Create UNU.RAN object
                  .Object@unur <-.Call("Runuran_init", distr, method, PACKAGE="Runuran")

                  ## Check UNU.RAN object
                  if (is.null(.Object@unur)) {
                          stop("Cannot create UNU.RAN object", call.=FALSE)
                  }

                  ## return new UNU.RAN object
                  .Object
          } )

## Validity -----------------------------------------------------------------

## Sampling -----------------------------------------------------------------

## unuran.sample
## ( We avoid using a method as this has an expensive overhead. )
unuran.sample <- function(unr,n=1) { 
        .Call("Runuran_sample", unr@unur, n, PACKAGE="Runuran")
}

## r
##    method alias for unuran.sample  (slow!!)
if(!isGeneric("r"))
        setGeneric("r", function(unur,...) standardGeneric("r"))

setMethod("r", "unuran",
          function(unur,n=1) {
                  .Call("Runuran_sample", unr@unur, n, PACKAGE="Runuran")
          } )

## Printing -----------------------------------------------------------------

## print strings of UNU.RAN object
setMethod( "print", "unuran",
          function(x, ...) {
                  cat("\nObject is UNU.RAN object:\n")
                  cat("\tdistr:  ",x@distr,"\n")
                  cat("\tmethod: ",x@method,"\n\n")
} )

setMethod( "show", "unuran",
          function(object) { print(object) } )


## End ----------------------------------------------------------------------

###print("------------------------Beispiele ----------------------")
#### Beispiel 1
###datanormal1=sample.unur(gen1,5)
###print(datanormal1)
####
#### Beispiel 2
###gen2<-new("unur","normal(1,2);domain=(0,inf)")
###datanormal2=sample.unur(gen2,5)
###print(datanormal2)
###hist(z<-sample.unur(gen2,100000),breaks=20)
####
#### Beispiel 3
###gen3<-new("unur","normal(1,2);domain=(0,inf)&method=hinv")
###datanormal3=sample.unur(gen3,5)
###print(datanormal3)
###hist(z<-sample.unur(gen3,100000),breaks=20)
####
#### Beispiel 4
###gen4<-new("unur","distr = cont; pdf=\"1-x*x\"; domain=(-1,1) & method=tdr")
###datanormal4=sample.unur(gen4,5)
###print(datanormal4)
###hist(z<-sample.unur(gen4,100000),breaks=20)
###
#### Beispiel 5 hyperbolische Funktion
###gen5<-new("unur","distr = cont; pdf=\"1/sqrt(1+x^2)*exp(-2*sqrt(1+x^2)+1*x)\"; domain=(-1,3) & method=tdr")
###datanormal5=sample.unur(gen5,5)
###print(datanormal5)
###hist(z<-sample.unur(gen5,100000),breaks=20)
###
####------output to postscript file----------
#### postscript("bild.ps",horizontal=FALSE)     # open Device postscript - see also help(Device)
#### hist(z <- sample.unur(gen5, 1e+05), breaks = 40,tck=0.01,main="Titel")
#### graphics.off()                           # close graphic Devices
