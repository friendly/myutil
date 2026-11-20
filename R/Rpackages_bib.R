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
#' `citation("MASS")`, a book citation). That step has been removed.
#'
#' What remains is a narrow gap: `citation()` only auto-fills the CRAN DOI when a package has
#' *no* `inst/CITATION`. Many packages' own CITATION files contain a `Manual` entry for the
#' package itself but omit the DOI (e.g. `cluster`, `survival`, `knitr`, `psych`). With
#' `add.pkg.doi = TRUE` (the default) the DOI `10.32614/CRAN.package.<pkg>` is added to such an
#' entry, but only when all of the following hold:
#'
#' - the entry has no DOI already (existing DOIs are never changed);
#' - its BibTeX type is `Manual` (never `Book`, `Article`, etc.);
#' - the installed package's DESCRIPTION says `Repository: CRAN` (so GitHub, r-universe,
#'   Bioconductor and locally built packages are left alone);
#' - the entry is recognizably the package's own manual: its title starts with the package
#'   name, or names it as an R package, or its URL is the package's CRAN page and its note
#'   says "R package"; and it is not a vignette, guide or tutorial.
#'
#' This deliberately rejects e.g. `mlbench`'s entry for the UCI repository, `nloptr`'s entry
#' for the NLopt C library, and `VGAMdata`'s entry citing `VGAM`.
#'
#' @param packages One of `c("installed", "dependencies", "attached")` or a character vector
#'   of package names.
#' @param filename Name of the output file, including the `.bib` extension. Defaults to the
#'   master-bib location this is normally saved to, under a version-specific filename.
#' @param key.prefix Character string to prefix to the package name to form the BibTeX key
#' @param header logical; if `TRUE`, include a header of LaTeX comments in the output file
#' @param preamble A character string consisting of a preamble for the BibTeX file
#' @param suppress.warnings logical; suppress warnings from `citation()`
#' @param add.pkg.doi logical; add the CRAN package DOI to `Manual` entries for CRAN packages
#'   whose own `inst/CITATION` omits it? See Details for the safeguards.
#' @param verbose logical; print messages to the console?
#'
#' @return Returns invisibly an object of class `"bibentry"`
#' @export
#' @importFrom utils citation toLatex sessionInfo toBibtex
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
    add.pkg.doi = TRUE,
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

  ## exclude those with errors. inherits(), not class(x) == "try-error": citation()'s
  ## return value carries class c("citation", "bibentry") (not a bare "bibentry"), which
  ## made sapply(bibs, class) return a 2xN matrix instead of a length-N vector, silently
  ## double-counting successes and mis-sizing the key vector built below.
  ok <- !vapply(bibs, inherits, logical(1), what = "try-error")
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

  ## citation() already supplies the correct DOI for auto-generated entries and for whatever
  ## an inst/CITATION file specifies. Optionally fill in the CRAN package DOI, but ONLY on
  ## entries that are demonstrably the package's own manual -- see .is_pkg_manual() and
  ## @details. Never overwrite an existing DOI.
  if (add.pkg.doi) {
    bibpkg <- rep(pkgs, nref)
    ip <- installed.packages(fields = "Repository")
    cran <- rownames(ip)[!is.na(ip[, "Repository"]) & ip[, "Repository"] == "CRAN"]
    dois <- bibs$doi
    added <- character(0)
    for (i in seq_along(bibs)) {
      p <- bibpkg[i]
      if (!is.null(dois[[i]]) || !(p %in% cran)) next
      if (!.is_pkg_manual(bibs[i], p)) next
      dois[[i]] <- paste0("10.32614/CRAN.package.", p)
      added <- c(added, bibs$key[[i]])
    }
    if (length(added)) bibs$doi <- dois
    if (verbose) cat("Added CRAN package DOIs to", length(added), "@Manual entries",
                     if (length(added)) paste0(":\n  ", paste(added, collapse = ", ")), "\n")
  }

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

## Is bibentry `e` (length 1) the @Manual entry for package `pkg` itself, as opposed to a
## vignette, the manual of some other software, or another package's manual? Deliberately
## conservative: a false negative just leaves a DOI out, a false positive fabricates one.
.is_pkg_manual <- function(e, pkg) {
  if (tolower(attr(unclass(e)[[1]], "bibtype")) != "manual") return(FALSE)
  clean <- function(x) {
    x <- paste(x, collapse = " ")
    x <- gsub("\\\\[A-Za-z]+", " ", x)          # drop LaTeX commands like \texttt
    x <- gsub("[{}'\"`]", "", x)                # braces and quotes
    trimws(gsub("[[:space:]]+", " ", x))
  }
  title <- clean(e$title)
  note  <- clean(e$note)
  url   <- paste(e$url, collapse = " ")
  # vignettes / tutorials / guides are documents *about* the package, not the package
  if (grepl("vignette", paste(title, note), ignore.case = TRUE) ||
      grepl("^(an? |the )?(guide|introduc|tutorial)|\\b(examples|tutorial)$", title,
            ignore.case = TRUE, perl = TRUE))
    return(FALSE)
  p <- gsub(".", "\\.", pkg, fixed = TRUE)
  word <- paste0("(^|[^A-Za-z0-9.])", p, "([^A-Za-z0-9.]|$)")
  # (a) title starts with the package name: "pkg: Title", "pkg---Title"
  if (grepl(paste0("^", p, "([^A-Za-z0-9.]|$)"), title, ignore.case = TRUE)) return(TRUE)
  # (b) title names it as an R package: "R package 'corrplot': ...", "The R package sm: ..."
  if (grepl("package", title, ignore.case = TRUE) && grepl(word, title)) return(TRUE)
  # (c) the URL is this package's CRAN page and the note says it is an R package
  if (grepl(paste0("package=", p, "([^A-Za-z0-9.]|$)"), url) &&
      grepl("R package", note, ignore.case = TRUE)) return(TRUE)
  FALSE
}
