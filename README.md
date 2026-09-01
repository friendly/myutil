myutil
======

My utility functions for R, collected here instead of being duplicated
across packages and scripts. Originally just startup conveniences for
Rgui under Windows (loaded from `.Rprofile`), it now also holds heavier,
interactively-called helpers -- those aren't meant to run at startup, just
to live in one place instead of being copy-pasted per package.

## Session & directory

- `setwd()` -- replacement for base `setwd()` that also updates the Rgui
  window title
- `cd()` -- shorthand for `setwd()`; remembers the previous directory, so
  `cd()` with no argument acts like `cd -` on Unix
- `short.path()` -- shortened display form of a path (last N components)
- `dropbox_folder()` -- locate the local Dropbox folder on Windows

## Package installation & updates

- `update_github()` -- update all locally installed GitHub packages
- `save_installed_pkgs()` -- save the names of installed (non-base)
  packages to a file, before upgrading R
- `restore_installed_pkgs()` -- reinstall packages from a file saved by
  `save_installed_pkgs()`, after upgrading R
- `update_pkgs()` -- update all installed CRAN + Bioconductor packages in
  one non-interactive run, with logging and lock-retry handling; meant to
  be run in the background (e.g. `Rscript -e "myutil::update_pkgs()"`)
  rather than RStudio's own (blocking) package updater

## Package release / CRAN checks

A set of composable steps for the CRAN release process, meant to be run
from the root of the package being released (not from myutil). Run them
individually, or via `release_run_all()`.

- `release_preflight()` -- cross-check DESCRIPTION Version/Date against
  NEWS.md and CRAN
- `release_document()` -- rebuild documentation (`devtools::document()`)
- `release_spelling()` / `release_spelling_add()` -- spell-check, and
  selectively add accepted words to `inst/WORDLIST`
- `release_urls()` -- check documentation URLs
- `release_site()` -- rebuild README and pkgdown site
- `release_build()` -- build tarball, vignettes, and manual
- `release_check()` -- run `R CMD check --as-cran` locally
- `release_check_win()` -- check on win-builder (R-devel)
- `release_revdep()` -- check reverse dependencies
- `release_cran_comments()` -- regenerate `cran-comments.md` from the
  results of the steps above
- `release_run_all()` -- run the automatable steps in sequence, collecting
  failures instead of stopping at the first one

## Documentation helpers

- `man()` -- open a package's PDF manual (from CRAN, or built locally)
- `use_data_doc()` -- generate a roxygen documentation shell for a
  dataset
- `sourceDir()` -- source all R files in a directory, e.g. to try out
  in-progress package changes without reinstalling
- `Rpackages.bib()` -- write a BibTeX file of citations for installed
  packages, an R project's dependencies (via `renv::dependencies()`), or
  attached packages

## Graphics

- `eps()` -- `postscript()` wrapper with sensible defaults for EPS files
- `my.par()` -- `par()` wrapper with nicer default margins/ticks
- `reset_par()` -- default `par()` values as a named list; `par(reset_par())`
  resets a device without `dev.off()`'s side effects
- `rgb2col()` -- find the named R color closest to a given hex RGB color
- `magick_collage()` -- arrange a folder (or list) of PNG/JPEG images into
  a single montage image

## Workspace inspection

- `ls.objects()` -- like `ls()`, with each object's type, size, and
  dimensions
