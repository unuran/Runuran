
## Standalone test suite

## --- Global settings ------------------------------------------------------

## disable skip_on_cran()
Sys.setenv(NOT_CRAN="true")

## --- Setup ----------------------------------------------------------------

## Load package 'testthat' 
if(! require("testthat", quietly=TRUE)) {
  message("\nCannot run unit tests -- package 'testthat' is not available!\n")
  quit(save="no",runLast=FALSE)
}

## Load package 'rvgt' 
library("Runuran")

## Store R options
opt.save <- options()

## Print warnings immediately
options(warn=1)

## Path to unit test files
unittest.dir <- file.path("..","Runuran","tests","testthat")

## --- Run tests ------------------------------------------------------------

## Print header
cat(rep("=",45),"\n",
    " Run test suite in directory\n ",
    unittest.dir,"\n",
    rep("=",45),"\n", sep="")

## Run tests
## We use summary reporter and fail reporter
## results <- test_dir(unittest.dir, reporter=c("summary","fail"))
results <- test_dir(unittest.dir, reporter=c("progress","fail"))

## print remaining warnings
warnings()

## --- End ------------------------------------------------------------------

## Restore R options
options(opt.save)

## --------------------------------------------------------------------------
