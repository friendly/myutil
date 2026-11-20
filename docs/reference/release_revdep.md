# Check a package's reverse dependencies

One-time setup if `revdepcheck` isn't installed:
`remotes::install_github("r-lib/revdepcheck")`

## Usage

``` r
release_revdep(num_workers = 4)
```

## Arguments

- num_workers:

  number of parallel workers to use

## Value

invisible NULL

## See also

Other release checks:
[`release_build()`](https://friendly.github.io/myutil/reference/release_build.md),
[`release_check()`](https://friendly.github.io/myutil/reference/release_check.md),
[`release_check_win()`](https://friendly.github.io/myutil/reference/release_check_win.md),
[`release_checks`](https://friendly.github.io/myutil/reference/release_checks.md),
[`release_cran_comments()`](https://friendly.github.io/myutil/reference/release_cran_comments.md),
[`release_document()`](https://friendly.github.io/myutil/reference/release_document.md),
[`release_preflight()`](https://friendly.github.io/myutil/reference/release_preflight.md),
[`release_run_all()`](https://friendly.github.io/myutil/reference/release_run_all.md),
[`release_site()`](https://friendly.github.io/myutil/reference/release_site.md),
[`release_spelling()`](https://friendly.github.io/myutil/reference/release_spelling.md),
[`release_spelling_add()`](https://friendly.github.io/myutil/reference/release_spelling_add.md),
[`release_urls()`](https://friendly.github.io/myutil/reference/release_urls.md)
