---
title: Sample data from GTEx
keywords: 
last_updated: Mon Feb 15 14:59:07 2016
---
The eQTL data used in this vignette can be downloaded from the [GTEx site](http://www.gtexportal.org/home/datasets).
Note, the following downloads a 1.3GB file, which will take some time.


{% highlight r %}
download.file("http://www.gtexportal.org/static/datasets/gtex_analysis_v6/single_tissue_eqtl_data/GTEx_Analysis_V6_eQTLs.tar.gz", "./GTEx_Analysis_V6_eQTLs.tar.gz")
untar("GTEx_Analysis_V6_eQTLs.tar.gz")
{% endhighlight %}

