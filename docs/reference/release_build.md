# Build a package's tarball, vignettes, and manual

Build a package's tarball, vignettes, and manual

## Usage

``` r
release_build()
```

## Value

invisible NULL

## Details

[`devtools::build_vignettes()`](https://devtools.r-lib.org/reference/build_vignettes.html)
*moves* (rather than copies) any `vignettes/*.pdf.asis`-referenced PDF
into `doc/`, deleting it from `vignettes/` – the actual source location
for that vignette. We restore those from `doc/` afterward so
`vignettes/` never ends up missing a file.

## See also

Other release checks:
[`release_check()`](https://friendly.github.io/myutil/reference/release_check.md),
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
