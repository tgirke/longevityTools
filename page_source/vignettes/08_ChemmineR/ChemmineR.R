## ----style, echo = FALSE, results = 'asis'-------------------------------
BiocStyle::markdown()
options(width=100, max.print=1000)
knitr::opts_chunk$set(
    eval=as.logical(Sys.getenv("KNITR_EVAL", "TRUE")),
    cache=as.logical(Sys.getenv("KNITR_CACHE", "TRUE")))

## ----setup, echo=FALSE, messages=FALSE, warnings=FALSE-------------------
suppressPackageStartupMessages({
    library(ChemmineR)
    library(ChemmineOB)
    library(fmcsR)
    library(ggplot2)
})

## ----eval=FALSE----------------------------------------------------------
##  source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script.
##  biocLite("ChemmineR") # Installs the package.
## 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 library("ChemmineR") # Loads the package

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  library(help="ChemmineR") # Lists all functions and classes
##  vignette("ChemmineR") # Opens this PDF manual from R

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 data(sdfsample) 
 sdfset <- sdfsample
 sdfset # Returns summary of SDFset 
 sdfset[1:4] # Subsetting of object

 sdfset[[1]] # Returns summarized content of one SDF

 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  view(sdfset[1:4]) # Returns summarized content of many SDFs, not printed here
##  as(sdfset[1:4], "list") # Returns complete content of many SDFs, not printed here
## 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  sdfset <- read.SDFset("http://faculty.ucr.edu/ tgirke/Documents/R_BioCond/Samples/sdfsample.sdf")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  header(sdfset[1:4]) # Not printed here

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 header(sdfset[[1]])

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  atomblock(sdfset[1:4]) # Not printed here

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
atomblock(sdfset[[1]])[1:4,] 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
## bondblock(sdfset[1:4]) # Not printed here

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 bondblock(sdfset[[1]])[1:4,] 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  datablock(sdfset[1:4]) # Not printed here

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 datablock(sdfset[[1]])[1:4] 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 cid(sdfset)[1:4] # Returns IDs from SDFset object
 sdfid(sdfset)[1:4] # Returns IDs from SD file header block
 unique_ids <- makeUnique(sdfid(sdfset))
 cid(sdfset) <- unique_ids 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 blockmatrix <- datablock2ma(datablocklist=datablock(sdfset)) # Converts data block to matrix 
 numchar <- splitNumChar(blockmatrix=blockmatrix) # Splits to numeric and character matrix 
 numchar[[1]][1:2,1:2] # Slice of numeric matrix 
 numchar[[2]][1:2,10:11] # Slice of character matrix 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 propma <- data.frame(MF=MF(sdfset), MW=MW(sdfset), atomcountMA(sdfset))
 propma[1:4, ] 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 datablock(sdfset) <- propma 
 datablock(sdfset[1]) 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  grepSDFset("650001", sdfset, field="datablock", mode="subset") # Returns summary view of matches. Not printed here.

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 grepSDFset("650001", sdfset, field="datablock", mode="index") 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  write.SDF(sdfset[1:4], file="sub.sdf", sig=TRUE)

## ----plotstruct, eval=TRUE, tidy=FALSE-----------------------------------
 plot(sdfset[1:4], print=FALSE) # Plots structures to R graphics device 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  sdf.visualize(sdfset[1:4]) # Compound viewing in web browser

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  apset <- sdf2ap(sdfset) # Generate atom pair descriptor database for searching

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 data(apset) # Load sample apset data provided by library. 
 cmp.search(apset, apset[1], type=3, cutoff = 0.3, quiet=TRUE) # Search apset database with single compound. 

 cmp.cluster(db=apset, cutoff = c(0.65, 0.5), quiet=TRUE)[1:4,] # Binning clustering using variable similarity cutoffs. 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
## convertFormatFile("SML","SDF","mycompound.sml","mycompound.sdf")
## sdfset=read.SDFset("mycompound.sdf")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
propOB(sdfset[1])

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
fingerprintOB(sdfset,"FP2")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
#count rotable bonds
smartsSearchOB(sdfset[1:5],"[!$(*#*)&!D1]-!@[!$(*#*)&!D1]",uniqueMatches=FALSE)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
exactMassOB(sdfset[1:5])

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
sdfset2 = regenerateCoords(sdfset[1:5])

