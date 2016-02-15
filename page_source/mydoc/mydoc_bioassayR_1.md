---
title: bioassayR - Introduction and Examples 
keywords: 
last_updated: Sat Feb 13 20:05:18 2016
---
Authors: Tyler Backman, Thomas Girke

Last update: 13 February, 2016 

Alternative formats of this tutorial:
[`.Rmd HTML`](http://girke.bioinformatics.ucr.edu/manuals/vignettes/bioassayR/bioassayR.html), 
[`.Rmd Source`](http://girke.bioinformatics.ucr.edu/manuals/vignettes/bioassayR/bioassayR.Rmd), 
[`.R Source`](http://girke.bioinformatics.ucr.edu/manuals/vignettes/bioassayR/bioassayR.R), 
[`PDF Slides`](http://biocluster.ucr.edu/~tbackman/chem_workshop/ht_screen.pdf)


## Introduction

*bioassayR* is a tool for cross-target analysis of biological screening data. It allows users to store, organize, and
systematically analyze data from a large number of small molecule bioactivity experiments of heterogenous design. 
Users have the option of supplying their own bioactivity
data for analysis, or downloading a database from the authors website (<http://chemmine.ucr.edu/bioassayr>) pre-loaded with bioactivity data sourced from NCBI PubChem BioAssay (Backman, et al., 2011; Wang, et al., 2012).
The pre-loaded database contains the results of thousands of bioassay experiments, where small molecules were screened against a defined biological target.
*bioassayR* allows users to leverage these data as a reference to 
identify small molecules active against a protein or organism of interest, identify target selective compounds that may be useful as drugs or chemical genomics probes, and identify and compare the activity profiles of small molecules.

The design of bioassayR is based around four distinct objects, each which
is optimized for investigating bioactivity data in different ways.
The *bioassay* object stores activity data for a single assay, and also acts as
a gateway for importing new activity data, and editing the data for a single assay.
The *bioassayDB* object uses a SQL database to store and query thousands of
assays, in a time-efficient manner. Often users will wish to further investigate
a set of compounds or assays identified with a *bioassayDB* query by pulling
them out into a *bioassaySet* object. The *bioassaySet*
object stores activity data as a compound vs assay matrix, and can be created 
from a list of assay ids or compounds of interest. Lastly, the *perTargetMatrix* 
is a matrix of compounds vs targets, where replicates (assays hitting the same
target) from a *bioassaySet* object are summarized into a single value. 
This internally uses a sparse matrix
to save system memory, while allowing the user to leverage R language matrix features to
further investigate these data.

