## ----setup, include=FALSE------------------------------------------------
# knitr::opts_chunk$set(cache=TRUE)
library(bioassayR) 
library(knitcitations)
cite_options(max.names=1)
RefManageR:::BibOptions(style="markdown",no.print.fields=c("doi"))
sapply(read.bibtex(file="bibtex.bib"),record_as_cited)

## ----eval=FALSE----------------------------------------------------------
## source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script
## biocLite("bioassayR") # Installs the package

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
library(bioassayR) # Loads the package

## ----eval=FALSE, tidy=FALSE----------------------------------------------
## library(help="bioassayR") # Lists all functions and classes
## vignette("bioassayR") # Opens this manual from R

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
library(bioassayR)
myDatabaseFilename <- tempfile() 
mydb <- newBioassayDB(myDatabaseFilename, indexed=F)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
addDataSource(mydb, description="PubChem BioAssay", version="unknown")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
data(samplebioassay)
samplebioassay[1:10,] # print the first 10 scores

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
myAssay <- new("bioassay",aid="1000", source_id="PubChem BioAssay",
    assay_type="confirmatory", organism="unknown", scoring="activity rank", 
    targets="116516899", target_types="protein", scores=samplebioassay)
myAssay

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
loadBioassay(mydb, myAssay)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
loadIdMapping(mydb, target="116516899", category="UniProt", identifier="Q8DR51")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
tempAssay <- getAssay(mydb, "1000") # get assay from database
dropBioassay(mydb, "1000") # delete assay from database
organism(tempAssay) <- "Streptococcus pneumonia" # update organism
loadBioassay(mydb, tempAssay)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
addBioassayIndex(mydb)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
mydb

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
activeTargets(mydb, 16749979)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
translateTargetId(mydb, target="116516899", category="UniProt")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
disconnectBioassayDB(mydb)

## ----eval=TRUE, echo=FALSE-----------------------------------------------
# delete temporary database
unlink(myDatabaseFilename)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
library(bioassayR)
extdata_dir <- system.file("extdata", package="bioassayR")
assayDescriptionFile <- file.path(extdata_dir, "exampleAssay.xml")
activityScoresFile <- file.path(extdata_dir, "exampleScores.csv")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
myDatabaseFilename <- tempfile()
mydb <- newBioassayDB(myDatabaseFilename, indexed=F)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
addDataSource(mydb, description="PubChem BioAssay", version="unknown")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
myAssay <- parsePubChemBioassay("1000", activityScoresFile, assayDescriptionFile)
myAssay

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
loadBioassay(mydb, myAssay)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
addBioassayIndex(mydb)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
activeAgainst(mydb,"116516899")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
disconnectBioassayDB(mydb)

## ----eval=TRUE, echo=FALSE-----------------------------------------------
# delete temporary database
unlink(myDatabaseFilename)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
library(bioassayR)
extdata_dir <- system.file("extdata", package="bioassayR")
sampleDatabasePath <- file.path(extdata_dir, "sampleDatabase.sqlite")
pubChemDatabase <- connectBioassayDB(sampleDatabasePath)  

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
drugTargets <- activeTargets(pubChemDatabase, "2244")
drugTargets

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
# run translateTargetId on each target identifier
uniProtIds <- lapply(row.names(drugTargets), translateTargetId, database=pubChemDatabase, category="UniProt")

# if any targets had more than one UniProt ID, keep only the first one
uniProtIds <- sapply(uniProtIds, function(x) x[1])

## ----eval=FALSE, tidy=FALSE----------------------------------------------
## library(biomaRt)
## ensembl <- useEnsembl(biomart="ensembl",dataset="hsapiens_gene_ensembl")
## proteinDetails <- getBM(attributes=c("description","uniprot_swissprot","external_gene_name"), filters=c("uniprot_swissprot"), mart=ensembl, values=uniProtIds)
## proteinDetails <- proteinDetails[match(uniProtIds, proteinDetails$uniprot_swissprot),]

