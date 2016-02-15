---
title: Pre-processing of CEL files
keywords: 
last_updated: Mon Feb 15 15:06:28 2016
---

## Determine chip type from CEL files 
The CMAP data set is based on three different Affymetrix chip types (HG-U133A,
HT_HG-U133A and U133AAofAv2). The following extracts the chip type information
from the CEL files and stores the result in an `rds` file with the path 
`./data/chiptype.rds`. Users who skipped the download of the CEL files can
download this file [here](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/data/chiptype.rds).


{% highlight r %}
celfiles <- list.files("./data/CEL", pattern=".CEL$")
chiptype <- sapply(celfiles, function(x) affxparser::readCelHeader(paste0("data/CEL/", x))$chiptype)
if(FALSE) saveRDS(chiptype, "./data/chiptype.rds") # if(FALSE) protects this line from accidental execution!
{% endhighlight %}


## Normalization of CEL files

The follwoing processes the CEL files from each chip type separately using the
MAS5 normalization algorithm. The results will be written to 3 subdirectores
under `data` that are named after the chip type names.  To save time, the
processing is parallelized with `BiocParallel` to run on 100 CPU cores of a
computer cluster with a scheduler (_e.g._ Torque). The number of CEL files from
each chip type are: 807 CEL files from HG-U133A, 6029 CEL files from
HT_HG-U133A, and 220 CEL files from U133AAofAv2. Note, these numbers are slightly
different than those reported in the `cmap_instances_02.txt` file. The MAS5 normalized data
sets can be downloaded here: 
[HG-U133A](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/data/HG-U133A/all_mas5exprs.rds), 
[HT_HG-U133A](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/data/HT_HG-U133A/all_mas5exprs.rds), 
[U133AAofAv2](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/data/U133AAofAv2/all_mas5exprs.rds).



{% highlight r %}
library(BiocParallel); library(BatchJobs); library(affy)
chiptype <- readRDS("./data/chiptype.rds")
chiptype_list <- split(names(chiptype), as.character(chiptype))
normalizeCel(chiptype_list, rerun=FALSE) 
{% endhighlight %}


## Combine results from same chip type in single data frame


{% highlight r %}
chiptype_dir <- unique(readRDS("./data/chiptype.rds"))
combineResults(chiptype_dir, rerun=FALSE)
{% endhighlight %}


## Clean-up of intermediate files

This deletes intermediate files. Before executing these lines, please make sure that this is what you want.


{% highlight r %}
for(i in seq_along(chiptype_dir)) unlink(list.files(paste0("data/", chiptype_dir[i]), pattern="cellbatch", full.names=TRUE), recursive=TRUE)
unlink("data/CEL/*.CEL") # Deletes downloaded CEL files
{% endhighlight %}


