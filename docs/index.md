# myutil

My utility functions for R, collected here instead of being duplicated
across packages and scripts. Originally just startup conveniences for
Rgui under Windows (loaded from `.Rprofile`), it now also holds heavier,
interactively-called helpers – those aren’t meant to run at startup,
just to live in one place instead of being copy-pasted per package.

## Session & directory

- [`setwd()`](https://friendly.github.io/myutil/reference/setwd.md) –
  replacement for base
  [`setwd()`](https://friendly.github.io/myutil/reference/setwd.md) that
  also updates the Rgui window title
- [`cd()`](https://friendly.github.io/myutil/reference/cd.md) –
  shorthand for
  [`setwd()`](https://friendly.github.io/myutil/reference/setwd.md);
  remembers the previous directory, so
  [`cd()`](https://friendly.github.io/myutil/reference/cd.md) with no
  argument acts like `cd -` on Unix
- [`short.path()`](https://friendly.github.io/myutil/reference/short.path.md)
  – shortened display form of a path (last N components)
- [`dropbox_folder()`](https://friendly.github.io/myutil/reference/dropbox_folder.md)
  – locate the local Dropbox folder on Windows

## Package installation & updates

- [`update_github()`](https://friendly.github.io/myutil/reference/update_github.md)
  – update all locally installed GitHub packages
- [`save_installed_pkgs()`](https://friendly.github.io/myutil/reference/save_installed_pkgs.md)
  – save the names of installed (non-base) packages to a file, before
  upgrading R
- [`restore_installed_pkgs()`](https://friendly.github.io/myutil/reference/restore_installed_pkgs.md)
  – reinstall packages from a file saved by
  [`save_installed_pkgs()`](https://friendly.github.io/myutil/reference/save_installed_pkgs.md),
  after upgrading R
- [`update_pkgs()`](https://friendly.github.io/myutil/reference/update_pkgs.md)
  – update all installed CRAN + Bioconductor packages in one
  non-interactive run, with logging and lock-retry handling; meant to be
  run in the background (e.g. `Rscript -e "myutil::update_pkgs()"`)
  rather than RStudio’s own (blocking) package updater

## Package release / CRAN checks

A set of composable steps for the CRAN release process, meant to be run
from the root of the package being released (not from myutil). Run them
individually, or via
[`release_run_all()`](https://friendly.github.io/myutil/reference/release_run_all.md).

- [`release_preflight()`](https://friendly.github.io/myutil/reference/release_preflight.md)
  – cross-check DESCRIPTION Version/Date against NEWS.md and CRAN
- [`release_document()`](https://friendly.github.io/myutil/reference/release_document.md)
  – rebuild documentation
  ([`devtools::document()`](https://devtools.r-lib.org/reference/document.html))
- [`release_spelling()`](https://friendly.github.io/myutil/reference/release_spelling.md)
  /
  [`release_spelling_add()`](https://friendly.github.io/myutil/reference/release_spelling_add.md)
  – spell-check, and selectively add accepted words to `inst/WORDLIST`
- [`release_urls()`](https://friendly.github.io/myutil/reference/release_urls.md)
  – check documentation URLs
- [`release_site()`](https://friendly.github.io/myutil/reference/release_site.md)
  – rebuild README and pkgdown site
- [`release_build()`](https://friendly.github.io/myutil/reference/release_build.md)
  – build tarball, vignettes, and manual
- [`release_check()`](https://friendly.github.io/myutil/reference/release_check.md)
  – run `R CMD check --as-cran` locally
- [`release_check_win()`](https://friendly.github.io/myutil/reference/release_check_win.md)
  – check on win-builder (R-devel)
- [`release_revdep()`](https://friendly.github.io/myutil/reference/release_revdep.md)
  – check reverse dependencies
- [`release_cran_comments()`](https://friendly.github.io/myutil/reference/release_cran_comments.md)
  – regenerate `cran-comments.md` from the results of the steps above
- [`release_run_all()`](https://friendly.github.io/myutil/reference/release_run_all.md)
  – run the automatable steps in sequence, collecting failures instead
  of stopping at the first one

## Documentation helpers

- [`man()`](https://friendly.github.io/myutil/reference/man.md) – open a
  package’s PDF manual (from CRAN, or built locally)
- [`use_data_doc()`](https://friendly.github.io/myutil/reference/use_data_doc.md)
  – generate a roxygen documentation shell for a dataset
- [`sourceDir()`](https://friendly.github.io/myutil/reference/sourceDir.md)
  – source all R files in a directory, e.g. to try out in-progress
  package changes without reinstalling
- [`Rpackages.bib()`](https://friendly.github.io/myutil/reference/Rpackages.bib.md)
  – write a BibTeX file of citations for installed packages, an R
  project’s dependencies (via
  [`renv::dependencies()`](https://rstudio.github.io/renv/reference/dependencies.html)),
  or attached packages

## Graphics

- [`eps()`](https://friendly.github.io/myutil/reference/eps.md) –
  [`postscript()`](https://rdrr.io/r/grDevices/postscript.html) wrapper
  with sensible defaults for EPS files
- [`my.par()`](https://friendly.github.io/myutil/reference/my.par.md) –
  [`par()`](https://rdrr.io/r/graphics/par.html) wrapper with nicer
  default margins/ticks
- [`reset_par()`](https://friendly.github.io/myutil/reference/reset_par.md)
  – default [`par()`](https://rdrr.io/r/graphics/par.html) values as a
  named list; `par(reset_par())` resets a device without
  [`dev.off()`](https://rdrr.io/r/grDevices/dev.html)’s side effects
- [`rgb2col()`](https://friendly.github.io/myutil/reference/rgb2col.md)
  – find the named R color closest to a given hex RGB color
- [`magick_collage()`](https://friendly.github.io/myutil/reference/magick_collage.md)
  – arrange a folder (or list) of PNG/JPEG images into a single montage
  image

## Workspace inspection

- [`ls.objects()`](https://friendly.github.io/myutil/reference/ls.objects.md)
  – like [`ls()`](https://rdrr.io/r/base/ls.html), with each object’s
  type, size, and dimensions
