# Save names of installed packages

Saves the names of currently installed (non-base) packages to a file, so
they can be reinstalled later with
[`restore_installed_pkgs()`](https://friendly.github.io/myutil/reference/restore_installed_pkgs.md)
– typically run just before upgrading to a new R version.

## Usage

``` r
save_installed_pkgs(
  file = file.path(tools::R_user_dir("myutil", "data"), "installed_pkgs.rda")
)
```

## Arguments

- file:

  path to save the package list to. Defaults to a location under
  [`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html) that
  survives an R version upgrade.

## Value

the character vector of package names, invisibly

## Details

Since myutil 1.10.0 the file also holds `pkginfo`, the output of
[`installed_pkg_sources()`](https://friendly.github.io/myutil/reference/installed_pkg_sources.md),
recording where each package came from (CRAN, GitHub, r-universe, ...),
so that
[`restore_installed_pkgs()`](https://friendly.github.io/myutil/reference/restore_installed_pkgs.md)
can reinstall packages that are not on CRAN too. For a patch upgrade of
R (e.g., 4.6.1 to 4.6.2),
[`upgrade_r_library()`](https://friendly.github.io/myutil/reference/upgrade_r_library.md)
is simpler: it copies the packages directly.

## See also

[`restore_installed_pkgs()`](https://friendly.github.io/myutil/reference/restore_installed_pkgs.md),
[`upgrade_r_library()`](https://friendly.github.io/myutil/reference/upgrade_r_library.md)

## Examples

``` r
if (FALSE) { # \dontrun{
save_installed_pkgs()
} # }
```
