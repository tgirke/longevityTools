#!/bin/bash
## Script that runs typical workflow when updating site
## Author: Thomas Girke
## Last update: Feb 9, 2016

## (1) All changes should be made from gh_pages_source branch. Note, the script
##     should be run from the root directory of the repo.
git checkout gh_pages_source  

## (2) Edit existing pages and/or add new ones, usually in ./mydoc
## No automation for this one ... :).

## (3) Build site with changes you made
kill -9 $(ps aux | grep '[j]ekyll' | awk '{print $2}') # assures that no other jekyll process are running
clear
echo "Building Mydoc Designers website..."
jekyll build --config configs/mydoc/config_designers.yml
# jekyll serve --config configs/mydoc/config_designers.yml
echo "done"
echo "Finished building all the web outputs!!!"
echo "Now the builds are committed and pushed to github."

## (4) Commit edits made in gh_pages_source branch (assumes you have added/deleted files as needed)
git add -A :/
git commit -am "some edits"
git push -u origin gh_pages_source
echo "Committed/pushed changes to gh_pages_source branch on GitHub"

## (5) Sync changes to gh-pages branch
git checkout gh-pages
rsync -avh --stats ../doc_outputs/mydoc/designers/ .
clear
git add -A :/
git commit -am "some edits"; git push -u origin gh-pages
echo "Committed/pushed changes to gh-pages branch on GitHub"
git checkout gh_pages_source 
echo "Switched back to gh_pages_source branch on local repo."

