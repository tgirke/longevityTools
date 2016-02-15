---
title: Overview of Classes and Functions
keywords: 
last_updated: Sat Feb 13 19:36:03 2016
---

The following list gives an overview of the most important S4 classes,
methods and functions available in the ChemmineR package. The help
documents of the package provide much more detailed information on each
utility. The standard R help documents for these utilities can be
accessed with this syntax: `?function\_name` (*e.g.*
`?cid`) and `?class\_name-class` (*e.g*.
`?"SDFset-class"`).


## Molecular Structure Data

Classes

-   `SDFstr`: intermediate string class to facilitate SD
    file import; not important for end user

-   `SDF`: container for single molecule imported from an
    SD file

-   `SDFset`: container for many SDF objects; most
    important structure container for end user

-   `SMI`: container for a single SMILES string

-   `SMIset`: container for many SMILES strings

Functions/Methods (mainly for `SDFset` container,
`SMIset` should be coerced with
`smiles2sd` to `SDFset`)

-   Accessor methods for `SDF/SDFset`

    -   Object slots: `cid`, `header`, `atomblock`, `bondblock`,
        `datablock` (`sdfid`, `datablocktag`)

    -   Summary of `SDFset`: `view`

    -   Matrix conversion of data block: `datablock2ma`,
        `splitNumChar`

    -   String search in SDFset: `grepSDFset`

-   Coerce one class to another

    -   Standard syntax `as(..., "...")` works in most
        cases. For details see R help with
       `?"SDFset-class"`.

-   Utilities

    -   Atom frequencies: `atomcountMA`, `atomcount`

    -   Molecular weight: `MW`

    -   Molecular formula: `MF`

    -   ...

-   Compound structure depictions

    -   R graphics device: `plot`, `plotStruc`

    -   Online: `cmp.visualize`


## Structure Descriptor Data

Classes

-   `AP`: container for atom pair descriptors of a single
    molecule

-   `APset`: container for many AP objects; most
    important structure descriptor container for end user

-   `FP`: container for fingerprint of a single molecule

-   `FPset`: container for fingerprints of many
    molecules, most important structure descriptor container for end
    user

Functions/Methods

-   Create `AP/APset` instances

    -   From `SDFset`: `sdf2ap`

    -   From SD file: `cmp.parse`

    -   Summary of `AP/APset`: `view`,
        `db.explain`

-   Accessor methods for AP/APset

    -   Object slots: `ap`, `cid`

-   Coerce one class to another

    -   Standard syntax `as(..., "...")` works in most
        cases. For details see R help with
        `?"APset-class"`.

-   Structure Similarity comparisons and Searching

    -   Compute pairwise similarities : `cmp.similarity`,
        `fpSim`

    -   Search APset database: `cmp.search`, `fpSim`

-   AP-based Structure Similarity Clustering

    -   Single-linkage binning clustering: `cmp.cluster`

    -   Visualize clustering result with MDS:
        `cluster.visualize`

    -   Size distribution of clusters: `cluster.sizestat`
-   Folding
    - Fold a descriptor with `fold`
	 - Query the number of times a descriptor has been folded:
		`foldCount`
	 - Query the number of bits in a descriptor: `numBits`
	 

