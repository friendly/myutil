# Installed packages with newer versions available

Unlike
[`utils::old.packages()`](https://rdrr.io/r/utils/update.packages.html),
lists only the packages whose *version* on the repository is newer than
the installed one.
[`old.packages()`](https://rdrr.io/r/utils/update.packages.html) can
also flag hundreds of packages whose version hasn't changed, e.g. right
after an R upgrade or when CRAN rebuilds its binaries, and
[`update.packages()`](https://rdrr.io/r/utils/update.packages.html) then
reinstalls them all for nothing.

## Usage

``` r
outdated_pkgs(repos = getOption("repos"), lib.loc = NULL)
```

## Arguments

- repos:

  repositories to compare with; default: `getOption("repos")`, or the
  cloud CRAN mirror if none is set

- lib.loc:

  libraries to check; default: all of
  [`.libPaths()`](https://rdrr.io/r/base/libPaths.html)

## Value

A data frame with columns `Package`, `Installed`, `Available` (newest
version, any type), `binary` (newest binary version; `NA` on Linux),
`source_only` and `LibPath`.

## Details

On Windows and macOS, a new version is often on CRAN as source for a day
or two before the binary is built; the `binary` column shows the newest
binary version, and `source_only` marks packages for which only the
source is newer (these need compiling if installed now).

## See also

[`update_pkgs()`](https://friendly.github.io/myutil/reference/update_pkgs.md),
[`upgrade_r_library()`](https://friendly.github.io/myutil/reference/upgrade_r_library.md)

## Examples

``` r
if (FALSE) { # \dontrun{
op <- outdated_pkgs()
op
# install the ones with binaries now; leave the rest for a few days
install.packages(op$Package[!op$source_only])
} # }
```