plot(sdfset[1], regenCoords=TRUE,print=FALSE)

## ----eval=FALSE, tidy=FALSE----------------------------------------------
## sdf3D = generate3DCoords(sdfset[1])

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
canonicalSdf= canonicalize(sdfset[1])

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
mapping = canonicalNumbering(sdfset[1])

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  sdfset <- read.SDFset("http://faculty.ucr.edu/ tgirke/Documents/R_BioCond/Samples/sdfsample.sdf")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 data(sdfsample) # Loads the same SDFset provided by the library 
 sdfset <- sdfsample
 valid <- validSDF(sdfset) # Identifies invalid SDFs in SDFset objects 
 sdfset <- sdfset[valid] # Removes invalid SDFs, if there are any 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  sdfstr <- read.SDFstr("http://faculty.ucr.edu/ tgirke/Documents/R_BioCond/Samples/sdfsample.sdf")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 sdfstr <- as(sdfset, "SDFstr") 
 sdfstr
 as(sdfstr, "SDFset") 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  data(smisample); smiset <- smisample
##  write.SMI(smiset[1:4], file="sub.smi")
##  smiset <- read.SMIset("sub.smi")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 data(smisample) # Loads the same SMIset provided by the library 
 smiset <- smisample
 smiset 
 view(smiset[1:2]) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 cid(smiset[1:4]) 
 smi <- as.character(smiset[1:2])

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 as(smi, "SMIset") 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  write.SDF(sdfset[1:4], file="sub.sdf")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  write.SDF(sdfset[1:4], file="sub.sdf", sig=TRUE, cid=TRUE, db=NULL)

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  props <- data.frame(MF=MF(sdfset), MW=MW(sdfset), atomcountMA(sdfset))
##  datablock(sdfset) <- props
##  write.SDF(sdfset[1:4], file="sub.sdf", sig=TRUE, cid=TRUE)

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  sdf2str(sdf=sdfset[[1]], sig=TRUE, cid=TRUE) # Uses default components
##  sdf2str(sdf=sdfset[[1]], head=letters[1:4], db=NULL) # Uses custom components for header and data block

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  write.SDF(sdfset[1:4], file="sub.sdf", sig=TRUE, cid=TRUE, db=NULL)
##  write.SDF(sdfstr[1:4], file="sub.sdf")
##  cat(unlist(as(sdfstr[1:4], "list")), file="sub.sdf", sep="")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  data(smisample); smiset <- smisample # Sample data set
## 
##  write.SMI(smiset[1:4], file="sub.smi", cid=TRUE) write.SMI(smiset[1:4], file="sub.smi", cid=FALSE)

## ----sdf2smiles, eval=FALSE, tidy=FALSE----------------------------------
##  data(sdfsample);
##  sdfset <- sdfsample[1]
##  smiles <- sdf2smiles(sdfset)
##  smiles

