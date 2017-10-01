# my utility functions, to be loaded by .Rprofile

#' Set Working Directory and Display in Window Title

#' @param dir path to new directory
#' @export

#.lastdir <- getwd()
setwd <-
     function(dir) {
        .lastdir <<- base::setwd(dir)
        if (.Platform$GUI == "Rgui") {
	        utils::setWindowTitle( short.path(base::getwd()) )
        }
        .lastdir
     }

#' Shorthand for setwd, remembering previous directory

#' A setwd replacement, allowing \code{cd()} to be like \code{cd -} on unix (return to last dir)

#' @param dir path to new directory
#' @export

  cd <- function(dir) {
  	if(missing(dir)) dir <- .lastdir
    .lastdir <<- base::setwd(dir)
    if (.Platform$GUI == "Rgui") {
	    utils::setWindowTitle( short.path(base::getwd()) )
    }
  }
  

#' Return a shortened version of a path

#' @param len number of final path components to return
#' @param dir path to new directory
#' @export

  short.path <- function(dir, len=2) {
  	np <-length(parts <- unlist(strsplit(dir, '/')))
  	parts <-rev( rev(parts)[1:min(np,len)] )
  	dots <- ifelse (np>len, '...', '')
  	paste(dots,paste(parts, '/', sep='', collapse=''))
  }

#' ls with all.names=TRUE by default
#' 
#' @param ... args to \code{ls()}
#' @param all.names Show normally hidden names?


lsall  <-  function(..., all.names = TRUE) {
  ls(..., all.names = all.names, envir=parent.frame())
}

#' Specialized version of postscript for eps files

#' \code{eps} simply calls \code{postscript} with sensible defaults

#' @param file 	a character string giving the name of the file.
#' @param horizontal 	the orientation of the printed image, a logical. 
#' @param paper 	the size of paper in the printer.
#' @param height,width	height and width of eps graphic
#' @param ... other arguments passed down
#' @export


	eps <- function(file="Rplot.eps", horizontal=FALSE, paper="special", height=6, width=6, ...) {
	    postscript(file=file, onefile=FALSE, horizontal=horizontal, paper=paper, height=height, width=width,...)
	  }


#' Set nicer default par()
#' 
#' @param mar plot margins, c(bottom, left, top, right)
#' @param mgp margin line (in mex units) for the axis title axis labels and axis line.
#' @param tck length of tick marks
#' @param ... other arguments passed to \code{par}
#' @return the old \code{par()} settings, invisibly
#' @export

my.par <- function(mar=c(3,3,2,1), mgp=c(2,.7,0), tck=-.01, ...) {
  op <- par(mar=mar, mgp=mgp, tck=tck, ...)
  invisible(op)
}