# Reinstall packages from a saved list

Reinstalls packages previously saved by
[`save_installed_pkgs()`](https://friendly.github.io/myutil/reference/save_installed_pkgs.md)
– typically run after upgrading to a new R version, to restore the
packages that were installed under the old one.

## Usage

``` r
restore_installed_pkgs(
  file = file.path(tools::R_user_dir("myutil", "data"), "installed_pkgs.rda"),
  update = TRUE
)
```

## Arguments

- file:

  path the package list was saved to

- update:

  also call
  [`update.packages()`](https://rdrr.io/r/utils/update.packages.html)
  afterward?

## Value

the character vector of package names, invisibly

## Details

If the file was saved by myutil \>= 1.10.0, each package is reinstalled
from where it came from (see
[`installed_pkg_sources()`](https://friendly.github.io/myutil/reference/installed_pkg_sources.md));
packages already installed are skipped, and packages installed from
local files, built under R \< 4.0, or not installable (`translations`)
are listed instead. Files from older versions hold only package names,
which are installed from CRAN.

## See also

[`save_installed_pkgs()`](https://friendly.github.io/myutil/reference/save_installed_pkgs.md),
[`upgrade_r_library()`](https://friendly.github.io/myutil/reference/upgrade_r_library.md)

## Examples

``` r
if (FALSE) { # \dontrun{
restore_installed_pkgs()
} # }
```
