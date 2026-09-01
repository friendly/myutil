# Cross-check a package's DESCRIPTION Version/Date against NEWS.md and CRAN

Run from the root of the package being released (not from myutil).

## Usage

``` r
release_preflight()
```

## Value

invisibly, a list with `package`, `version`, `date`, `cran_version`
