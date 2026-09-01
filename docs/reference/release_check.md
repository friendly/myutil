# Run `R CMD check --as-cran` locally

Persists the result to `.release_check_result.rds` so
[`release_cran_comments()`](https://friendly.github.io/myutil/reference/release_cran_comments.md)
can build the "R CMD check results" section from real output instead of
you having to transcribe it by hand.

## Usage

``` r
release_check()
```

## Value

invisibly, the
[`devtools::check()`](https://devtools.r-lib.org/reference/check.html)
result
