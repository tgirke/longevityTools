---
title: Storing Compounds in an SQL Database
keywords: 
last_updated: Sat Feb 13 19:36:03 2016
---

As an alternative to sdfStream, there is now also an option to store
data in an SQL database, which then allows for fast queries and compound
retrieval. The default database
is SQLite, but any other SQL database should work with some minor
modifications to the table definitions, which are stored in
schema/compounds.SQLite under the ChemmineR package directory. Compounds
are stored in their entirety in the databases so there is no need to
keep any original data files.

Users can define their own set of compound features to compute and store
when loading new compounds. Each of these features will be stored in its
own, indexed table. Searches can then be performed using these features
to quickly find specific compounds. Compounds can always be retrieved
quickly because of the database index, no need to scan a large compound
file. In addition to user defined features, descriptors can also be
computed and stored for each compound.

A new database can be created with the `initDb` function.
This takes either an existing database connection, or a filename. If a
filename is given then an SQLite database connection is created. It then
ensures that the required tables exist and creates them if not. The
connection object is then returned. This function can be called safely
on the same connection or database many times and will not delete any
data.


## Loading Data

The functions `loadSdf` and `loadSmiles` can be used to load
compound data from either a file (both) or an `SDFset` (`loadSdf`
only).  The `fct` parameter should be a function to
extract features from the data. It will be handed an
`SDFset` generated from the data being loaded. This may
be done in batches, so there is no guarantee that the given SDFSset will
contain the whole dataset. This function should return a data frame with
a column for each feature and a row for each compound given. The order
of the final data frame should be the same as that of the
`SDFset`. The column names will become the feature names.
Each of these features will become a new, indexed, table in the database
which can be used later to search for compounds.

The `descriptors` parameter can be a function which
computes descriptors. This function will also be given an
`SDFset` object, which may be done in batches. It should
return a data frame with the following two columns: "descriptor" and
"descriptor\_type". The "descriptor" column should contain a string
representation of the descriptor, and "descriptor\_type" is the type of
the descriptor. Our convention for atom pair is "ap" and "fp" for finger
print. The order should also be maintained.

When the data has been loaded, `loadSdf` will return the
compound id numbers of each compound loaded. These compound id numbers
are computed by the database and are not extracted from the compound
data itself. They can be used to quickly retrieve compounds later.

New features can also be added using this function. However, all
compounds must have all features so if new features are added to a new
set of compounds, all existing features must be computable by the
`fct` function given. If new features are detected, all
existing compounds will be run through `fct` in order to
compute the new features for them as well.

For example, if dataset X is loaded with features F1 and F2, and then at
a later time we load dataset Y with new feature F3, the
`fct` function used to load dataset Y must compute and
return features F1, F2, and F3. `loadSdf` will call
`fct` with both datasets X and Y so that all features are
available for all compounds. If any features are missing an error will
be raised. If just new features are being added, but no new compounds,
use the `addNewFeatures` function.

In this example, we create a new database called "test.db" and load it
with data from an `SDFset`. We also define
`fct` to compute the molecular weight, "MW", and the
number of rings and aromatic rings. The rings function actually returns
a data frame with columns "RINGS" and "AROMATIC", which will be merged
into the data frame being created which will also contain the "MW"
column. These will be the names used for these features and must be used
when searching with them. Finally, the new compound ids are returned and
stored in the "ids" variable.



{% highlight r %}
 data(sdfsample)

 #create and initialize a new SQLite database 
 conn <- initDb("test.db")
{% endhighlight %}

{% highlight txt %}
## Loading required package: RSQLite
{% endhighlight %}

{% highlight txt %}
## Loading required package: DBI
{% endhighlight %}

{% highlight r %}
 # load data and compute 3 features: molecular weight, with the MW function, 
 # and counts for RINGS and AROMATIC, as computed by rings, which 
 # returns a data frame itself. 
 ids<-loadSdf(conn,sdfsample, function(sdfset) 
					 data.frame(rings(sdfset,type="count",upper=6, arom=TRUE),propOB(sdfset)) ) 

 #list features in the database:
 print(listFeatures(conn))
{% endhighlight %}

