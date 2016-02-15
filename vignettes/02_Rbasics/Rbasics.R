## ----style, echo = FALSE, results = 'asis'-------------------------------
BiocStyle::markdown()
options(width=100, max.print=1000)
knitr::opts_chunk$set(
    eval=as.logical(Sys.getenv("KNITR_EVAL", "TRUE")),
    cache=as.logical(Sys.getenv("KNITR_CACHE", "TRUE")))

## ----setup, echo=FALSE, messages=FALSE, warnings=FALSE-------------------
suppressPackageStartupMessages({
    library(limma) 
    library(ggplot2) }) 

## ----install_cran, eval=FALSE--------------------------------------------
## install.packages(c("pkg1", "pkg2"))
## install.packages("pkg.zip", repos=NULL)

## ----install_bioc, eval=FALSE--------------------------------------------
## source("http://www.bioconductor.org/biocLite.R")
## library(BiocInstaller)
## BiocVersion()
## biocLite()
## biocLite(c("pkg1", "pkg2"))

## ----closing_r, eval=FALSE-----------------------------------------------
## q()
## Save workspace image? [y/n/c]:

## ----r_assignment, eval=FALSE--------------------------------------------
## object <- ...

## ----r_ls, eval=FALSE----------------------------------------------------
## ls()

## ----r_dirshow, eval=FALSE-----------------------------------------------
## dir()

## ----r_dirpath, eval=FALSE-----------------------------------------------
## getwd()

## ----r_setwd, eval=FALSE-------------------------------------------------
## setwd("/home/user")

## ----r_syntax, eval=FALSE------------------------------------------------
## object <- function_name(arguments)
## object <- object[arguments]

## ----r_find_help, eval=FALSE---------------------------------------------
## ?function_name

## ----r_package_load, eval=FALSE------------------------------------------
## library("my_library")

## ----r_package_functions, eval=FALSE-------------------------------------
## library(help="my_library")

## ----r_load_vignette, eval=FALSE-----------------------------------------
## vignette("my_library")

## ----r_execute_script, eval=FALSE----------------------------------------
## source("my_script.R")

## ----sh_execute_script, eval=FALSE, engine="sh"--------------------------
## $ Rscript my_script.R
## $ R CMD BATCH my_script.R
## $ R --slave < my_script.R

## ----r_numeric_data, eval=TRUE-------------------------------------------

x <- c(1, 2, 3)
x
is.numeric(x)
as.character(x)

## ----r_character_data, eval=TRUE-----------------------------------------
x <- c("1", "2", "3")
x
is.character(x)
as.numeric(x)

## ----r_complex_data, eval=TRUE-------------------------------------------
c(1, "b", 3)

## ----r_logical_data, eval=TRUE-------------------------------------------
x <- 1:10 < 5
x  
!x
which(x) # Returns index for the 'TRUE' values in logical vector

## ----r_vector_object, eval=TRUE------------------------------------------
myVec <- 1:10; names(myVec) <- letters[1:10]  
myVec[1:5]
myVec[c(2,4,6,8)]
myVec[c("b", "d", "f")]

## ----r_factor_object, eval=TRUE------------------------------------------
factor(c("dog", "cat", "mouse", "dog", "dog", "cat"))

## ----r_matrix_object, eval=TRUE------------------------------------------
myMA <- matrix(1:30, 3, 10, byrow = TRUE) 
class(myMA)
myMA[1:2,]
myMA[1, , drop=FALSE]

## ----r_dataframe_object, eval=TRUE---------------------------------------
myDF <- data.frame(Col1=1:10, Col2=10:1) 
myDF[1:2, ]

## ----r_list_object, eval=TRUE--------------------------------------------
myL <- list(name="Fred", wife="Mary", no.children=3, child.ages=c(4,7,9)) 
myL
myL[[4]][1:2] 

## ----r_function_object, eval=FALSE---------------------------------------
## myfct <- function(arg1, arg2, ...) {
## 	function_body
## }

## ----r_subset_by_index, eval=TRUE----------------------------------------
myVec <- 1:26; names(myVec) <- LETTERS 
myVec[1:4]

## ----r_subset_by_logical, eval=TRUE--------------------------------------
myLog <- myVec > 10
myVec[myLog] 

## ----r_subset_by_names, eval=TRUE----------------------------------------
myVec[c("B", "K", "M")]

## ----r_subset_by_dollar, eval=TRUE---------------------------------------
iris$Species[1:8]

## ----plot_example, eval=TRUE---------------------------------------------
barplot(1:10, col="green")

## ----sessionInfo---------------------------------------------------------
sessionInfo()

