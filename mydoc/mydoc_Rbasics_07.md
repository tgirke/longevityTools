---
title: Data Types 
keywords: 
last_updated: Thu Feb 11 21:16:00 2016
---

__Numeric data__: `1, 2, 3, ...`


{% highlight r %}
x <- c(1, 2, 3)
x
{% endhighlight %}

{% highlight txt %}
## [1] 1 2 3
{% endhighlight %}

{% highlight r %}
is.numeric(x)
{% endhighlight %}

{% highlight txt %}
## [1] TRUE
{% endhighlight %}

{% highlight r %}
as.character(x)
{% endhighlight %}

{% highlight txt %}
## [1] "1" "2" "3"
{% endhighlight %}

__Character data__: `"a", "b", "c", ...`


{% highlight r %}
x <- c("1", "2", "3")
x
{% endhighlight %}

{% highlight txt %}
## [1] "1" "2" "3"
{% endhighlight %}

{% highlight r %}
is.character(x)
{% endhighlight %}

{% highlight txt %}
## [1] TRUE
{% endhighlight %}

{% highlight r %}
as.numeric(x)
{% endhighlight %}

{% highlight txt %}
## [1] 1 2 3
{% endhighlight %}

__Complex data__: mix of both


{% highlight r %}
c(1, "b", 3)
{% endhighlight %}

{% highlight txt %}
## [1] "1" "b" "3"
{% endhighlight %}

__Logical data__: `TRUE` of `FALSE`


{% highlight r %}
x <- 1:10 < 5
x  
{% endhighlight %}

{% highlight txt %}
##  [1]  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
{% endhighlight %}

{% highlight r %}
!x
{% endhighlight %}

{% highlight txt %}
##  [1] FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
{% endhighlight %}

{% highlight r %}
which(x) # Returns index for the 'TRUE' values in logical vector
{% endhighlight %}

{% highlight txt %}
## [1] 1 2 3 4
{% endhighlight %}

