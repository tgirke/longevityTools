######################################################################################
## Functions to convert R Markdown vignettes to paged markdown for Jekyll Doc Theme ##
######################################################################################
## Author: Thomas Girke
## Date: Feb 10, 2016

md2Jekyll <- function(mdfile="Rbasics.knit.md", sidebartitle=NULL, sidebarpos, outfilebasename=NULL, outpath="./", sidebar_url_path="./", fenced2highlight=TRUE, image_dir=NULL) {
    ## (1) Import md file 
    md <- readLines(mdfile)

    ## Remove lines/patterns that are not appropriate for the Jekyll Doc Theme
    md <- md[!grepl("\\[Back to Table of Contents\\]", md)]
    md <- gsub("</br>", "", md) # Removes orphan breaks

    ## Convert underline-section tags to comment-section tags (some *.Rmd/*.md files use this format)
    sectionunderlineindex <- grepl("^==={1,}", md)
    subsectionunderlineindex <- grepl("^---{1,}", md)
    md[which(sectionunderlineindex) - 1] <- paste0("# ", md[which(sectionunderlineindex) - 1])
    md[which(subsectionunderlineindex) - 1] <- paste0("## ", md[which(subsectionunderlineindex) - 1])
    md <- md[!(sectionunderlineindex | subsectionunderlineindex)]

    ## (2) Parse specific entries in front matter
    mymaindoctitle <- md[1:20][grepl("^title:", tolower(md[1:20]))]
    mymaindoctitle <- gsub("(^.*? )|_|\\*|\"", "", mymaindoctitle)
    mymaindoctitle <- gsub(":", " -", mymaindoctitle)
    myauthor <- md[1:20][grepl("^author:", tolower(md[1:20]))]
    myauthor <- gsub("(^.*? )|_|\\*|\"", "", myauthor)
    mydate <- md[1:20][grepl("^date:", tolower(md[1:20]))]
    mydate <- gsub("(^.*? )|_|\\*|\"", "", mydate)
    
    ## (3) Optionally, convert fenced backtick code tags to 'highlight' tags
    ## Get code chunk ranges to protect them from being split if they contain #s at beginning of lines
    chunkpos <- grep("^```", md)
    ma <- matrix(chunkpos, length(chunkpos)/2, 2, byrow=TRUE)
    codechunk_ranges <- unlist(sapply(seq_along(ma[,1]), function(x) ma[x,1]:ma[x,2]))
    
    if(fenced2highlight==TRUE) {
        if((length(chunkpos) %% 2) != 0) stop("Odd number of chunk tags.")
        if(length(chunkpos) != 0) {
            ## Process code chunk positions
            codestartpos <- grep("^```\\w{1,}", md)
            languagetag <- gsub("^`{3,}", "", md[codestartpos])
            languagetag <- paste0("{% highlight ", languagetag, " %}")
            md[codestartpos] <- languagetag
            codeendpos <- chunkpos[which(chunkpos %in% codestartpos) + 1]
            md[codeendpos] <- "{% endhighlight %}"

            ## Process output chunk positions
            outputpos <- chunkpos[!chunkpos %in% c(codestartpos, codeendpos)]
            if(length(outputpos) != 0) {
                outputstartpos <- matrix(outputpos, (length(outputpos)/2), 2, byrow=TRUE)[,1]
                outputendpos <- matrix(outputpos, (length(outputpos)/2), 2, byrow=TRUE)[,2]
                md[outputstartpos] <- "{% highlight txt %}" # note, just highlight without language tag gives error in Jekyll
                md[outputendpos] <- "{% endhighlight %}"
            }
        }
    }
   
    ## (4) Collect all images in one directory and adjust image file paths in md file accordingly
    ## Generate new image_dir
    if(is.null(image_dir)) {
        image_dir <- gsub(".knit.md$", "_images", mdfile)
        image_dir <- gsub("^.*/", "", image_dir)
    } else {
        image_dir <- image_dir
    }
    image_dir <- paste0(outpath, "/", image_dir)
    image_dir <- gsub("/{1,}", "/", image_dir)
    dir.create(image_dir, showWarnings=FALSE)
    ## Get html image file paths
    htmlimgindex <- grepl("src=\".*\"", md)
    if(sum(htmlimgindex) > 0) {
        htmlimgtag <- md[htmlimgindex]
        htmlimgpath <- gsub("^.*?src=\"(.*?)\".*", "\\1", htmlimgtag)
        ## Correct html image paths in md accordingly
        image_dir2 <- gsub("^.*/", "", image_dir) # Note, image path is relative in html source
        newhtmlimgpath <- paste0(image_dir2, "/", gsub("^.*/", "", htmlimgpath))
        newhtmlimgpath <- paste0(gsub("(^.*?src=\").*", "\\1", htmlimgtag), 
                                 newhtmlimgpath, 
                                 gsub("^.*?src=\".*?(\".*)", "\\1", htmlimgtag))
        md[htmlimgindex] <- newhtmlimgpath
        ## Copy image files into image_dir
        file.copy(from=htmlimgpath[file.exists(htmlimgpath)], to=image_dir, overwrite=TRUE)
    } 
    
    ## Get md image file paths
    mdimgindex <- grepl("\\!\\[.*{0,}\\]\\(.*\\)", md)
    if(sum(mdimgindex) > 0) {
        mdimgtag <- md[mdimgindex]
        mdimgpath <- gsub("\\!\\[.*{0,}\\]\\((.*)\\)\\\\{0,}", "\\1", mdimgtag)
        ## Correct image paths in md accordingly
        image_dir2 <- gsub("^.*/", "", image_dir) # Note, image path is relative in html source
        newmdimgpath <- paste0(image_dir2, "/", gsub("^.*/", "", mdimgpath))
        newmdimgpath <- paste0(gsub("(\\!\\[.*{0,}\\]\\().*", "\\1", mdimgtag),
                               newmdimgpath,
                               ")")
        md[mdimgindex] <- newmdimgpath
        ## Copy image files into image_dir
        file.copy(from=mdimgpath[file.exists(mdimgpath)], to=image_dir, overwrite=TRUE)
    }
    cat(paste("Saved image files to directory:", image_dir, "\n")) 

    ## (5) Split on main sections (^# )
    ## Identify split positions
    splitpos <- grep("^# {1,}", md)
    splitpos <- splitpos[!splitpos %in% codechunk_ranges]
    if(length(splitpos) != 0) {
        splitdist <- c(splitpos, length(md)+1) - c(1, splitpos) 
        mdlist <- split(md, factor(rep(c(1, splitpos), splitdist)))
    
        ## Get alternative format info and remove front matter of R Markdown 
        altformatspos <- grep("^Alternative formats", mdlist[[1]])
        if(length(altformatspos)==1) {
            altformats <- mdlist[[1]][grep("^Alternative formats", mdlist[[1]]) : length(mdlist[[1]])]
            # mdlist[[2]] <- c(mdlist[[2]][1], altformats, mdlist[[2]][-1])
        } else {
            altformats <- ""
        }
        mdlist <- mdlist[-1] # Removes R Markdown front matter
    
        ## Write sections stored in list components to separate files
        titles <- sapply(seq_along(mdlist), function(x) mdlist[[x]][1])
    } else {
        stop("mdfile is expected to contain at least one section tag.")
    }
    
    ## (6) Add Jekyll Doc front matter to each list component
    for(i in seq_along(mdlist)) {
        frontmatter <- c(starttag="---", 
                         title=paste0("title: ", gsub("^# {1,}", "", titles[i])), 
                         keywords="keywords: ", 
                         last_updated=paste0("last_updated: ", date()), 
                         endtag="---")
        mdlist[[i]] <- c(as.character(frontmatter), mdlist[[i]][-1])
    }
    
    ## Special handling of first page
    mdlist[[1]][2] <- paste0("title: ", mymaindoctitle) # Uses in front matter main title of source document
    mdlist[[1]] <- c(mdlist[[1]][1:5], myauthor, "", mydate, "", altformats, "", paste0("#", titles[1]), mdlist[[1]][6:length(mdlist[[1]])])    


    ## (7) Write sections to files named after input files with numbers appended
    filenumbers <- sprintf(paste0("%0", as.character(nchar(length(mdlist))), "d"), seq_along(mdlist))
    ## If no outfilebasename is provided the use default where they are named after input file with ".knit.md" stripped off
    if(is.null(outfilebasename)) {
        outfilebasename <- gsub(".knit.md$", "", mdfile)
    } else {
        outfilebasename <- outfilebasename    
    }
    filenames <- paste0(gsub("/$", "", outpath), "/mydoc_", outfilebasename, "_", filenumbers, ".md")
    filenames <- gsub("/{1,}", "/", filenames)
    for(i in seq_along(mdlist)) {
        writeLines(mdlist[[i]], filenames[i])
        cat(paste("Created file:", filenames[i]), "\n") 
    }
    
    ## (8) Register new files in sidebar (_data/mydoc/mydoc_sidebar.yml)
    sb <- readLines("../../_data/mydoc/mydoc_sidebar.yml")
    splitFct <- function(sb, pattern) {    
        splitpos <- grep(pattern, sb)
        if(length(splitpos) != 0) {
            splitdist <- c(splitpos, length(sb)+1) - c(1, splitpos) 
            sblist <- split(sb, factor(rep(c(1, splitpos), splitdist)))
            mynames <- gsub("^.*title: {1,}", "", sb[splitpos])
            mynames <- gsub(" {1,}", "_", mynames)
            names(sblist) <- c("header", mynames)
            return(sblist)
        } else {
            stop("mydoc_sidebar.yml is expected to contain at least one component.")
        }
    }
    ## Split on first level
    sblist <- splitFct(sb=sb, pattern="^ {2,2}- title: \\w{1,}")
    ## Split on second level resulting in nested list
    header <- sblist[1]
    sblist <- sblist[-1]
    sblist <- sapply(names(sblist), function(x) splitFct(sb= sblist[[x]], pattern="^ {4,4}- title: \\w{1,}"), simplify=FALSE)
    if(is.null(sidebartitle)) {
        sidebartitle <- gsub("(^.*?) {1,}.*", "\\1", mymaindoctitle)
    } else {
        sidebartitle <- sidebartitle
    }
    sidebartitle <- gsub("(^ {1,})|( {1,}$)", "", sidebartitle)
    sblist <- sblist[!names(sblist) %in% sidebartitle] # Removes existing section entry
    sblist <- c(header, sblist)        
    ## Construct new sidebar entries
    mytitles <- gsub("# {1,}", "", titles)
    mytitles <- paste0(1:length(mytitles), ". ", mytitles)
    myurls <- paste0("/mydoc/", basename(filenames))
    myurls <- gsub(".md$", ".html", myurls)
    sectionheader <- c(paste0("  - title: ", sidebartitle),
                       "    audience: writers, designers",
                       "    platform: all",
                       "    product: all",
                       "    version: all",
                       "    output: web, pdf",
                       "    items:",
                       "")
    subsections <- c("    - title: ",
                     "      url: ",
                     "      audience: writers, designers",
                     "      platform: all",
                     "      product: all",
                     "      version: all",
                     "      output: web",
                     "")
    subsectionlist <- lapply(seq_along(mytitles), function(x) subsections)
    for(i in seq_along(subsectionlist)) {
        subsectionlist[[i]][1] <- paste0(subsectionlist[[i]][1], mytitles[i])
        subsectionlist[[i]][2] <- paste0(subsectionlist[[i]][2], myurls[i])
    }
    names(subsectionlist) <- mytitles
    sectionlist <- list(c(list(header=sectionheader), subsectionlist))
    names(sectionlist) <- sidebartitle
    sblist <- c(sblist[1:(sidebarpos)], sectionlist, sblist[(sidebarpos+1):length(sblist)])
    sidebarfile <- paste0(sidebar_url_path, "/", "mydoc_sidebar.yml")
    sidebarfile <- gsub("/{1,}", "/", sidebarfile)
    writeLines(unlist(sblist), sidebarfile)
    cat(paste("Created file", sidebarfile), "\n")
    
    ## (9) Add new files to URL configuration file (_data/mydoc/mydoc_urls.yml)
    urls <- readLines("../../_data/mydoc/mydoc_urls.yml")
    splitFcturl <- function(url, pattern) {    
        splitpos <- grep(pattern, url)
        if(length(splitpos) != 0) {
            splitdist <- c(splitpos, length(url)+1) - c(1, splitpos) 
            urllist <- split(url, factor(rep(c(1, splitpos), splitdist)))
            mynames <- url[splitpos]
            mynames <- gsub(" {1,}", "_", mynames)
            mynames <- gsub(":", "", mynames)
            names(urllist) <- mynames
            return(urllist)
        } else {
            stop("mydoc_urls.yml is expected to contain at least one component.")
        }
    }
    ## Split on title lines
    urllist <- splitFcturl(url=urls, pattern="^\\w{1,}.*:")
    ## Construct new url entries
    mytitles <- gsub("# {1,}", "", titles)
    myurls <- paste0("../mydoc/", basename(filenames))
    myurls <- gsub(".md$", ".html", myurls)
    headerlines <- gsub("(^.*/)|(.html$)", "", myurls)
    urlentry <- c("",
                  "  title: ",
                  "  url: ",
                  "  link: ",
                  "")
    newurllist <- lapply(seq_along(mytitles), function(x) urlentry)
    for(i in seq_along(newurllist)) {
        newurllist[[i]][1] <- paste0(headerlines[i], ":")
        newurllist[[i]][2] <- paste0(newurllist[[i]][2], "\"", mytitles[i], "\"")
        newurllist[[i]][3] <- paste0(newurllist[[i]][3], "\"", myurls[i], "\"")
        newurllist[[i]][4] <- paste0(newurllist[[i]][4], "\"<a href='", myurls[i], "'>", mytitles[i], "</a>\"")
    }
    names(newurllist) <- headerlines
    urllist <- urllist[!names(urllist) %in% names(newurllist)] # Removes existing section entry
    urllist <- c(urllist, newurllist)
    urllist <- urllist[!duplicated(names(urllist))] # Removes duplicated entries
    urlfile <- paste0(sidebar_url_path, "/", "mydoc_urls.yml")
    urlfile <- gsub("/{1,}", "/", urlfile)
    writeLines(unlist(urllist), urlfile)
    cat(paste("Created file", urlfile), "\n")
}

## Usage:
# setwd("~/Dropbox/Websites/manuals/vignettes/Rbasics")
# source("../md2jekyll.R")
# md2Jekyll(mdfile="bioassayR.knit.md", sidebartitle=NULL, sidebarpos=12, outfilebasename=NULL, outpath="../../mydoc", sidebar_url_path="../../_data/mydoc/", fenced2highlight=TRUE, image_dir=NULL)

## Run from command-line with arguments
myargs <- commandArgs()
md2Jekyll(mdfile=myargs[6], sidebartitle=NULL, sidebarpos=as.numeric(myargs[7]), outfilebasename=NULL, outpath="../../mydoc", sidebar_url_path="../../_data/mydoc/", fenced2highlight=TRUE, image_dir=NULL)
# $ Rscript ../md2jekyll.R bioassayR.knit.md NULL 8