## ----eval=TRUE, echo=FALSE, message=FALSE--------------------------------
# cache results from previous code chunk
# NOTE: this must match the code in the previous code chunk but will be
#   hidden. Delete cacheFileName to rebuild the cache from web data.
cacheFileName <- "getBM.RData"
if(! file.exists(cacheFileName)){
    library(biomaRt)
    ensembl <- useEnsembl(biomart="ensembl",dataset="hsapiens_gene_ensembl")
    proteinDetails <- getBM(attributes=c("description","uniprot_swissprot","external_gene_name"), filters=c("uniprot_swissprot"), mart=ensembl, values=uniProtIds)
    proteinDetails <- proteinDetails[match(uniProtIds, proteinDetails$uniprot_swissprot),]
    save(list=c("proteinDetails"), file=cacheFileName)
}
load(cacheFileName)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
proteinDetails

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
drugTargets <- drugTargets[! is.na(proteinDetails[,1]),]
proteinDetails <- proteinDetails[!is.na(proteinDetails[,1]),]
cbind(proteinDetails, drugTargets)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
library(bioassayR)
extdata_dir <- system.file("extdata", package="bioassayR") 
sampleDatabasePath <- file.path(extdata_dir, "sampleDatabase.sqlite")
pubChemDatabase <- connectBioassayDB(sampleDatabasePath)  

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
activeCompounds <- activeAgainst(pubChemDatabase, "166897622")
activeCompounds[1:10,] # look at the first 10 compounds

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
selectiveCompounds <- selectiveAgainst(pubChemDatabase, "166897622", 
    maxCompounds = 10, minimumTargets = 1)
selectiveCompounds

## ----eval=FALSE, tidy=FALSE----------------------------------------------
## library(ChemmineR)
## structures <- getIds(as.numeric(row.names(selectiveCompounds)))

## ----eval=TRUE, echo=FALSE-----------------------------------------------
# cache results from previous code chunk
# NOTE: this must match the code in the previous code chunk but will be
#   hidden. Delete cacheFileName to rebuild the cache from web data.
library(ChemmineR)
cacheFileName <- "getids.RData"
if(! file.exists(cacheFileName)){
    structures <- getIds(as.numeric(row.names(selectiveCompounds)))
    save(list=c("structures"), file=cacheFileName)
}
load(cacheFileName)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
plot(structures[1:4], print=FALSE) # Plots structures to R graphics device

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
library(bioassayR)
extdata_dir <- system.file("extdata", package="bioassayR") 
sampleDatabasePath <- file.path(extdata_dir, "sampleDatabase.sqlite")
sampleDB <- connectBioassayDB(sampleDatabasePath)  

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
compoundsOfInterest <- c("2244", "2662", "3715")
selectedAssayData <- getBioassaySetByCids(sampleDB, compoundsOfInterest)
selectedAssayData

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
myActivityMatrix <- perTargetMatrix(selectedAssayData, inactives=TRUE, summarizeReplicates = "mode")
myActivityMatrix[1:15,] # print the first 15 rows

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
myAssayTargets <- assaySetTargets(selectedAssayData)
myAssayTargets[1:5] # print the first 5 targets

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
# get kClust protein cluster number for a single target
translateTargetId(database = sampleDB, target = "166897622", category = "kClust")

# get kClust protein cluster numbers for all targets in myAssayTargets
customMerge <- sapply(myAssayTargets, translateTargetId, database = sampleDB, category = "kClust")
customMerge[1:5]

mergedActivityMatrix <- perTargetMatrix(selectedAssayData, inactives=TRUE, assayTargets=customMerge)
mergedActivityMatrix[1:15,] # print the first 15 rows

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
# get number of rows and columns for unmerged matrix
dim(myActivityMatrix) 

