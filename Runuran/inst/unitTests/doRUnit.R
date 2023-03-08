
## --- Constants ---

## Package name
pkg <- "Runuran"

## verbosity
VERBOSE <- FALSE

## --- Setup ---

## Load package 'RUnit' 
if(! require("RUnit", quietly=TRUE)) {
  message("\ncannot run unit tests -- package 'RUnit' is not available\n")
  quit(save="no",runLast=FALSE)
}

## Load package
library(package=pkg, character.only=TRUE)

## Path to unit test files
if(Sys.getenv("RCMDCHECK") == "FALSE") {
  ## Path to unit tests for standalone running under Makefile (not R CMD check)
  ## PKG/tests/../inst/unitTests
  runitDir <- file.path(getwd())
} else {
  ## Path to unit tests for R CMD check
  ## PKG.Rcheck/tests/../PKG/unitTests
  runitDir <- system.file(package=pkg, "unitTests")
}
cat("\nRunning unit tests ...\n",
    "*  package name       =",pkg,"\n",
    "*  working directory  =",getwd(),"\n",
    "*  path to unit tests =",runitDir,"\n\n")

## Set RUnit options
RUnit_opts <- getOption("RUnit", list())
RUnit_opts$verbose <- 1L      ## Print names of executed tests
RUnit_opts$silent <- TRUE     ## Do not print error messages during exception checks
RUnit_opts$silent <- FALSE
options(RUnit = RUnit_opts)

## Print warnings immediately
options(warn=1)

## --- Testing ---

## Define tests
testSuite <- defineTestSuite(name = paste(pkg, "Test Suite"),
                             dirs = runitDir,
                             testFileRegexp = ".*_test\\.[rR]$",
                             testFuncRegexp = "^test\\.+",
                             rngKind = "default",
                             rngNormalKind = "default")

## Run tests
result <- runTestSuite(testSuite)
 
## --- Report Test Results ---
cat("------------------- UNIT TEST SUMMARY ---------------------\n\n")

## Default report name
pathReport <- file.path(runitDir, "report")

## Print in stdout
printTextProtocol(result, showDetails=FALSE)

## Create report files
printTextProtocol(result, showDetails=TRUE,
                  fileName=paste(pathReport, ".txt", sep=""))

## Report to HTML file
printHTMLProtocol(result, fileName=paste(pathReport, ".html", sep=""))
 
## Return stop() to cause R CMD check stop in case of
##  - failures i.e. FALSE to unit tests or
##  - errors i.e. R errors
tmp <- getErrors(result)
if(tmp$nFail > 0 | tmp$nErr > 0) {
  stop(paste("\n\nUnit tests failed for package '",pkg,"'!\n",
             "\t(#test failures: ", tmp$nFail, ", #R errors: ", tmp$nErr, ")\n\n",
             sep=""))
}
  
## --- End of Tests ---

