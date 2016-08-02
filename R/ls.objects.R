# from Rhelp, 8-2-2016, Peter Pikal
# Long time ago I (with some help from R help list) made following function, which is maybe less 
# comprehensive as ls.str but I find it quite handy.


#' ls with added information on objects
#' 
#' \code{ls} with added information on object Type, Size, Rows, and Columns
#'
#' @param pos position in the search list
#' @param pattern an optional regular expression. Only names matching pattern are returned.
#' @param order.by one of \code{"Type"}, \code{"Size"}, \code{"Rows"}, \code{"Columns"}
#'
#' @return a data frame, with columns Type, Size, Rows, Columns. Object names are the row names.

#' @export
#' @source Peter Pikal, from R-help 8-2-2016
#'
#' @examples
#' ls.objects()
#' ls.objects(pattern="*lm")
#' ls.objects(order.by="Type")

ls.objects <- function (pos = 1, pattern, order.by)
{
    napply <- function(names, fn) sapply(names, function(x) fn(get(x,
        pos = pos)))
    names <- ls(pos = pos, pattern = pattern)
    obj.class <- napply(names, function(x) as.character(class(x))[1])
    obj.mode <- napply(names, mode)
    obj.type <- ifelse(is.na(obj.class), obj.mode, obj.class)
    obj.size <- napply(names, object.size)
    obj.dim <- t(napply(names, function(x) as.numeric(dim(x))[1:2]))
    vec <- is.na(obj.dim)[, 1] & (obj.type != "function")
    obj.dim[vec, 1] <- napply(names, length)[vec]
    out <- data.frame(obj.type, obj.size, obj.dim)
    names(out) <- c("Type", "Size", "Rows", "Columns")
    if (!missing(order.by))
        out <- out[order(out[[order.by]]), ]
    out
}
