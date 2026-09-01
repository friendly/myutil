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

## See also

[`save_installed_pkgs()`](https://friendly.github.io/myutil/reference/save_installed_pkgs.md)

## Examples

``` r
if (FALSE) { # \dontrun{
restore_installed_pkgs()
} # }
```
