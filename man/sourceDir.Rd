% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sourceDir.R
\name{sourceDir}
\alias{sourceDir}
\title{Source all R files in a given directory
Source all R files in a given directory into the current R session. 
Typically used to test some changes in a package without NAMESPACE issues.}
\source{
This comes from \url{https://github.com/geneorama/geneorama/blob/master/R/sourceDir.R}
}
\usage{
sourceDir(path, pattern = "\\\\.[Rr]$", trace = TRUE, ...)
}
\arguments{
\item{path}{path to a directory of R files}

\item{pattern}{filename pattern to source}

\item{trace}{list file names as sourced}

\item{...}{other arguments passed to \code{source}}
}
\description{
Source all R files in a given directory
Source all R files in a given directory into the current R session. 
Typically used to test some changes in a package without NAMESPACE issues.
}
