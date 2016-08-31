\name{my.par}
\alias{my.par}
\title{Set nicer default par()}
\usage{
  my.par(mar = c(3, 3, 2, 1), mgp = c(2, 0.7, 0),
    tck = -0.01, ...)
}
\arguments{
  \item{mar}{plot margins, c(bottom, left, top, right)}

  \item{mgp}{margin line (in mex units) for the axis title
  axis labels and axis line.}

  \item{tck}{length of tick marks}
  \item{\dots}{other arguments to \code{par}}
}
\value{
  the old \code{par()} settings, invisibly
}
\description{
  Set nicer default par()
}

