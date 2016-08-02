\name{ls.objects}
\alias{ls.objects}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
\code{ls} with added information on object type
}
\description{
\code{ls} with added information on object Type, Size, Rows, and Columns
}
\usage{
ls.objects(pos = 1, pattern, order.by)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{pos}{
position in the search list
}
  \item{pattern}{
an optional regular expression. Only names matching pattern are returned.
}
  \item{order.by}{
one of \code{"Type"}, \code{"Size"}, \code{"Rows"}, \code{"Columns"}
}
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
a data frame, with columns Type, Size, Rows, Columns.
Object names are the row names.
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
%\references{
%% ~put references to the literature/web site here ~
%}
\author{
Peter Pikal, from R-help 8-2-2016
}
%\note{
%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link[base]{ls}}
}
\examples{
ls.objects()

ls.objects(pattern="*lm")

ls.objects(order.by="Type")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
