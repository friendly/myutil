# Create a BibTeX file for all installed packages or package dependencies of an R project

Creates a BibTeX file for all packages referred to by the `packages`
argument. This can be:

## Usage

``` r
Rpackages.bib(
  packages = c("installed", "dependencies", "attached"),
  filename = file.path("C:/Dropbox/localtexmf/bibtex/bib", paste0("Rpackages-",
    getRversion(), ".bib")),
  key.prefix = "R-",
  header = TRUE,
  preamble = NULL,
  suppress.warnings = TRUE,
  verbose = TRUE
)
```

## Arguments

- packages:

  One of `c("installed", "dependencies", "attached")` or a character
  vector of package names.

- filename:

  Name of the output file, including the `.bib` extension. Defaults to
  the master-bib location this is normally saved to, under a
  version-specific filename.

- key.prefix:

  Character string to prefix to the package name to form the BibTeX key

- header:

  logical; if `TRUE`, include a header of LaTeX comments in the output
  file

- preamble:

  A character string consisting of a preamble for the BibTeX file

- suppress.warnings:

  logical; suppress warnings from
  [`citation()`](https://rdrr.io/r/utils/citation.html)

- verbose:

  logical; print messages to the console?

## Value

Returns invisibly an object of class `"bibentry"`

## Details

- all packages installed in R library trees (`packages = "installed"`),
  or

- all package dependencies (`packages = "dependencies"`) of an R
  project, as found by
  [`renv::dependencies()`](https://rstudio.github.io/renv/reference/dependencies.html),
  or

- packages attached (`packages = "attached"`) in an R session, or

- a character vector of package names.

Package dependencies, as found by
[`renv::dependencies()`](https://rstudio.github.io/renv/reference/dependencies.html),
crawls through files within your project, looking for R files and the
packages used within those R files. This is done primarily by parsing
the code and looking for calls of the form
[`library(package)`](https://rdrr.io/r/base/library.html),
[`require(package)`](https://rdrr.io/r/base/library.html),
[`requireNamespace("package")`](https://rdrr.io/r/base/ns-load.html),
and `package::method()`.

The BibTeX entry for a package, `"apackage"`, is discovered by
`citation("apackage")`, but these can be of different types, and a
package citation can consist of more than one BibTeX item.

Most R packages have a
[`citation()`](https://rdrr.io/r/utils/citation.html) of BibTeX type
`Manual`, pointing to a published CRAN version of the package. For
example, `citation("abind")` gives

      @Manual{,
         title = {abind: Combine Multidimensional Arrays},
         author = {Tony Plate and Richard Heiberger},
         year = {2024},
         note = {R package version 1.4-8},
         url = {https://CRAN.R-project.org/package=abind},
         doi = {10.32614/CRAN.package.abind},
         }

The `doi` field above (`10.32614/CRAN.package.abind`) is filled in
automatically by [`citation()`](https://rdrr.io/r/utils/citation.html)
itself, as of R 4.x – see the `auto` argument of
[`utils::citation`](https://rdrr.io/r/utils/citation.html). Bioconductor
packages get an analogous auto-filled `10.18129/B9.bioc.*` DOI.

However, a package can have an `inst/CITATION` file with one or more
[`bibentry()`](https://rdrr.io/r/utils/bibentry.html) calls, pointing
the citation at books, articles, or other publications describing the
package instead – these can carry their own DOI, unrelated to the
package's own CRAN DOI, or none at all. This function used to add a DOI
itself, stamping the same CRAN-package DOI onto *every* bibentry of
*every* package regardless of type. That both clobbered legitimate,
different DOIs already present on `Book`/`Article`-type citations (e.g.
`citation("sf")` has two entries, each with its own real DOI – a book
DOI and an R Journal article DOI – neither of which is a CRAN package
DOI) and fabricated one for packages with no DOI at all (e.g.
`citation("MASS")`, a book citation). That step has been removed;
[`citation()`](https://rdrr.io/r/utils/citation.html)'s own output is
used as-is.

## Examples

``` r
if (FALSE) { # \dontrun{
Rpackages.bib()  # all installed packages, written to the usual localtexmf location
} # }
```
