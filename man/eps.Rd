% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/myutil.R
\name{eps}
\alias{eps}
\title{Specialized version of postscript for eps files
\code{eps} simply calls \code{postscript} with sensible defaults}
\usage{
eps(file = "Rplot.eps", horizontal = FALSE, paper = "special",
  height = 6, width = 6, ...)
}
\arguments{
\item{file}{a character string giving the name of the file.}

\item{horizontal}{the orientation of the printed image, a logical.}

\item{paper}{the size of paper in the printer.}

\item{height, width}{height and width of eps graphic}

\item{...}{other arguments passed down}
}
\description{
Specialized version of postscript for eps files
\code{eps} simply calls \code{postscript} with sensible defaults
}