## ----smiles2sdf, eval=FALSE, tidy=FALSE----------------------------------
##  sdf <- smiles2sdf("CC(=O)OC1=CC=CC=C1C(=O)O")
##  view(sdf)

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  sdfStr <- convertFormat("SMI","SDF","CC(=O)OC1=CC=CC=C1C(=O)O_name")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  convertFormatFile("SMI","SDF","test.smiles","test.sdf")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  write.SDF(sdfset, "test.sdf")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  sdfstr <- read.SDFstr("test.sdf")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  write.SDFsplit(x=sdfstr, filetag="myfile", nmol=10) # 'nmol' defines the number of molecules to write to each file

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  write.SDFsplit(x=sdfset, filetag="myfile", nmol=10)

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  write.SDF(sdfset, "test.sdf")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  desc <- function(sdfset)
##  cbind(SDFID=sdfid(sdfset),
## 	# datablock2ma(datablocklist=datablock(sdfset)),
## 	 MW=MW(sdfset),
## 	groups(sdfset), APFP=desc2fp(x=sdf2ap(sdfset), descnames=1024,
## 	type="character"), AP=sdf2ap(sdfset, type="character"), rings(sdfset,
## 	type="count", upper=6, arom=TRUE) )

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  sdfStream(input="test.sdf", output="matrix.xls", fct=desc, Nlines=1000) # 'Nlines': number of lines to read from input SD File at a time

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  sdfStream(input="test.sdf", output="matrix2.xls", append=FALSE, fct=desc, Nlines=1000, startline=950)

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  indexDF <- read.delim("matrix.xls", row.names=1)[,1:4]
##  indexDFsub <- indexDF[indexDF$MW < 400, ] # Selects molecules with MW < 400
##  sdfset <- read.SDFindex(file="test.sdf", index=indexDFsub, type="SDFset") # Collects results in 'SDFset' container

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  read.SDFindex(file="test.sdf", index=indexDFsub, type="file",
##  outfile="sub.sdf")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  apset <- read.AP(x="matrix.xls", type="ap", colid="AP")
##  apfp <- read.AP(x="matrix.xls", type="fp", colid="APFP")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  apset <- read.AP(x=sdf2ap(sdfset[1:20], type="character"), type="ap")
##  fpchar <- desc2fp(sdf2ap(sdfset[1:20]), descnames=1024, type="character")
##  fpset <- as(fpchar, "FPset")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 data(sdfsample)

 #create and initialize a new SQLite database 
 conn <- initDb("test.db")

 # load data and compute 3 features: molecular weight, with the MW function, 
 # and counts for RINGS and AROMATIC, as computed by rings, which 
 # returns a data frame itself. 
 ids<-loadSdf(conn,sdfsample, function(sdfset) 
					 data.frame(rings(sdfset,type="count",upper=6, arom=TRUE),propOB(sdfset)) ) 

 #list features in the database:
 print(listFeatures(conn))

## ----eval=FALSE, tidy=FALSE----------------------------------------------
## setPriorities(conn,forestSizePriorities)

## ------------------------------------------------------------------------
results = findCompounds(conn,"mw",c("mw < 300"))
message("found ",length(results))

## ------------------------------------------------------------------------
results = findCompounds(conn,c("mw","aromatic"),c("mw < 300","aromatic >= 2"))
message("found ",length(results))

## ------------------------------------------------------------------------
results = findCompounds(conn,"formula",c("formula like '%C21%'"))
message("found ",length(results))

## ------------------------------------------------------------------------
allIds = getAllCompoundIds(conn)
message("found ",length(allIds))

## ------------------------------------------------------------------------

#get the names of the compounds:
names = getCompoundNames(conn,results)

#if the name order is important set keepOrder=TRUE 
#It will take a little longer though
names = getCompoundNames(conn,results,keepOrder=TRUE) 


# get the whole set of compounds
compounds = getCompounds(conn,results)
#in order:
compounds = getCompounds(conn,results,keepOrder=TRUE)
#write results directly to a file:
compounds = getCompounds(conn,results,filename=file.path(tempdir(),"results.sdf"))

## ------------------------------------------------------------------------
getCompoundFeatures(conn,results[1:5],c("mw","logp","formula"))

#write results directly to a CSV file (reduces memory usage):
getCompoundFeatures(conn,results[1:5],c("mw","logp","formula"),filename="features.csv")

#maintain input order in output:
print(results[1:5])
getCompoundFeatures(conn,results[1:5],c("mw","logp","formula"),keepOrder=TRUE)

## ----eval=FALSE, tidy=FALSE----------------------------------------------
## 
##  view(sdfset[1:4]) # Summary view of several molecules
## 
##  length(sdfset) # Returns number of molecules
##  sdfset[[1]] # Returns single molecule from SDFset as SDF object
## 
##  sdfset[[1]][[2]] # Returns atom block from first compound as matrix
## 
##  sdfset[[1]][[2]][1:4,]
##  c(sdfset[1:4], sdfset[5:8]) # Concatenation of several SDFsets
## 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  grepSDFset("650001", sdfset, field="datablock", mode="subset") # To return index, set mode="index")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  sdfid(sdfset[1:4]) # Retrieves CMP IDs from Molecule Name field in header block.
##  cid(sdfset[1:4]) # Retrieves CMP IDs from ID slot in SDFset.
##  unique_ids <- makeUnique(sdfid(sdfset)) # Creates unique IDs by appending a counter to duplicates.
##  cid(sdfset) <- unique_ids # Assigns uniquified IDs to ID slot

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  view(sdfset[c("650001", "650012")])
##  view(sdfset[4:1])
##  mylog <- cid(sdfset)
##  view(sdfset[mylog])

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  atomblock(sdf); sdf[[2]];
##  sdf[["atomblock"]] # All three methods return the same component
## 
##  header(sdfset[1:4])
##  atomblock(sdfset[1:4])
##  bondblock(sdfset[1:4])
##  datablock(sdfset[1:4])
##  header(sdfset[[1]])
##  atomblock(sdfset[[1]])
##  bondblock(sdfset[[1]])
##  datablock(sdfset[[1]])

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  sdfset[[1]][[2]][1,1] <- 999
##  atomblock(sdfset)[1] <- atomblock(sdfset)[2]
##  datablock(sdfset)[1] <- datablock(sdfset)[2]

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  datablock(sdfset) <- as.matrix(iris[1:100,])
##  view(sdfset[1:4])

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  as(sdfstr[1:2], "list") as(sdfstr[[1]], "SDF")
##  as(sdfstr[1:2], "SDFset")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  sdfcomplist <- as(sdf, "list") sdfcomplist <-
##  as(sdfset[1:4], "list"); as(sdfcomplist[[1]], "SDF") sdflist <-
##  as(sdfset[1:4], "SDF"); as(sdflist, "SDFset") as(sdfset[[1]], "SDFstr")
##  as(sdfset[[1]], "SDFset")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  as(sdfset[1:4], "SDF") as(sdfset[1:4], "list") as(sdfset[1:4], "SDFstr")

## ----boxplot, eval=TRUE, tidy=FALSE--------------------------------------
 propma <- atomcountMA(sdfset, addH=FALSE) 
 boxplot(propma, col="blue", main="Atom Frequency") 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  boxplot(rowSums(propma), main="All Atom Frequency")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 data(atomprop)
 atomprop[1:4,] 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 MW(sdfset[1:4], addH=FALSE)
 MF(sdfset[1:4], addH=FALSE) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 groups(sdfset[1:4], groups="fctgroup", type="countMA") 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 propma <- data.frame(MF=MF(sdfset, addH=FALSE), MW=MW(sdfset, addH=FALSE),
							 Ncharges=sapply(bonds(sdfset, type="charge"), length),
							 atomcountMA(sdfset, addH=FALSE), 
							 groups(sdfset, type="countMA"), 
							 rings(sdfset, upper=6, type="count", arom=TRUE))
 propma[1:4,] 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  datablock(sdfset) <- propma # Works with all SDF components
##  datablock(sdfset)[1:4]
##  test <- apply(propma[1:4,], 1, function(x)
##  data.frame(col=colnames(propma), value=x))

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  datablocktag(sdfset, tag="PUBCHEM_NIST_INCHI")
##  datablocktag(sdfset,
##  tag="PUBCHEM_OPENEYE_CAN_SMILES")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  blockmatrix <- datablock2ma(datablocklist=datablock(sdfset)) # Converts data block to matrix
##  numchar <- splitNumChar(blockmatrix=blockmatrix) # Splits matrix to numeric matrix and character matrix
##  numchar[[1]][1:4,]; numchar[[2]][1:4,]
##  # Splits matrix to numeric matrix and character matrix

## ----contable, eval=FALSE, fig.keep='none', tidy=FALSE-------------------
##  conMA(sdfset[1:2],
##  exclude=c("H")) # Create bond matrix for first two molecules in sdfset
## 
##  conMA(sdfset[[1]], exclude=c("H")) # Return bond matrix for first molecule
##  plot(sdfset[1], atomnum = TRUE, noHbonds=FALSE , no_print_atoms = "", atomcex=0.8) # Plot its structure with atom numbering
##  rowSums(conMA(sdfset[[1]], exclude=c("H"))) # Return number of non-H bonds for each atom

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 bonds(sdfset[[1]], type="bonds")[1:4,]
 bonds(sdfset[1:2], type="charge")
 bonds(sdfset[1:2], type="addNH") 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 ringatoms <- rings(sdfset[1], upper=Inf, type="all", arom=FALSE, inner=FALSE)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 atomindex <- as.numeric(gsub(".*_", "", unique(unlist(ringatoms))))
 plot(sdfset[1], print=FALSE, colbonds=atomindex) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 plot(sdfset[1], print=FALSE, atomnum=TRUE, no_print_atoms="H") 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 rings(sdfset[1], upper=Inf, type="all", arom=TRUE, inner=FALSE) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 rings(sdfset[1], upper=6, type="arom", arom=TRUE, inner=FALSE) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 rings(sdfset[1:4], upper=Inf, type="count", arom=TRUE, inner=TRUE) 

## ----plotstruct2, eval=TRUE, tidy=FALSE----------------------------------
 data(sdfsample)
 sdfset <- sdfsample
 plot(sdfset[1:4], regenCoords=TRUE,print=FALSE) # 'print=TRUE' returns SDF summaries

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  plot(sdfset[1:4], griddim=c(2,2), print_cid=letters[1:4], print=FALSE,
## 		noHbonds=FALSE)

## ----plotstruct3, eval=TRUE, tidy=FALSE----------------------------------
 plot(sdfset["CMP1"], atomnum = TRUE, noHbonds=F , no_print_atoms = "",
	  	atomcex=0.8, sub=paste("MW:", MW(sdfsample["CMP1"])), print=FALSE) 

## ----plotstruct4, eval=TRUE, tidy=FALSE----------------------------------
 plot(sdfset[1], print=FALSE, colbonds=c(22,26,25,3,28,27,2,23,21,18,8,19,20,24)) 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  sdf.visualize(sdfset[1:4])

## ----plotmcs, eval=TRUE, tidy=FALSE--------------------------------------
 library(fmcsR)
 data(fmcstest) # Loads test sdfset object 
 test <- fmcs(fmcstest[1], fmcstest[2], au=2, bu=1) # Searches for MCS with mismatches 
 plotMCS(test) # Plots both query compounds with MCS in color 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 ap <- sdf2ap(sdfset[[1]]) # For single compound
 ap 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  apset <- sdf2ap(sdfset)
##  # For many compounds.

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
view(apset[1:4]) 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  cid(apset[1:4]) # Compound IDs
##  ap(apset[1:4]) # Atom pair
##  descriptors
##  db.explain(apset[1]) # Return atom pairs in human readable format

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  apset2descdb(apset) # Returns old list-style AP database
##  tmp <- as(apset, "list") # Returns list
##  as(tmp, "APset") # Converts list back to APset

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  save(sdfset, file = "sdfset.rda", compress = TRUE)
##  load("sdfset.rda") save(apset, file = "apset.rda", compress = TRUE)
##  load("apset.rda")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 cmp.similarity(apset[1],
 apset[2])
 cmp.similarity(apset[1], apset[1]) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 cmp.search(apset,
 apset["650065"], type=3, cutoff = 0.3, quiet=TRUE) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 cmp.search(apset, apset["650065"], type=1, cutoff = 0.3, quiet=TRUE)
 cmp.search(apset, apset["650065"], type=2, cutoff = 0.3, quiet=TRUE) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 showClass("FPset") 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 data(apset) 
 fpset <- desc2fp(apset)
 view(fpset[1:2]) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 fpset[1:4] # behaves like a list 
 fpset[[1]] # returns FP object 
 length(fpset) # number of compounds ENDCOMMENT
 cid(fpset) # returns compound ids 
 fpset[10] <- 0 # replacement of 10th fingerprint to all zeros 
 cid(fpset) <- 1:length(fpset) # replaces compound ids 
 c(fpset[1:4], fpset[11:14]) # concatenation of several FPset objects 
 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 fpma <- as.matrix(fpset) # coerces FPset to matrix 
 as(fpma, "FPset") 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 fpchar <- as.character(fpset) # coerces FPset to character strings 
 as(fpchar, "FPset") # construction of FPset class from character vector

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 fpSim(fpset[1], fpset, method="Tanimoto", cutoff=0.4, top=4) 

## ----eval=TRUE,tidy=FALSE------------------------------------------------
 fold(fpset) # fold each FP once
 fold(fpset, count=2) #fold each FP twice
 fold(fpset, bits=128) #fold each FP down to 128 bits
 fold(fpset[[1]])  # fold an individual FP

 fptype(fpset) # get type of FPs
 numBits(fpset) # get the number of bits of each FP
 foldCount(fold(fpset)) # the number of times an FP or FPset has been folded

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  data(sdfsample)
##  sdfset <- sdfsample[1:10]
##  apset <- sdf2ap(sdfset)

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  fpset <- desc2fp(apset, descnames=1024, type="FPset")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  fpset1024 <- names(rev(sort(table(unlist(as(apset, "list")))))[1:1024])
##  fpset <- desc2fp(apset, descnames=fpset1024, type="FPset")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  fpchar <- desc2fp(x=apset,
##  descnames=1024, type="character") fpchar <- as.character(fpset)

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  fpma <- as.matrix(fpset)
##  fpset <- as(fpma, "FPset")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  fpSim(fpset[1], fpset, method="Tanimoto")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  fpSim(fpset[1], fpset, method="Tversky", cutoff=0.4, top=4, alpha=0.5, beta=1)

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  myfct <- function(a, b, c, d) c/(a+b+c+d)
##  fpSim(fpset[1], fpset, method=myfct)

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  simMAap <- sapply(cid(apfpset), function(x) fpSim(x=apfpset[x], apfpset, sorted=FALSE))
##  hc <- hclust(as.dist(1-simMAap), method="single")
##  plot(as.dendrogram(hc), edgePar=list(col=4, lwd=2), horiz=TRUE)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
    params <- genParameters(fpset)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
	fpSim(fpset[[1]], fpset, top=10, parameters=params)	

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
	fpSim(fpset[[1]], fpset, cutoff=0.04, scoreType="evalue", parameters=params)	

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 cid(sdfset) <- sdfid(sdfset)
 fpset <- fp2bit(sdfset, type=1) 
 fpset <- fp2bit(sdfset, type=2) 
 fpset <- fp2bit(sdfset, type=3) 
 fpset 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 fpSim(fpset[1], fpset[2]) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 fpSim(fpset["650065"], fpset, method="Tanimoto", cutoff=0.6, top=6) 

## ----search_result, eval=TRUE, tidy=FALSE--------------------------------
 cid(sdfset) <-
 cid(apset) # Assure compound name consistency among objects. 

 plot(sdfset[names(cmp.search(apset, apset["650065"], type=2, cutoff=4, quiet=TRUE))], print=FALSE) 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  similarities <- cmp.search(apset, apset[1], type=3, cutoff = 10)
##  sdf.visualize(sdfset[similarities[,1]])

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 cmp.duplicated(apset, type=1)[1:4] # Returns AP duplicates as logical vector 
 cmp.duplicated(apset, type=2)[1:4,] # Returns AP duplicates as data frame 

## ----duplicates, eval=TRUE, tidy=FALSE-----------------------------------
 plot(sdfset[c("650059","650060", "650065", "650066")], print=FALSE) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 apdups <- cmp.duplicated(apset, type=1)
 sdfset[which(!apdups)]; apset[which(!apdups)] 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 count <- table(datablocktag(sdfset,
 tag="PUBCHEM_NIST_INCHI"))
 count <- table(datablocktag(sdfset, tag="PUBCHEM_OPENEYE_CAN_SMILES")) 
 count <- table(datablocktag(sdfset, tag="PUBCHEM_MOLECULAR_FORMULA")) 
 count[1:4] 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 clusters <- cmp.cluster(db=apset, cutoff = c(0.7, 0.8, 0.9), quiet = TRUE)
 clusters[1:12,] 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 fpset <- desc2fp(apset)
 clusters2 <- cmp.cluster(fpset, cutoff=c(0.5, 0.7, 0.9), method="Tanimoto", quiet=TRUE)
 clusters2[1:12,] 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 clusters3 <- cmp.cluster(fpset, cutoff=c(0.5, 0.7, 0.9), 
								  method="Tversky", alpha=0.3, beta=0.7, quiet=TRUE) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 cluster.sizestat(clusters, cluster.result=1)
 cluster.sizestat(clusters, cluster.result=2)
 cluster.sizestat(clusters, cluster.result=3) 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  clusters <- cmp.cluster(db=apset, cutoff = c(0.65, 0.5, 0.3),
##  save.distances="distmat.rda") # Saves distance matrix to file "distmat.rda" in current working directory.
##  load("distmat.rda") # Loads distance matrix.
## 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 data(apset) 
 fpset <- desc2fp(apset) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 jarvisPatrick(nearestNeighbors(apset,numNbrs=6), k=5, mode="a1a2b")
 #Using "APset" 

 jarvisPatrick(nearestNeighbors(fpset,numNbrs=6), k=5, mode="a1a2b")
 #Using "FPset" 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 cl<-jarvisPatrick(nearestNeighbors(fpset,cutoff=0.6,
 method="Tanimoto"), k=2 ,mode="b")
 byCluster(cl) 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 nnm <- nearestNeighbors(fpset,numNbrs=6)
 nnm$names[1:4] 
 nnm$ids[1:4,] 
 nnm$similarities[1:4,] 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 nnm <- trimNeighbors(nnm,cutoff=0.4) 
 nnm$similarities[1:4,]

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 jarvisPatrick(nnm, k=5,mode="b") 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
 nn <- matrix(c(1,2,2,1),2,2,dimnames=list(c('one','two'))) 
 nn
 byCluster(jarvisPatrick(fromNNMatrix(nn),k=1)) 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  cluster.visualize(apset, clusters, size.cutoff=2, quiet = TRUE) # Color codes clusters with at least two members.
