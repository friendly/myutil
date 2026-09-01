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

## See also

[`restore_installed_pkgs()`](https://friendly.github.io/myutil/reference/restore_installed_pkgs.md)

## Examples

``` r
if (FALSE) { # \dontrun{
save_installed_pkgs()
} # }
```
