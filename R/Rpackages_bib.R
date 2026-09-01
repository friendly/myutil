# Ported from C:/Dropbox/R/bib-stuff/Rpackages.bib.R. Original code by Achim
# Zeileis, R-help, 2009-12-16; revised for R 2.14.0, R-devel, 2011-12-16;
# renv::dependencies()/attached options added later.

#' Create a BibTeX file for all installed packages or package dependencies of an R project
#'
#' Creates a BibTeX file for all packages referred to by the `packages` argument. This can be:
#'
#' - all packages installed in R library trees (`packages = "installed"`), or
#' - all package dependencies (`packages = "dependencies"`) of an R project, as found by
#'   [renv::dependencies()], or
#' - packages attached (`packages = "attached"`) in an R session, or
#' - a character vector of package names.
#'
#' @details
#' Package dependencies, as found by [renv::dependencies()], crawls through files within your
#' project, looking for R files and the packages used within those R files. This is done
#' primarily by parsing the code and looking for calls of the form `library(package)`,
#' `require(package)`, `requireNamespace("package")`, and `package::method()`.
#'
#' The BibTeX entry for a package, `"apackage"`, is discovered by `citation("apackage")`, but
#' these can be of different types, and a package citation can consist of more than one BibTeX
#' item.
#'
#' Most R packages have a `citation()` of BibTeX type `Manual`, pointing to a published CRAN
#' version of the package. For example, `citation("abind")` gives
#'
#' ```
#'   @Manual{,
#'      title = {abind: Combine Multidimensional Arrays},
#'      author = {Tony Plate and Richard Heiberger},
#'      year = {2024},
#'      note = {R package version 1.4-8},
#'      url = {https://CRAN.R-project.org/package=abind},
#'      doi = {10.32614/CRAN.package.abind},
#'      }
#' ```
#'
#' The `doi` field above (`10.32614/CRAN.package.abind`) is filled in automatically by
#' `citation()` itself, as of R 4.x -- see the `auto` argument of `utils::citation`. Bioconductor
#' packages get an analogous auto-filled `10.18129/B9.bioc.*` DOI.
#'
#' However, a package can have an `inst/CITATION` file with one or more `bibentry()` calls,
#' pointing the citation at books, articles, or other publications describing the package
#' instead -- these can carry their own DOI, unrelated to the package's own CRAN DOI, or none
#' at all. This function used to add a DOI itself, stamping the same CRAN-package DOI onto
#' *every* bibentry of *every* package regardless of type. That both clobbered legitimate,
#' different DOIs already present on `Book`/`Article`-type citations (e.g. `citation("sf")` has
#' two entries, each with its own real DOI -- a book DOI and an R Journal article DOI -- neither
#' of which is a CRAN package DOI) and fabricated one for packages with no DOI at all (e.g.
#' `citation("MASS")`, a book citation). That step has been removed; `citation()`'s own output
#' is used as-is.
#'
#' @param packages One of `c("installed", "dependencies", "attached")` or a character vector
#'   of package names.
#' @param filename Name of the output file, including the `.bib` extension. Defaults to the
#'   master-bib location this is normally saved to, under a version-specific filename.
#' @param key.prefix Character string to prefix to the package name to form the BibTeX key
#' @param header logical; if `TRUE`, include a header of LaTeX comments in the output file
#' @param preamble A character string consisting of a preamble for the BibTeX file
#' @param suppress.warnings logical; suppress warnings from `citation()`
#' @param verbose logical; print messages to the console?
#'
#' @return Returns invisibly an object of class `"bibentry"`
#' @export
#' @examples
#' \dontrun{
#' Rpackages.bib()  # all installed packages, written to the usual localtexmf location
#' }
Rpackages.bib <- function(
    packages = c("installed", "dependencies", "attached"),
    filename = file.path("C:/Dropbox/localtexmf/bibtex/bib", paste0("Rpackages-", getRversion(), ".bib")),
    key.prefix = "R-",
    header = TRUE,
    preamble = NULL,
    suppress.warnings = TRUE,
    verbose = TRUE)
{
  ## query packages and their bibentries
  if (missing(packages)) packages <- "installed"
  keywords <- c("installed", "dependencies", "attached")
  if (length(packages) == 1 && packages %in% keywords) {
    querry <- packages <- match.arg(packages, keywords)
    if (packages == "installed")
      pkgs <- unique(installed.packages()[,1])
    else if (packages == "dependencies") {
      if (!requireNamespace("renv", quietly = TRUE)) {
        stop("packages = \"dependencies\" requires the 'renv' package; install.packages(\"renv\")")
      }
      pkgs <- unique(renv::dependencies(quiet = TRUE)$Package)
    }
    else pkgs <- (.packages())
  } else {
    querry <- "custom package list"
    pkgs <- packages
  }

  if (length(pkgs) == 0)
    stop("No packages were found for specification '", packages, "'")

  if (verbose) cat("Searching citations for ", length(pkgs), "packages...\n")

  if (suppress.warnings) {
    warn <- options(warn = -1)
    on.exit(options(warn))
  }
  bibs <- lapply(pkgs, function(x) try(citation(x)))
  n.installed <- length(bibs)

  ## exclude those with errors
  ok <- !(sapply(bibs, class) == "try-error")
  pkgs <- pkgs[ok]
  bibs <- bibs[ok]
  n.converted <- sum(ok)

  ## number of bibentries per package
  nref <- sapply(bibs, length)
  ncit <- sum(nref)

  ## merge all bibentries
  bibs <- do.call("c", bibs)

  ## add citation keys; need to number those where there's more than one
  bibkeys <- lapply(1:length(nref), function(i)
    if (nref[i] > 1) paste(paste0(key.prefix, pkgs[i]), 1:nref[i], sep = "-") else
                     paste0(key.prefix, pkgs[i]))
  bibs$key <- as.list(unlist(bibkeys))

  ## DOIs are NOT added here -- citation() already supplies the correct one for each bibentry
  ## (a CRAN/Bioconductor package DOI for an auto-generated @Manual entry, whatever DOI the
  ## package's own inst/CITATION specifies for a Book/Article entry, or none at all). See
  ## @details above for why the previous version of this function, which stamped a CRAN-package
  ## DOI onto every entry uniformly, was actively wrong for non-Manual citations.

  # make page numbers proper: fix from (\d+)-(\d+) to $1--$2
  # this doesn't quite work-- it screws up the structure of the bibs object
#  for (i in 1:length(bibs)) {
#    if(!is.null(bibs[[i]]$pages)) {
#    	bibs[[i]]$pages <-  sub('(\\d+)-(\\d+)', '\\1--\\2', bibs[[i]]$pages)
#    	}
#    }

  if (header) {
    header <- gsub("^", "%", toLatex(sessionInfo()))
    header <- c(paste("%BibTeX file:", filename, "written", Sys.Date(), "by Rpackages.bib()\n"),
                paste("% packages argument:", querry, "\n"),
                header, "\n")
  }
  dir.create(dirname(filename), recursive = TRUE, showWarnings = FALSE)
  unlink(filename)
  output <- file(filename, "a")
  cat(header, preamble, sep = '\n', file = output, append = TRUE)
  writeLines(toBibtex(bibs), con = output)
  close(output)
  if (verbose) cat("Converted", n.converted, "citations in", n.installed,
    "packages to BibTeX, containing", ncit, "entries.",
    "\nResults written to file", filename, "\n")

  ## return Bibtex items invisibly
  invisible(bibs)
}