{% highlight txt %}
##  [1] "aromatic" "cansmi"   "cansmins" "formula"  "hba1"     "hba2"     "hbd"      "inchi"   
##  [9] "logp"     "mr"       "mw"       "nf"       "rings"    "title"    "tpsa"
{% endhighlight %}


## Updates
By default the `loadSdf` / `loadSmiles` functions will detect duplicate
compound entries and only insert one of them. This means it is safe
to run these functions on the same data set several times and you
won't end up with duplicates. This allows the functions to be re-run
in the event that a previous run on a dataset does not complete.
Duplicate compounds are detected by compouting the MD5 checksum on
the textual representation of it. 

It can also update existing compounds with new versions of the same
compound. To enable this, set `updateByName` to true. It will then
consider two compounds with the same name to be the same, even if the
definition is different. Then, if the name of a compound exists in
the database and it is trying to insert another compound with the
same name, it will overwrite the existing compound. It will also drop
and re-compute all associated descriptors and features for the new
compound (assuming the required functions for descriptor and feature
computation are available at the time the update is performed).


## Duplicate Descriptors
It is often the case when loading a large set of compounds that
several compounds will produce the same descriptor. `ChemmineR` 
detects this case and only stores one copy of the descriptor for
every compound it is for. This feature saves some space and some
time for processes that need to be applied to every descriptor.
It also highlights a new problem. If you have a descriptor in hand
and you want to find a single compound to represent it, which
compound should be used if the descriptor was produced from multiple
compounds? To address this problem, `ChemmineR` allows you to set
priority values for each compound-descriptor mapping. Then, in
contexts where a single compound is required, the highest priority
compound will be chosen. Highest priority corresponds to the lowest
numerical value. So mapping with priority 0 would be used first.

To set these priorities there is the function `setPriorities`.
It takes a function, `priorityFn`, for computing these priority values.
The `setPriorities` function should be run after loading a complete set of data.
It will find each group of compounds which share the same
descriptor and call the given function, `priorityFn`, 
with the compound_id numbers of the group. This function should
then assign priorities to each compound-descriptor pair, however
it wishes. 

One built in priority function is `forestSizePriorities`. This simply
prefers compounds with fewer disconnected components over compounds with
more dissconnected components.


{% highlight r %}
setPriorities(conn,forestSizePriorities)
{% endhighlight %}



## Searching

Compounds can be searched for using the `findCompounds`
function. This function takes a connection object, a vector of feature
names used in the tests, and finally, a vector of tests that must all
pass for a compound to be included in the result set. Each test should
be a boolean expression. For example: `c("MW <= 400","RINGS \> 3")`
would return all compounds with a molecular weight of 400 or less and
more than 3 rings, assuming these features exist in the database. The
syntax for each test is `'\<feature name\> \<SQL operator\> \<value\>'`.
If you know SQL you can go beyond this basic syntax. These tests will
simply be concatenated together with "AND" in-between them and tacked on
the end of a WHERE clause of an SQL statement. So any SQL that will work
in that context is fine. The function will return a list of compound
ids, the actual compounds can be fetched with
`getCompounds`. If just the names are needed, the
`getCompoundNames` function can be used. Compounds can
also be fetched by name using the `findCompoundsByName`
function.

In this example we search for compounds with molecular weight less than
300.



{% highlight r %}
results = findCompounds(conn,"mw",c("mw < 300"))
message("found ",length(results))
{% endhighlight %}

{% highlight txt %}
## found 23
{% endhighlight %}

If more than one test is given, only compounds which satisfy all tests are found. So if we wanted
to further restrict our search to compounds with 2 or more aromatic rings we could do:

{% highlight r %}
results = findCompounds(conn,c("mw","aromatic"),c("mw < 300","aromatic >= 2"))
message("found ",length(results))
{% endhighlight %}

{% highlight txt %}
## found 9
{% endhighlight %}

Remember that any feature used in some test must be listed in the second argument.

String patterns can also be used. So if we wanted to match a substring of the molecular formula, say
to find compounds with 21 carbon atoms, we could do:

