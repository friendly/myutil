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

## See also

Other release checks:
[`release_build()`](https://friendly.github.io/myutil/reference/release_build.md),
[`release_check_win()`](https://friendly.github.io/myutil/reference/release_check_win.md),
[`release_checks`](https://friendly.github.io/myutil/reference/release_checks.md),
[`release_cran_comments()`](https://friendly.github.io/myutil/reference/release_cran_comments.md),
[`release_document()`](https://friendly.github.io/myutil/reference/release_document.md),
[`release_preflight()`](https://friendly.github.io/myutil/reference/release_preflight.md),
[`release_revdep()`](https://friendly.github.io/myutil/reference/release_revdep.md),
[`release_run_all()`](https://friendly.github.io/myutil/reference/release_run_all.md),
[`release_site()`](https://friendly.github.io/myutil/reference/release_site.md),
[`release_spelling()`](https://friendly.github.io/myutil/reference/release_spelling.md),
[`release_spelling_add()`](https://friendly.github.io/myutil/reference/release_spelling_add.md),
[`release_urls()`](https://friendly.github.io/myutil/reference/release_urls.md)