##  cluster.visualize(apset, clusters, quiet = TRUE) # Plots all items.

## ----mds_scatter, eval=TRUE, tidy=FALSE----------------------------------
 library(scatterplot3d) 
 coord <- cluster.visualize(apset, clusters, size.cutoff=1, dimensions=3, quiet=TRUE) 
 scatterplot3d(coord) 

## ----eval=FALSE, tidy=FALSE----------------------------------------------
##  library(rgl) rgl.open(); offset <- 50;
##  par3d(windowRect=c(offset, offset, 640+offset, 640+offset))
##  rm(offset)
##  rgl.clear()
##  rgl.viewpoint(theta=45, phi=30, fov=60, zoom=1)
##  spheres3d(coord[,1], coord[,2], coord[,3], radius=0.03, color=coord[,4], alpha=1, shininess=20)
##  aspect3d(1, 1, 1)
##  axes3d(col='black')
##  title3d("", "", "", "", "", col='black')
##  bg3d("white") # To save a snapshot of the graph, one can use the command rgl.snapshot("test.png").

## ----ap_dist_matrix, eval=TRUE, tidy=FALSE-------------------------------
 dummy <- cmp.cluster(db=apset, cutoff=0, save.distances="distmat.rda", quiet=TRUE) 
 load("distmat.rda") 