{% highlight r %}
results = findCompounds(conn,"formula",c("formula like '%C21%'"))
message("found ",length(results))
{% endhighlight %}

{% highlight txt %}
## found 12
{% endhighlight %}

The "like" operator does a pattern match. There are two wildcard 
operators that can be used with this operator. The "%" will match any stretch of characters while the "?"
will match any single character. So the above expression would match a formula like "C21H28N4O6".

Valid comparison operators are: 

 - <,    <=,   > ,   >=
 - =,    ==,   !=,   <>,   IS,   IS NOT,   IN,   LIKE 

The boolean operators "AND" and "OR" can also be used to create more complex expressions within a single test.

If you just want to fetch every compound in the database you can use the `getAllCompoundIds` function:

{% highlight r %}
allIds = getAllCompoundIds(conn)
message("found ",length(allIds))
{% endhighlight %}

{% highlight txt %}
## found 100
{% endhighlight %}


## Using Search Results
Once you have a list of compound ids from the `findCompounds` function, you can either
fetch the compound names, or the whole set of compounds as an SDFset. 


{% highlight r %}
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
{% endhighlight %}

Using the `getCompoundFeatures` function, you can get a set of feature values 
as a data frame:

{% highlight r %}
getCompoundFeatures(conn,results[1:5],c("mw","logp","formula"))
{% endhighlight %}

{% highlight txt %}
##   compound_id       mw   logp       formula
## 1         204 461.5346 1.3127   C21H27N5O5S
## 2         208 438.4780 3.5492  C21H19FN6O2S
## 3         221 340.4592 3.1325    C21H28N2O2
## 4         238 447.9351 5.2940 C21H22ClN3O4S
## 5         243 456.5181 3.0020   C21H24N6O4S
{% endhighlight %}

{% highlight r %}
#write results directly to a CSV file (reduces memory usage):
getCompoundFeatures(conn,results[1:5],c("mw","logp","formula"),filename="features.csv")

#maintain input order in output:
print(results[1:5])
{% endhighlight %}

{% highlight txt %}
## [1] 204 208 221 238 243
{% endhighlight %}

{% highlight r %}
getCompoundFeatures(conn,results[1:5],c("mw","logp","formula"),keepOrder=TRUE)
{% endhighlight %}

{% highlight txt %}
##     compound_id       mw   logp       formula
## 204         204 461.5346 1.3127   C21H27N5O5S
## 208         208 438.4780 3.5492  C21H19FN6O2S
## 221         221 340.4592 3.1325    C21H28N2O2
## 238         238 447.9351 5.2940 C21H22ClN3O4S
## 243         243 456.5181 3.0020   C21H24N6O4S
{% endhighlight %}


## Pre-Built Databases
We have pre-built SQLite databases for the Drug Bank and DUD datasets. They can be found in 
the ChemmineDrugs annotation package. Connections to these databases can be fetched from the
functions `DrugBank` and `DUD` to get the corresponding database. Any of the above functions can
then be used to query the database.

The DUD dataset was downloaded from [here](http://dude.docking.org/db/subsets/all/all.tar.gz). A description
can be found [here](http://dude.docking.org/). 

The Drug Bank data set is version 4.1. It can be downloaded [here](http://www.drugbank.ca/system/downloads/current/structures/all.sdf.zip)

The following features are included:

 - **aromatic**: Number of aromatic rings
 - **cansmi**: Canonical SMILES sting
 - **cansmins**:
 - **formula**: Molecular formula
 - **hba1**:
 - **hba2**:
 - **hbd**:
 - **inchi**: INCHI string
 - **logp**:
 - **mr**:
 - **mw**: Molecular weight
 - **ncharges**:
 - **nf**:
 - **r2nh**:
 - **r3n**:
 - **rcch**:
 - **rcho**:
 - **rcn**:
 - **rcooh**:
 - **rcoor**:
 - **rcor**:
 - **rings**:
 - **rnh2**:
 - **roh**:
 - **ropo3**:
 - **ror**:
 - **title**:
 - **tpsa**:

The DUD database additionally includes:

 - **target_name**: Name of the target
 - **type**: either "active" or "decoy"


