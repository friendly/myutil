# Carry an R package library over to a new version of R

Run this from the **new** R, right after installing it, to bring over
the packages installed under an older R.

## Usage

``` r
upgrade_r_library(
  from,
  to = .libPaths()[1],
  method = c("auto", "copy", "reinstall"),
  check = TRUE,
  dry_run = FALSE
)
```

## Arguments

- from:

  the old R installation (e.g., `"C:/R/R-4.6.1"`) or one of its package
  libraries

- to:

  the library to put the packages in; default: the first of
  [`.libPaths()`](https://rdrr.io/r/base/libPaths.html)

- method:

  `"auto"` (copy for a patch upgrade, otherwise reinstall), `"copy"` or
  `"reinstall"`

- check:

  test-load the packages brought over?

- dry_run:

  if `TRUE`, only report what would be done

## Value

A data frame, invisibly: the output of
[`installed_pkg_sources()`](https://friendly.github.io/myutil/reference/installed_pkg_sources.md)
for the old library, with columns `action` (what was done) and `problem`
(why a package failed to install or load, if it did).

## Details

- For a patch upgrade (same `x.y`, e.g. 4.6.1 to 4.6.2), the package
  folders are simply **copied**: packages built for one `x.y.*` release
  work in any other, so nothing needs to be downloaded or rebuilt, and
  packages from GitHub, r-universe, R-Forge or local files come along
  too.

- For a minor or major upgrade (e.g. 4.6 to 4.7), packages must be
  **reinstalled**. Each one is reinstalled from where it originally came
  from (see
  [`installed_pkg_sources()`](https://friendly.github.io/myutil/reference/installed_pkg_sources.md)):
  CRAN, another CRAN-like repository, R-Forge, Bioconductor or GitHub.
  Packages installed from local files are listed for you to reinstall by
  hand.

Either way, packages that the new R already has (its base and
recommended packages, or anything already installed) are left alone,
`translations` and packages built under R \< 4.0 are skipped, and with
`check = TRUE` the packages brought over are test-loaded in fresh R
processes, in batches (loading 1000 packages in one session runs into
the limit on loaded DLLs).

Close other R sessions using the *new* R first; sessions running the old
R don't matter. Afterwards,
[`outdated_pkgs()`](https://friendly.github.io/myutil/reference/outdated_pkgs.md)
lists the packages with newer versions on CRAN.

## See also

[`installed_pkg_sources()`](https://friendly.github.io/myutil/reference/installed_pkg_sources.md),
[`outdated_pkgs()`](https://friendly.github.io/myutil/reference/outdated_pkgs.md),
[`update_pkgs()`](https://friendly.github.io/myutil/reference/update_pkgs.md),
[`save_installed_pkgs()`](https://friendly.github.io/myutil/reference/save_installed_pkgs.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# in the newly installed R 4.6.2:
res <- upgrade_r_library("C:/R/R-4.6.1", dry_run = TRUE)   # see the plan
res <- upgrade_r_library("C:/R/R-4.6.1")
subset(res, !is.na(problem))
} # }
```
