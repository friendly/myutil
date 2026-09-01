# Regenerate a package's `cran-comments.md`

Fills in R CMD check results (from
[`release_check()`](https://friendly.github.io/myutil/reference/release_check.md)'s
saved `.release_check_result.rds`), the reverse dependency summary (from
`revdep/cran.md`, written by
[`release_revdep()`](https://friendly.github.io/myutil/reference/release_revdep.md)),
and replaces the whole `## Comments` section with the NEWS.md entries
added since the version currently on CRAN – so it only describes what
changed since CRAN last saw this package, not the full changelog.

## Usage

``` r
release_cran_comments(known_issues = NULL)
```

## Arguments

- known_issues:

  Optional character vector of standing explanations to append as a "##
  Known issues" section – for things a remote check (win-builder, R-hub)
  flags but a local
  [`devtools::check()`](https://devtools.r-lib.org/reference/check.html)
  never sees, so they wouldn't otherwise show up here (e.g. URLs
  embedded in a static PDF vignette that local checks don't catch).
  `NULL` (default) omits the section.

## Value

invisibly, the written file's content

## Details

Run
[`release_check()`](https://friendly.github.io/myutil/reference/release_check.md)
and
[`release_revdep()`](https://friendly.github.io/myutil/reference/release_revdep.md)
first; this just assembles their output, it doesn't re-run either.
