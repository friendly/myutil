#' Source all R files in a given directory

#' Source all R files in a given directory into the current R session. 
#' Typically used to test some changes in a package without NAMESPACE issues.

#' @param path  path to a directory of R files
#' @param pattern filename pattern to source
#' @param trace  list file names as sourced
#' @param ... other arguments passed to \code{source}
#' @source This comes from \url{https://github.com/geneorama/geneorama/blob/master/R/sourceDir.R}
#' @export
#' 


sourceDir <-
  function(path, pattern="\\.[Rr]$", trace = TRUE, ...) {
    ### for (nm in list.files(path, pattern = "\\.[RrSsQq]$")) {
    for (nm in list.files(path, pattern = pattern)) {
      if(trace) cat(nm,":")
      source(file.path(path, nm), ...)
      if(trace) cat("\n")
    }
  }