# get number of rows and columns for merged matrix
dim(mergedActivityMatrix)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
binaryMatrix <- 1*(mergedActivityMatrix > 1)
binaryMatrix[1:15,] # print the first 15 rows

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
transposedMatrix <- t(binaryMatrix)
distanceMatrix <- dist(transposedMatrix)
clusterResults <- hclust(distanceMatrix, method="average")
plot(clusterResults)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
library(ChemmineR)
fpset <- bioactivityFingerprint(selectedAssayData)
fpset

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
fpSim(fpset[1], fpset, method="Tanimoto") 

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
simMA <- sapply(cid(fpset), function(x) fpSim(fpset[x], fpset, sorted=FALSE, method="Tanimoto"))
simMA

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
clusterResults <- hclust(as.dist(1-simMA), method="single")
plot(clusterResults)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
disconnectBioassayDB(sampleDB)

## ----eval=TRUE, tidy=FALSE, message=FALSE--------------------------------
library(cellHTS2)
library(bioassayR)

dataPath <- system.file("KcViab", package="cellHTS2")
x <- readPlateList("Platelist.txt", 
                   name="KcViab", 
                   path=dataPath)

x <- configure(x,
               descripFile="Description.txt", 
               confFile="Plateconf.txt", 
               logFile="Screenlog.txt", 
               path=dataPath)

xn <- normalizePlates(x, 
                      scale="multiplicative", 
                      log=FALSE, 
                      method="median", 
                      varianceAdjust="none")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
xsc <- scoreReplicates(xn, sign="-", method="zscore")
xsc <- summarizeReplicates(xsc, summary="mean")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
xsc <- annotate(xsc, geneIDFile="GeneIDs_Dm_HFA_1.1.txt", path=dataPath)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
y <- scores2calls(xsc, z0=1.5, lambda=2)
binaryCalls <- round(Data(y))

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
scoreDataFrame <- cbind(geneAnno(y), binaryCalls)
rawScores <- as.vector(Data(xsc))
rawScores <- rawScores[wellAnno(y) == "sample"]
scoreDataFrame <- scoreDataFrame[wellAnno(y) == "sample",]
activityTable <- cbind(cid=scoreDataFrame[,1], 
     activity=scoreDataFrame[,2], score=rawScores)
activityTable <- as.data.frame(activityTable)
activityTable[1:10,]

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
myDatabaseFilename <- tempfile() 
mydb <- newBioassayDB(myDatabaseFilename, indexed=F)
addDataSource(mydb, description="other", version="unknown")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
myAssay <- new("bioassay",aid="1", source_id="other",
     assay_type="confirmatory", organism="unknown", scoring="activity rank", 
     targets="2224444", target_types="protein", scores=activityTable)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
loadBioassay(mydb, myAssay)
mydb

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
disconnectBioassayDB(mydb)

## ----eval=TRUE, echo=FALSE-----------------------------------------------
# delete temporary database
unlink(myDatabaseFilename)

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
library(bioassayR)
extdata_dir <- system.file("extdata", package="bioassayR")
sampleDatabasePath <- file.path(extdata_dir, "sampleDatabase.sqlite")
pubChemDatabase <- connectBioassayDB(sampleDatabasePath)  

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
queryBioassayDB(pubChemDatabase, "SELECT * FROM sqlite_master WHERE type='table'")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
queryBioassayDB(pubChemDatabase, "SELECT DISTINCT(aid) FROM activity WHERE cid = '2244' LIMIT 10")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
queryBioassayDB(pubChemDatabase, "SELECT * FROM activity WHERE aid = '393818'")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
queryBioassayDB(pubChemDatabase, "SELECT * FROM activity NATURAL JOIN assays NATURAL JOIN targets WHERE cid = '2244' LIMIT 10")

## ----eval=TRUE, tidy=FALSE-----------------------------------------------
disconnectBioassayDB(pubChemDatabase)

## ----sessionInfo, results='asis'-----------------------------------------
 sessionInfo()

## ----biblio, echo=FALSE, results='asis'----------------------------------
    #hack to get rid of latex code returned by certain doi sites (e.g. crosscite.org)
	fix = function(t)  gsub("\\$\\\\(l|r)brace\\$", "", t)
	suppressWarnings({
		sink(tempfile())
		b<<-bibliography()
		sink(NULL)
	})

	for(i in 1:length(b))
		b[i]$title = fix(b[i]$title)
#	write.bibtex(file="references.bib")
	b


