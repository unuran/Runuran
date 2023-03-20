## --------------------------------------------------------------------------
##
## Handle options for package "Runuran"
##
## --------------------------------------------------------------------------
##
## This is based on 'igraph.options' in package 'igraph'
## by Gabor Csardi <csardi.gabor@gmail.com>
##
## --------------------------------------------------------------------------

## --- Defaults for options -------------------------------------------------

unuran.error.level.default = "warning"

## --- Current list of options ----------------------------------------------

.Runuran.Options <- list(
    error.level = unuran.error.level.default
)

## --- Callback: display unuran errors --------------------------------------

## default: "warning"
.unuran.error.level <- unuran.error.level.default

.Runuran.options.set.error.level <- function(level, calledby) {

    env <- asNamespace("Runuran")

    if (! is.na(pmatch(level, "default"))) {
        level <- unuran.error.level.default
    }

    if (! is.na(pmatch(level, "all"))) {
        level <- "all"
        .Call(C_Runuran_set_error_level, 3L)
    } else if (! is.na(pmatch(level, "warning"))) {
        level <- "warning"
        .Call(C_Runuran_set_error_level, 2L)
    } else if (! is.na(pmatch(level, "error"))) {
        level <- "error"
        .Call(C_Runuran_set_error_level, 1L)
    } else if (! is.na(pmatch(level, "none"))) {
        level <- "none"
        .Call(C_Runuran_set_error_level, 0L)
    } else {
        .Runuran.stop("Invalid value for option 'error.level'. ",
                      "Possible values: \"default\", \"all\", \"warning\", \"error\", \"none\".",
                      calledby=calledby)
    }

    ## store current level 
    assign(".unuran.error.level", level, env)

    ## return level 
    level
}

## --- List of callback functions for setting option values -----------------

.Runuran.options.callbacks <- list(
    ## whether UNU.RAn warnings and errors should be displayed
    error.level = .Runuran.options.set.error.level
)