## ----hclust, eval=TRUE, tidy=FALSE---------------------------------------
 hc <- hclust(as.dist(distmat), method="single") 
 hc[["labels"]] <- cid(apset) # Assign correct item labels 
 plot(as.dendrogram(hc), edgePar=list(col=4, lwd=2), horiz=T) 

## ----fp_hclust, eval=FALSE, tidy=FALSE-----------------------------------
##  simMA <- sapply(cid(fpset), function(x) fpSim(fpset[x], fpset, sorted=FALSE))
##  hc <- hclust(as.dist(1-simMA), method="single")
##  plot(as.dendrogram(hc), edgePar=list(col=4, lwd=2), horiz=TRUE)

## ----heatmap, eval=TRUE, tidy=FALSE--------------------------------------
 library(gplots) 
 heatmap.2(1-distmat, Rowv=as.dendrogram(hc), Colv=as.dendrogram(hc), 
			  col=colorpanel(40, "darkblue", "yellow", "white"), 
			  density.info="none", trace="none") 

## ----getIds, eval=FALSE, tidy=FALSE--------------------------------------
##  compounds <- getIds(c(111,123))
##  compounds

## ----searchString, eval=FALSE, tidy=FALSE--------------------------------
##  compounds <- searchString("CC(=O)OC1=CC=CC=C1C(=O)O") compounds

