---
title: Administration of site
keywords: navigation tabs, hide sections, tabbers, interface tabs
last_updated: February 06, 2016
summary: "Internal notes for maintaining this site."
---

## How to create a new instance of this site

1. Create a new project repository on GitHub and give it any name. For instance, the project 
described here was named `manuals`. This initial setup will be the project's `master` branch. After this is done, clone the new repostitory to your 
local computer. If you are new to GitHub [here](https://guides.github.com/activities/hello-world/) are some basic instructions for creating 
and managing GitHub repositories

2. Download or clone the [Jekyll Documentation Theme](https://github.com/tomjohnson1492/documentation-theme-jekyll)
from Tom Johnson. Then copy the directory's content to your new project repository (here `manuals` directory).
Subsequently, commit and push its entire content to the `master` branch on GitHub.

3. Add a `gh-pages` branch to your newly created GitHub project repository.
By adding a `gh-pages` branch to a GitHub project, one can host from this branch 
a web site (here Jekyll site) for a GitHub project repository. The `master` branch of this
project contains the source code of the site and its `gh-pages` branch the pre-built web 
site components. Instruction for setting up a `gh-pages` branch for an existing project 
are available [here](https://help.github.com/articles/creating-project-pages-manually/).

## Edit a page

### Built and test site locally
Run following command within the root directory of the project's git repository
(here `~/Dropbox/Websites/manuals`) and then preview the site at the URL
printed to the terminal. Note, all paths are given here relative to this
directory.

{% highlight bash %}
jekyll serve --config configs/mydoc/config_designers.yml
{% endhighlight %}

{{site.data.alerts.note}} 
The built directory of the site is '../doc_outputs/mydoc/designers'. The changes are 
committed automatically when previewing the site with 'jekyll serve' or by executing the 'mydoc_*.sh' bash 
script(s) located in the root directory of the project.
{{site.data.alerts.end}}

### Edit site in `master` branch
Edits should be made in the project's [master](https://github.com/tgirke/manuals/tree/master) 
branch and then committed from there to the corresponding branch on GitHub.

{% highlight bash %}
git checkout master
vim ./mydoc/mydoc_some_page.md # Make changes to *.md pages in ./mydoc/
git commit -am "some edits"; git push -u origin master
{% endhighlight %}

### Sync changes to `gh-pages` branch
Currently, the changes to `../doc_outputs/mydoc/designers` need to be synced into the 
[gh-pages](https://github.com/tgirke/manuals/tree/gh-pages) branch of the project repository. The following accomplishes this with
`rsync`. The last two lines add, commit and push all changes to the `gh-pages` branch.
After this the changes should show up in the life version of the web site. Note, prior to
the syncing, one usually wants to shut down the locally running Jekyell server with
`Ctrl-c` in its terminal window.

{% highlight bash %}
git checkout gh-pages
rsync -avh --stats --progress ~/Dropbox/Websites/doc_outputs/mydoc/designers/ ~/Dropbox/Websites/manuals/
git add -A :/
git commit -am "some edits"; git push -u origin gh-pages
git checkout master
{% endhighlight %}

### Bash script for automation
To automate the above workflow, run the following `buildAll.sh` bash script
from the root directory of the repository's master branch.
{% highlight bash %}
./buildAll.sh
{% endhighlight %}

## Adding a new page

### Create page
The easiest is usually to copy an existing page in `\mydoc` and then make the necessary 
changes to its Jekyll front matter section and content.

### Sidebar and URL configuration
Next, the new page needs to be registered properly in the sidebar and URL configuration 
files.

{% highlight bash %}
vim _data/mydoc/mydoc_sidebar.yml
vim _data/mydoc/mydoc_urls.yml
{% endhighlight %}

After this the new page should be viewable in the local preview of your
browser.  This requires a running session of `jekyll serve ...` in the root
directory of the repository as shown above.

### Commit to GitHub
Similar as above add, commit and push changes to the `master` and `gh-pages` branches 
of the local and remote repositories or just run `buildAll.sh`.

{% highlight bash %}
git checkout master
git commit -am "some edits"; git push -u origin master
git checkout gh-pages
rsync -avh --stats --progress ~/Dropbox/Websites/doc_outputs/mydoc/designers/ ~/Dropbox/Websites/manuals/
git add -A :/
git commit -am "some edits"; git push -u origin gh-pages
git checkout master
{% endhighlight %}

## R markdown integration

(1) Write R markdown vignette (`*.Rmd` file) in `./vignettes` directory (*e.g.* `./vignettes/Rbasics`).

(2) Render vignette to `.md` and `.html` files with `rmarkdown::render()`.

(3) Append `.md` file (here `Rbasics.knit.md`) to corresponding `.md` file in `./mydoc` directory.

(4) Remove front matter genereted by R markdown, but leave the one required for Jekyll

(5) Replace chode chunk tags to the ones required by Jekyll Doc Theme

(6) Move images into proper directory and adjust their path in the `.md` file

Run steps (2)-(6) with one command using the `render()` function and the `md2jekyll.R` script:

{% highlight bash %}
echo "rmarkdown::render('Rbasics.Rmd', clean=FALSE)" | R --slave; R CMD Stangle Rbasics.Rmd; Rscript ../md2jekyll.R Rbasics.knit.md 3
{% endhighlight %}

## Useful utilities

### Site-wide configurations
Edit this file accordingly.

{% highlight bash %}
configs/mydoc/config_designers.yml
{% endhighlight %}

### Check differences in directories
One can also double-check by downloading the changes from GitHub and then run `diff`

{% highlight bash %}
diff -r ~/Dropbox/Websites/doc_outputs/mydoc/designers/ ~/Dropbox/Websites/manuals/
{% endhighlight %}