### FIXME: help page for Runuran.options()
### ==========================================================================
###'
###' Set or return options of rvgt library
###' 
### --------------------------------------------------------------------------
###'
###' @description
###'
###' Library \pkg{rvgt} has some parameters which (usually) affect the
###' behavior of its functions. These can be set for the whole session
###' via \code{rvgt.options}.
###' 
### --------------------------------------------------------------------------
###'
###' @details
###'
###' This function provides a tool to control the behavior of library
###' \pkg{rvgt}. A list may be given as the only argument, or any
###' number of arguments may be in the \code{name=value} form.
###' If no arguments are specified then the function returns the
###' current settings of all parameters. 
###' If a single option name is given as character string, then its
###' value is returned (or \code{NULL} if it does not exist).
###' Option \emph{values} may be abbreviated.
###'
###' The currently used parameters in alphabetical order:
###' \describe{
###' \item{rngkind:}{
###'    character or \code{NULL} that is used to set the
###'    underlying uniform RNG for tests,
###'    see \code{\link{RNGkind}} for possible values.
###'    Notice, however, that this RNG is used \emph{only} if the
###'    \code{seed} argument is set in a particular test.
###' }
###' \item{sessioninfo:}{
###'    logical. If \code{TRUE} (the default), then package versions
###'    are shown with \code{\link{rvgt.show}}.
###' }
###' \item{timing:}{
###'    character string that controls the timing method for estimating
###'    marginal running times. The following methods can be used:
###'    \describe{
###'    \item{\code{"cputime"}:}{
###'       user and system CPU time from \code{\link{proc.time}} is used.
###'       This method is less volatile on a busy machine
###'       but has a coarser time resolution than the other methods.
###'       (default)}
###'    \item{\code{"elapsed"}:}{
###'       the elapsed time from \code{\link{proc.time}} is used.}
###'    \item{\code{"microbm"}:}{
###'       function \code{\link[microbenchmark]{get_nanotime}} from package
###'       \pkg{microbenchmark} is used.
###'       Note that currently function
###'       \code{\link[microbenchmark]{microbenchmark}} is not used.}
###'    }
###' }
###' \item{uresolution:}{
###'    numeric between \code{1e-5} and \code{1e-15}.
###'    It is used whenever function \code{\link[Runuran]{pinv.new}}
###'    from \pkg{Runuran} is called internally.
###'    Default is \code{1e-12}.
###' }
###' \item{color.trans:}{
###'    Debugging tool.
###'    Character string that controls a possible transforming the
###'    colors used in (some) \pkg{rvgt} plots. This may help to find
###'    colors that are also suitable for B/W printers and color blind
###'    people. 
###'    Possible values are:
###'    \describe{
###'    \item{\code{"none"}:}{
###'       No transformation is performed.  (default)}
###'    \item{\code{"grey"}:}{
###'       Transforms the given colors to the corresponding colors
###'       with chroma removed (collapsed to zero) in HCL space.
###'       See \code{\link[colorspace]{desaturate}} in the
###'       \pkg{colorspace} package for more details.}
###'    \item{\code{"deutan"}, \code{"protan"}, \code{"tritan"}:}{
###'       Collapses red-green or green-blue color distinctions to
###'       approximate the effect of the three forms of dichromacy:
###'       protanopia and deuteranopia (red-green color blindness), and
###'       tritanopia (green-blue color blindness).
###'       See \code{\link[dichromat]{dichromat}} in the
###'       \pkg{dichromat} package for more details.}
###'    \item{\code{"DEBUG-R"}, \code{"DEBUG-G"}, \code{"DEBUG-B"}:}{
###'       Turn all colors into plain red, green, and blue, respectively.
###'       Only useful to detect colors that are not influenced by this
###'       option.}
###'    }
###' }
#### \item{DEBUG:}{
####    Debugging switch. Must be named list.
####    Possible values:
####      list(legend.colors=TRUE)
#### }
###' }
### 
### --------------------------------------------------------------------------
###'
###' @author Josef Leydold \email{josef.leydold@@wu.ac.at}
###'
### --------------------------------------------------------------------------
###' 
###' @examples
###' 
###' oldval <- rvgt.options()
###' rvgt.options(timing="elapsed")
###' rvgt.options(oldval)
###'
### --------------------------------------------------------------------------
###
###  Arguments:
###
###' @param \dots
###'        A list may be given as the only argument, or any number of
###'        arguments may be in the \code{name=value} form, a character
###'        string for the name of a parameter, or no argument at all
###'        may be given.
###'
### --------------------------------------------------------------------------
###'
###' @return
###'
###' \code{rvgt.options} returns a list with the updated values of the
###' parameters. If the argument list is not empty, the returned list
###' is invisible. If a single character string is given, then the
###' value of the corresponding parameter is returned (or \code{NULL}
###' if the parameter is not used).
###'
### --------------------------------------------------------------------------
### @export
### --------------------------------------------------------------------------

Runuran.options <- function(...) {
    ## ----------------------------------------------------------------------
    ## 
    ## ----------------------------------------------------------------------
    ## ... : list of options
    ## ----------------------------------------------------------------------

    ## current list of options
    current <- .Runuran.Options
    
    ## no arguments --> return list of option values
    if (nargs() == 0)
        return(current)

    ## read arguments
    temp <- list(...)

    if (length(temp) == 1 && is.null(names(temp))) {
        arg <- temp[[1]]
        switch(mode(arg),
               list =
                   ## case: options given as list
                   temp <- arg,

               character =
                   ## case: ask for value of option 'arg'
                   if( isTRUE(arg %in% names(.Runuran.Options)))
                       return(.Runuran.Options[arg])
                   else
                       return(NULL),
               .Runuran.stop("Invalid argument ", sQuote(arg),"."))
    }

    ## no options given
    if (length(temp) == 0)
        return(current)

    ## no 'key=value' pair given
    if (is.null(names(temp)))
        .Runuran.stop("Options must be given by name.")

    ## check for invalid option names
    for (cn in names(temp)) {
        if(is.na(match(cn, names(.Runuran.Options))))
            .Runuran.stop("Invalid option ", sQuote(cn), ".")
    }

    ## execute callback function on all options (if available)
    cb <- intersect(names(.Runuran.options.callbacks), names(temp))
    for (cn in cb) {
        temp[[cn]] <- .Runuran.options.callbacks[[cn]](temp[[cn]], match.call())
    }

    ## update option values
    current[names(temp)] <- temp
    assign(".Runuran.Options", current, envir = asNamespace("Runuran"))

    ## return updated list
    invisible(current)
}

## --- End ------------------------------------------------------------------
