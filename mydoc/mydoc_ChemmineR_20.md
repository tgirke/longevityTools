---
title: ChemMine Tools R Interface
keywords: 
last_updated: Sat Feb 13 19:36:03 2016
---

ChemMine Web Tools is an online service for analyzing and clustering small molecules. It provides numerous cheminformatics tools which can be used directly on the website, or called remotely from within R. When called within R jobs are sent remotely to a queue on a compute cluster at UC Riverside, which is a free service offered to `ChemmineR` users.
The website is free and open to all users and is available at <http://chemmine.ucr.edu>. When new tools are added to the service, they automatically become availiable within `ChemmineR` without updating your local R package.

List all available tools:


{% highlight r %}
listCMTools()
{% endhighlight %}


{% highlight txt %}
##      Category                           Name      Input     Output
## 1      Upload                Upload CSV Data  character data.frame
## 2      Upload      Upload Tab Delimited Data  character data.frame
## 3  Properties             JoeLib Descriptors     SDFset data.frame
## 4  Properties          OpenBabel Descriptors     SDFset data.frame
## 5  Clustering             Binning Clustering     SDFset  character
## 6  Clustering Multidimensional Scaling (MDS)     SDFset  character
## 7  Clustering        Numeric Data Clustering     SDFset  character
## 8  Clustering        Hierarchical Clustering     SDFset  character
## 9      Search                  pubchemID2SDF data.frame     SDFset
## 10   Plotting               Graph Visualizer     igraph  character
## 11 Properties           ChemmineR Properties     SDFset data.frame
## 12  ChemmineR                  sdf.visualize     SDFset     SDFset
## 13     Search                      EI Search     SDFset    integer
## 14     Search             Fingerprint Search     SDFset    integer
{% endhighlight %}

Show options and description for a tool. This also provides an example function call which can be copied
verbatim, and changed as necessary:


{% highlight r %}
toolDetails("Fingerprint Search")
{% endhighlight %}


{% highlight txt %}
## Category:		Search
## Name:			Fingerprint Search
## Input R Object:		SDFset
## Input mime type:	chemical/x-mdl-sdfile
## Output R Object:	integer
## Output mime type:	text/fp.search.result
## ###### BEGIN DESCRIPTION ######
## PubChem Fingerprint Search
## ####### END DESCRIPTION #######
## Option 1: 'Similarity Cutoff'
## Allowed Values:  '0.5' '0.6' '0.7' '0.8' '0.85' '0.9' '0.91' '0.92' '0.93' '0.94' '0.95' '0.96' '0.97' '0.98' '0.99'
## Option 2: 'Max Compounds Returned'
## Allowed Values:  '10' '50' '100' '200' '1000'
## Example function call:
## 	job <- launchCMTool(
## 		'Fingerprint Search',
## 		SDFset,
## 		'Similarity Cutoff'='0.5',
## 		'Max Compounds Returned'='10'
## 	)
{% endhighlight %}


## Launch a Job

When a job is launched it returns a job token which refers to the running job on the UC Riverside cluster. You can check the status of a job or obtain the results as follows. If `result` is called on a job that is still running, it will loop internally until the job is completed, and then return the result.

Launch the tool `pubchemID2SDF` to obtain the structure for PubChem cid 2244:


{% highlight r %}
job1 <- launchCMTool("pubchemID2SDF", 2244)
status(job1)
result1 <- result(job1)
{% endhighlight %}

Use the previous result to search PubChem for similar compounds:


{% highlight r %}
job2 <- launchCMTool('Fingerprint Search', result1, 'Similarity Cutoff'=0.95, 'Max Compounds Returned'=200)
result2 <- result(job2)
job3 <- launchCMTool("pubchemID2SDF", result2)
result3 <- result(job3)
{% endhighlight %}

Compute OpenBabel descriptors for these search results:


{% highlight r %}
job4 <- launchCMTool("OpenBabel Descriptors", result3)
result4 <- result(job4)
result4[1:10,] # show first 10 lines of result
{% endhighlight %}


{% highlight txt %}
##         cid abonds atoms bonds dbonds HBA1 HBA2 HBD   logP      MR       MW nF sbonds tbonds  TPSA
## 1      2244      6    21    21      2   12    4   1 1.3101 44.9003 180.1574  0     13      0 63.60
## 2      5161     12    29    30      2   15    5   2 2.3096 66.8248 258.2262  0     16      0 83.83
## 3     68484      6    24    24      2   14    4   0 1.3985 49.2205 194.1840  0     16      0 52.60
## 4     10745     12    34    35      3   18    6   1 2.5293 76.3008 300.2629  0     20      0 89.90
## 5    135269      6    30    30      2   18    4   1 2.4804 59.3213 222.2372  0     22      0 63.60
## 6     67252      6    22    22      1   13    3   1 1.7835 44.7003 166.1739  0     15      0 46.53
## 7    171511      6    25    23      2   16    5   2 1.2458 47.9481 222.4777  0     15      0 72.83
## 8   3053800      6    39    39      2   24    4   1 3.6507 73.7423 264.3169  0     31      0 63.60
## 9  71586929      6    38    33      2   29    7   6 1.7922 60.7157 294.2140  0     25      0 91.29
## 10    78094      6    24    24      2   14    4   1 1.6185 49.8663 194.1840  0     16      0 63.60
{% endhighlight %}


## View Job Result in Browser

The function `browseJob` launches a web browser to view the results of a job online, just as if they
had been run from the ChemMine Tools website itself. If you also want the result data within R, you must first call
the `result` object from within R before calling `browseJob`. Once `browseJob` has been called on a job token,
the results are no longer accessible within R. 

If you have an account on ChemMine Tools and would like to save the web results from your job, you must first login to your account within the default web browser on your system before you launch `browseJob`. The job will then be assigned automatically to the currently logged in account.

View OpenBabel descriptors online:


{% highlight r %}
browseJob(job4)
{% endhighlight %}

Perform binning clustering and visualize result online:


{% highlight r %}
job5 <- launchCMTool("Binning Clustering", result3, 'Similarity Cutoff'=0.9)
browseJob(job5)
{% endhighlight %}



