# Find and display documentation for a package Opens the CRAN documentation for a package or builds it from the local R library

Find and display documentation for a package Opens the CRAN
documentation for a package or builds it from the local R library

## Usage

``` r
man(package, method = c("system", "web"))
```

## Arguments

- package:

  name of a package, with or without quotes

- method:

  either `"web"` or `"system"`. `"web"` uses the manual from CRAN.
  `"system"` builds the documentation from your local R version.
