#' Find and display documentation for a package

#' Opens the CRAN documentation for a package or builds it from the local R library

#' @param package  name of a package, with or without quotes
#' @param method	either \code{"web"} or \code{"system"}.  \code{"web"} uses the manual from CRAN.
#'                \code{"system"}  builds the documentation from your local R version.
#' @export
#' @importFrom utils browseURL

man <- function(package, method=c("system", "web")){
  
  LIB <- substitute(package)
  LIB <- as.character(LIB)
  method <- match.arg(method)
  
  switch(method,
         web = browseURL(paste("https://cran.r-project.org/web/packages/",LIB,"/",LIB,".pdf", sep = "")),
         system =  {unlink(paste(getwd(),"/",LIB,".pdf",sep=""))
           path <- find.package(LIB)
           system(paste(shQuote(file.path(R.home("bin"), "R")),"CMD", "Rd2pdf",shQuote(path)))})   
}