## ----searchSim, eval=FALSE, tidy=FALSE-----------------------------------
##  data(sdfsample);
##  sdfset <- sdfsample[1]
##  compounds <- searchSim(sdfset)
##  compounds

## ----listCMTools, eval=FALSE, tidy=FALSE---------------------------------
## listCMTools()

## ----eval=TRUE, echo=FALSE-----------------------------------------------
# cache results from previous code chunk
# NOTE: this must match the code in the previous code chunk but will be
#   hidden. Delete cacheFileName to rebuild the cache from web data.
cacheFileName <- "listCMTools.RData"
if(! file.exists(cacheFileName)){
    toolList <- listCMTools()
    save(list=c("toolList"), file=cacheFileName)
}
load(cacheFileName)
toolList

## ----toolDetailsCMT, eval=FALSE, tidy=FALSE------------------------------
## toolDetails("Fingerprint Search")

## ----eval=TRUE, echo=FALSE-----------------------------------------------
# cache results from previous code chunk
# NOTE: this must match the code in the previous code chunk but will be
#   hidden. Delete cacheFileName to rebuild the cache from web data.
cacheFileName <- "toolDetails.RData"
if(! file.exists(cacheFileName)){
    .serverURL <- "http://chemmine.ucr.edu/ChemmineR/"
    library(RCurl)
    response <- postForm(paste(.serverURL, "toolDetails", sep = ""), tool_name = "Fingerprint Search")[[1]]
    save(list=c("response"), file=cacheFileName)
}
load(cacheFileName)
cat(response)

