# Source all R files in a given directory Source all R files in a given directory into the current R session. Typically used to test some changes in a package without NAMESPACE issues.

Source all R files in a given directory Source all R files in a given
directory into the current R session. Typically used to test some
changes in a package without NAMESPACE issues.

## Usage

``` r
sourceDir(path, pattern = "\\.[Rr]$", trace = TRUE, ...)
```

## Source

This comes from
<https://github.com/geneorama/geneorama/blob/master/R/sourceDir.R>

## Arguments

- path:

  path to a directory of R files

- pattern:

  filename pattern to source

- trace:

  list file names as sourced

- ...:

  other arguments passed to `source`
