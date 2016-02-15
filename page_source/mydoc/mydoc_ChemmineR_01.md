---
title: ChemmineR - Cheminformatics Toolkit for R
keywords: 
last_updated: Sat Feb 13 19:36:03 2016
---
Authors: Kevin Horan, Yiqun Cao, Tyler Backman, [Thomas Girke](mailto:thomas.girke@ucr.edu)

Last update: 13 February, 2016 

Alternative formats of this tutorial:
[`.Rmd HTML`](http://girke.bioinformatics.ucr.edu/manuals/vignettes/ChemmineR/ChemmineR.html), 
[`.Rmd Source`](http://girke.bioinformatics.ucr.edu/manuals/vignettes/ChemmineR/ChemmineR.Rmd), 
[`.R Source`](http://girke.bioinformatics.ucr.edu/manuals/vignettes/ChemmineR/ChemmineR.R), 
[`PDF Slides`](http://faculty.ucr.edu/~tgirke/HTML_Presentations/Manuals/Workshop_Dec_5_8_2014/Rcheminfo/Cheminfo.pdf)

Note: the most recent version of this tutorial can be found <a href="https://htmlpreview.github.io/?https://github.com/girke-lab/ChemmineR/blob/master/vignettes/ChemmineR.html">here</a> and a short overview slide show [here](http://faculty.ucr.edu/~tgirke/HTML_Presentations/Manuals/Workshop_Dec_5_8_2014/Rcheminfo/Cheminfo.pdf).



## Introduction

`ChemmineR` is a cheminformatics package for analyzing
drug-like small molecule data in R. Its latest version contains
functions for efficient processing of large numbers of small molecules,
physicochemical/structural property predictions, structural similarity
searching, classification and clustering of compound libraries with a
wide spectrum of algorithms.

![Figure: `ChemmineR` environment with its add-on packages and selected functionalities](ChemmineR_images/overview.png)

In addition, `ChemmineR` offers visualization functions
for compound clustering results and chemical structures. The integration
of chemoinformatic tools with the R programming environment has many
advantages, such as easy access to a wide spectrum of statistical
methods, machine learning algorithms and graphic utilities. The first
version of this package was published in Cao et al. [-@Cao_2008]. Since then many additional
utilities and add-on packages have been added to the environment (Figure 2) and
many more are under development for future releases [@Backman_2011; @Wang_2013].



__Recently Added Features__

-   Improved SMILES support via new `SMIset` object class
    and SMILES import/export functions

-   Integration of a subset of OpenBabel functionalities via new
    `ChemmineOB` add-on package [@Cao_2008]

-   Streaming functionality for processing millions of molecules on a
    laptop

-   Mismatch tolerant maximum common substructure (MCS) search algorithm

-   Fast and memory efficient fingerprint search support using atom pair
    or PubChem fingerprints