## ----launchCMTool, eval=FALSE, tidy=FALSE--------------------------------
## job1 <- launchCMTool("pubchemID2SDF", 2244)
## status(job1)
## result1 <- result(job1)

## ----fingerprintSearchCMT, eval=FALSE, tidy=FALSE------------------------
## job2 <- launchCMTool('Fingerprint Search', result1, 'Similarity Cutoff'=0.95, 'Max Compounds Returned'=200)
## result2 <- result(job2)
## job3 <- launchCMTool("pubchemID2SDF", result2)
## result3 <- result(job3)

## ----obDescriptorsCMT, eval=FALSE, tidy=FALSE----------------------------
## job4 <- launchCMTool("OpenBabel Descriptors", result3)
## result4 <- result(job4)
## result4[1:10,] # show first 10 lines of result

## ----eval=TRUE, echo=FALSE-----------------------------------------------
# cache results from previous code chunk
# NOTE: this must match the code in the previous code chunk but will be
#   hidden. Delete cacheFileName to rebuild the cache from web data.
cacheFileName <- "launchCMTool.RData"
if(! file.exists(cacheFileName)){
    job1 <- launchCMTool("pubchemID2SDF", 2244)
    status(job1)
    result1 <- result(job1)
    job2 <- launchCMTool('Fingerprint Search', result1, 'Similarity Cutoff'=0.95, 'Max Compounds Returned'=200)
    result2 <- result(job2)
    job3 <- launchCMTool("pubchemID2SDF", result2)
    result3 <- result(job3)
    job4 <- launchCMTool("OpenBabel Descriptors", result3)
    result4 <- result(job4)
    save(list=c("result4"), file=cacheFileName)
}
load(cacheFileName)
result4[1:10,]

## ----obDescriptorsWWW, eval=FALSE, tidy=FALSE----------------------------
## browseJob(job4)

## ----binningClusterWWW, eval=FALSE, tidy=FALSE---------------------------
## job5 <- launchCMTool("Binning Clustering", result3, 'Similarity Cutoff'=0.9)
## browseJob(job5)

## ----sessionInfo, results='asis'-----------------------------------------
 sessionInfo()

