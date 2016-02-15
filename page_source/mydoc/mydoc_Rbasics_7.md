---
title: Data objects
keywords: 
last_updated: Fri Feb 12 18:06:43 2016
---

## Object types

__Vectors (1D)__: `numeric` or `character`


{% highlight r %}
myVec <- 1:10; names(myVec) <- letters[1:10]  
myVec[1:5]
{% endhighlight %}

{% highlight txt %}
## a b c d e 
## 1 2 3 4 5
{% endhighlight %}

{% highlight r %}
myVec[c(2,4,6,8)]
{% endhighlight %}

{% highlight txt %}
## b d f h 
## 2 4 6 8
{% endhighlight %}

{% highlight r %}
myVec[c("b", "d", "f")]
{% endhighlight %}

{% highlight txt %}
## b d f 
## 2 4 6
{% endhighlight %}

__Factors (1D)__: vectors with grouping information


{% highlight r %}
factor(c("dog", "cat", "mouse", "dog", "dog", "cat"))
{% endhighlight %}

{% highlight txt %}
## [1] dog   cat   mouse dog   dog   cat  
## Levels: cat dog mouse
{% endhighlight %}

__Matrices (2D)__: two dimensional structures with data of same type


{% highlight r %}
myMA <- matrix(1:30, 3, 10, byrow = TRUE) 
class(myMA)
{% endhighlight %}

{% highlight txt %}
## [1] "matrix"
{% endhighlight %}

{% highlight r %}
myMA[1:2,]
{% endhighlight %}

{% highlight txt %}
##      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
## [1,]    1    2    3    4    5    6    7    8    9    10
## [2,]   11   12   13   14   15   16   17   18   19    20
{% endhighlight %}

{% highlight r %}
myMA[1, , drop=FALSE]
{% endhighlight %}

{% highlight txt %}
##      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
## [1,]    1    2    3    4    5    6    7    8    9    10
{% endhighlight %}

__Data Frames (2D)__: two dimensional objects with data of variable types


{% highlight r %}
myDF <- data.frame(Col1=1:10, Col2=10:1) 
myDF[1:2, ]
{% endhighlight %}

{% highlight txt %}
##   Col1 Col2
## 1    1   10
## 2    2    9
{% endhighlight %}

__Arrays__: data structure with one, two or more dimensions


__Lists__: containers for any object type


{% highlight r %}
myL <- list(name="Fred", wife="Mary", no.children=3, child.ages=c(4,7,9)) 
myL
{% endhighlight %}

{% highlight txt %}
## $name
## [1] "Fred"
## 
## $wife
## [1] "Mary"
## 
## $no.children
## [1] 3
## 
## $child.ages
## [1] 4 7 9
{% endhighlight %}

{% highlight r %}
myL[[4]][1:2] 
{% endhighlight %}

{% highlight txt %}
## [1] 4 7
{% endhighlight %}

__Functions__: piece of code


{% highlight r %}
myfct <- function(arg1, arg2, ...) { 
	function_body 
}
{% endhighlight %}

## Subsetting of data objects

__Subsetting by positive or negative index/position numbers__


{% highlight r %}
myVec <- 1:26; names(myVec) <- LETTERS 
myVec[1:4]
{% endhighlight %}

{% highlight txt %}
## A B C D 
## 1 2 3 4
{% endhighlight %}

__Subsetting by same length logical vectors__


{% highlight r %}
myLog <- myVec > 10
myVec[myLog] 
{% endhighlight %}

{% highlight txt %}
##  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z 
## 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
{% endhighlight %}

__Subsetting by field names__


{% highlight r %}
myVec[c("B", "K", "M")]
{% endhighlight %}

{% highlight txt %}
##  B  K  M 
##  2 11 13
{% endhighlight %}

__Subset with `$` sign__: references a single column or list component by its name 


{% highlight r %}
iris$Species[1:8]
{% endhighlight %}

{% highlight txt %}
## [1] setosa setosa setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
{% endhighlight %}

