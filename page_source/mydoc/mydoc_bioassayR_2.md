---
title: Getting Started
keywords: 
last_updated: Sat Feb 13 20:05:18 2016
---

## Installation

The R software for running bioassayR can be downloaded from CRAN (<http://cran.at.r-project.org/>). The *bioassayR* package can be installed from R using the *bioLite* install command. 


{% highlight r %}
source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script
biocLite("bioassayR") # Installs the package
{% endhighlight %}

## Loading the Package and Documentation


{% highlight r %}
library(bioassayR) # Loads the package
{% endhighlight %}


{% highlight r %}
library(help="bioassayR") # Lists all functions and classes 
vignette("bioassayR") # Opens this manual from R
{% endhighlight %}

## Quick Tutorial

This example walks you through creating a new empty database, adding example small molecule bioactivity data, and performing queries on these data. If you are interested only in querying
a pre-built PubChem BioAssay database, skip to the later section titled "Prebuilt Database Example: Investigate Activity of a Known Drug."

This example includes real experimental data from an antibiotics discovery experiment. These data are a "confirmatory bioassay" where 57 small molecules were screened against the mevalonate kinase protein from the *Streptococcus pneumonia* (SP) bacteria. Mevalonate kinase inhibitors are one possible class of antibiotic drugs that may be effective against this infamous bacteria.
These data were published as assay identifier (aid) 1000 in the NCBI PubChem BioAssay database, by Dr. Thomas S. Leyh.

First, create a new database. For purposes of this manual a temporary file is used, but you can replace the *tempfile* function call with a filename of your choice if you wish to save the resulting database for later.


{% highlight r %}
library(bioassayR)
myDatabaseFilename <- tempfile() 
mydb <- newBioassayDB(myDatabaseFilename, indexed=F)
{% endhighlight %}

Next, specify the source and version of the data you plan to load. This is a required step, which makes it easier to track the origin of your data later. Feel free to use the current date for a version number, if your data isn't versioned.


{% highlight r %}
addDataSource(mydb, description="PubChem BioAssay", version="unknown")
{% endhighlight %}

After adding a data source, create or import a *data.frame* which contains the activity scores for each of the molecules in your assay. 
This *data.frame* must contain three columns which includes a cid (unique compound identifier) for each compound, a binary activity score (1=active, 0=inactive, NA=inconclusive), and a numeric activity score.
Consult the *bioassay* man page for more details on formatting this *data.frame*. The *bioassayR* package contains an example activity score data frame that can be accessed as follows:


{% highlight r %}
data(samplebioassay)
samplebioassay[1:10,] # print the first 10 scores
{% endhighlight %}

{% highlight txt %}
##         cid activity score
## 1    730195        0     0
## 2  16749973        1    80
## 3  16749974        1    80
## 4  16749975        1    80
## 5  16749976        1    80
## 6  16749977        1    80
## 7  16749978        1    80
## 8  16749979        1    80
## 9  16749980        1    80
## 10 16749981        1    80
{% endhighlight %}

All bioactivity data is loaded into the database, or retrieved from the database as an *bioassay* object which contains details on the assay experimental design, molecular targets, and the activity scores. A bioassay object which incorporates activity scores can be created as follows.
The source id value must exactly match that loaded earlier by *addDataSource*. The molecular target(s) for the assay are optional, and an unlimited number can be specified for a single assay as a vector passed to the targets option. The target types field should be a vector of equal length, describing the type of each target in the same order.


{% highlight r %}
myAssay <- new("bioassay",aid="1000", source_id="PubChem BioAssay",
    assay_type="confirmatory", organism="unknown", scoring="activity rank", 
    targets="116516899", target_types="protein", scores=samplebioassay)
myAssay
{% endhighlight %}

{% highlight txt %}
## class:		 bioassay 
## aid:		 1000 
## source_id:	 PubChem BioAssay 
## assay_type:	 confirmatory 
## organism:	 unknown 
## scoring:	 activity rank 
## targets:	 116516899 
## target_types:	 protein 
## total scores:	 57
{% endhighlight %}

The *bioassay* object can be loaded into the database with the *loadBioassay* function. By repeating this step with different data, a large number of distinct assays can be loaded into the database.


{% highlight r %}
loadBioassay(mydb, myAssay)
{% endhighlight %}

It is reccomended to use NCBI GI numbers as the label for any biomolecule
assay targets, as this is what is used in the pre-built database also
supplied with the package. In some cases it is useful to also store identifier translations,
which contain the corresponding IDs from other biological databases. For example,
in this case the mevalonate kinase target protein GI 116516899 has a corresponding
identifier in the UniProt Database of Q8DR51. This can be stored for future reference as follows.
Any number of translations from any category of choice can be stored in this way. It
can also be used to store annotation data for targets. For example, if you
have sequence level clustering data on your targets you could store them
in category "sequenceClustering" and store the cluster number as the identifier.


{% highlight r %}
loadIdMapping(mydb, target="116516899", category="UniProt", identifier="Q8DR51")
{% endhighlight %}

Wait a minute! We accidentally labeled that assay as organism "unknown" when we know that it's actually a screen against a protein from *Streptococcus pneumonia*. 
After loading an assay into the database, you can later retrieve these data with the *getAssay* function. By combining this with the ability to delete an assay (the *dropBioassay* function) one can edit the database by (1) pulling an assay out, (2) deleting it from the database, (3) modifying the pulled out object, and (4) reloading the assay. For example, we can update the species annotation for our assay as follows:


{% highlight r %}
tempAssay <- getAssay(mydb, "1000") # get assay from database
dropBioassay(mydb, "1000") # delete assay from database
organism(tempAssay) <- "Streptococcus pneumonia" # update organism
loadBioassay(mydb, tempAssay)
{% endhighlight %}

It is recommended to index your database after loading all of your data. This significantly speeds up access to the database, but can also slow down loading of data if indexing is performed before loading.


{% highlight r %}
addBioassayIndex(mydb)
{% endhighlight %}

{% highlight txt %}
## Creating index: note this may take a long time for a large database
{% endhighlight %}

After indexing, you can query the database. Here are some example queries. First view the database summary provided by *bioassayR*:


{% highlight r %}
mydb
{% endhighlight %}

{% highlight txt %}
## class:		 BioassayDB 
## assays:		 1 
## sources:	 PubChem BioAssay 
## writeable:	yes
{% endhighlight %}

Next, you can query the database for active targets for a given compound by cid. In this case, since only one assay has been loaded only a single target can be found. Experiment with loading more assays for a more interesting result!
When using the pre-built PubChem BioAssay database, these targets are returned
as NCBI Protein identifiers.


{% highlight r %}
activeTargets(mydb, 16749979)
{% endhighlight %}

{% highlight txt %}
##           fraction_active total_screens
## 116516899               1             1
{% endhighlight %}

If target translations were loaded in a previous step, these can be accessed with
the *translateTargetId* function as follows. This accepts only a single target,
and will return a vector of all corresponding identifiers in the category of choice.
In some cases, you may wish to subset this result to only get a single indentifier
when the database contains a large number for some targets.

Here we request the UniProt identifiers for GI 116516899, as stored earlier with
the *loadIdMapping* function.


{% highlight r %}
translateTargetId(mydb, target="116516899", category="UniProt")
{% endhighlight %}

{% highlight txt %}
## [1] "Q8DR51"
{% endhighlight %}

Lastly, disconnecting from the database after analysis reduces the chances of data corruption. If you are using a pre-built database in read only mode (as demonstrated in the Prebuilt Database Example section) you can optionally skip this step, as only writable databases are prone to corruption from failure to disconnect.


{% highlight r %}
disconnectBioassayDB(mydb)
{% endhighlight %}



