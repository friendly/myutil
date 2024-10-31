# now a GitHub gist: https://gist.github.com/friendly/14f3ee1464213bb0b9fbcb489468383b
# fixed: NULL labels error

#' Generate Outline Documentation for a Data Set in Roxygen Format
#' 
#' Generates a shell of documentation for a data set or other object in roxygen format.
#' This function was created by editing \code{\link[utils]{promptData}} to replace
#' the old style \code{.Rd} formatting with code suitable for processing with \code{\link[devtools]{document}}.
#' 
#' @details
#' Unless \code{filename} is \code{NA}, a documentation shell for \code{object} is written in roxygen format to the file specified 
#' by \code{filename}, and a message about this is given.
#' 
#' If \code{filename} is \code{NA}, a list-style representation of the documentation shell is created 
#' and returned. Writing the shell to a file amounts to \code{cat(unlist(x), file = filename, sep = "\n")}, 
#' where \code{x} is the list-style representation.
#' 
#' Currently, only data frames are handled explicitly by the code.
#'
#' @param object   an R object to be documented as a data set
#' @param filename usually, a \code{connection} or a character string giving the name of the file 
#'        to which the documentation shell should be written. The default corresponds to a file 
#'        whose name is \code{name} followed by \code{".R"}. Can also be \code{NA} (see details below).
#' @param name a character string specifying the name of the object. Defaults to the name of \code{object}.
#' @param labels a character vector of variable labels or strings describing each column in the data set.
#'
#' @return If \code{filename} is \code{NA}, a list-style representation of the documentation shell. 
#'        Otherwise, the name of the file written to is returned invisibly.
#' @seealso \code{\link[utils]{promptData}}
#' @author Michael Friendly
#' @export
#'
#' @examples
#' \dontrun{
#' use_data_doc(iris)
#' unlink("iris.R")
#' 
#' # using variable labels
#' labels <- c("Sepal length (mm)", "Sepal width (mm)", "Petal length (mm)", "Petal width (mm)", "Iris species" )
#' # console output
#' zz <- use_data_doc(iris, filename=NA, labels=labels)
#' cat(unlist(zz), sep="\n")
#' }
#' 
use_data_doc <- function (object, 
                          filename = NULL, 
                          name = NULL,
                          labels = NULL)
{
    if (missing(name)) 
        name <- if (is.character(object)) 
            object
        else {
            name <- substitute(object)
            if (is.name(name)) 
                as.character(name)
            else stop("cannot determine a usable name")
        }
    if (is.null(filename)) 
        filename <- paste0(name, ".R")
    x <- if (!missing(object)) 
        object
    else {
        x <- get(name, envir = parent.frame())
    }

    if (is.data.frame(x)) {
        make_item_tag <- function(s) {
            if (grepl("^([[:alpha:]]|[.][[:alpha:]._])[[:alnum:]._]*$", 
                s)) {
                paste0("\\code{", s, "}")
            }
            else {
                paste0("\\samp{", gsub("([%{}])", "\\\\\\1", 
                  s), "}")
            }
        }

        if (!is.null(labels)) {
          if(length(labels) < ncol(x))
            nl <- length(labels)
            labels <- c(labels, rep("", out.length = ncol(x) - length(labels)))
          #  warning(paste0("There are ", ncol(x), " variables but only ", nl, " labels were supplied."))
        }
        else labels <- sapply(object, class)
        
        fmt <- c("#' @format", paste("#'  A data frame with", nrow(x), 
            "observations on the following", ifelse(ncol(x) == 
                1, "variable.", paste(ncol(x), "variables."))), 
            "#'  \\describe{")
        j <- 0
        for (i in names(x)) {
            j <- j+1
            xi <- x[[i]]
            fmt <- c(fmt, paste0("#'    \\item{", make_item_tag(i), 
                "}{", 
                if(!is.na(labels[j]) & nchar(labels[j])>0) paste0(labels[j], ", "),
                if (inherits(xi, "ordered")) {
                  paste("an", data.class(xi), "factor with levels", 
                    paste0("\\code{", levels(xi), "}", collapse = " < "), 
                    collapse = " ")
                } else if (inherits(xi, "factor")) {
                  paste("a factor with levels", paste0("\\code{", 
                    levels(xi), "}", collapse = " "), collapse = " ")
                } else if (is.vector(xi)) {
                  paste("a", data.class(xi), "vector")
                } else if (is.matrix(xi)) {
                  paste("a matrix with", ncol(xi), "columns")
                } else {
                  paste("a", data.class(xi))
                }, "}"))
        }
        fmt <- c(fmt, "#'  }\n#'")
    }
    else {
        tf <- tempfile()
        on.exit(unlink(tf))
        sink(tf)
        str(object)
        sink()
        fmt <- c("#' @format", "  The format is:", scan(tf, "", 
            quiet = !getOption("verbose"), sep = "\n"))
    }

    Rdtxt <- list(
      name = paste0("#' @name ", name), 
      aliases = paste0("#' @aliases ",  name), 
      docType = "#' @docType data", 
      title = "#' @title\n#' %%   ~~ data name/kind ... ~~\n#'", 
      description = c("#' @description", "#' %%  ~~ A concise (1-5 lines) description of the dataset. ~~\n#'"), 
      usage = paste0("#' @usage data(\"", name, "\")"), 
      format = fmt, 
      details = c("#' @details ", paste("#' %%  ~~ If necessary, more details than the", "__description__ above ~~")), 
      source = c("#' @source ", paste("#' %%  ~~ reference to a publication or URL", "from which the data were obtained ~~")), 
      references = c("#' @references", "#' %%  ~~ possibly secondary sources and usages ~~\n#'"), 
      concepts = "#' @concept %% non-keyword concepts, one per line",
      examples = c("#' @examples", paste0("#' data(", name, ")"), paste0("#' ## maybe str(", name, ") ; plot(", name, ") ...\n#'")), 
      keywords = "#' @keywords datasets\nNULL"
      )

    if (is.na(filename)) 
        return(Rdtxt)
    cat(unlist(Rdtxt), file = filename, sep = "\n")
    message(gettextf("Created file named %s.", sQuote(filename)), 
        "\n", gettext("Edit the file and move it to the appropriate directory."), 
        domain = NA)
    invisible(filename)
}
