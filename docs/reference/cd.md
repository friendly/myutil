# Shorthand for setwd, remembering previous directory A setwd replacement, allowing `cd()` to be like `cd -` on unix (return to last dir)

Shorthand for setwd, remembering previous directory A setwd replacement,
allowing `cd()` to be like `cd -` on unix (return to last dir)

## Usage

``` r
cd(dir)
```

## Arguments

- dir:

  path to new directory

## Examples

``` r
if (FALSE) { # \dontrun{
cd("~")     # go HOME
cd()        # return where we were
} # }
```
