# Run every automatable release-check step in sequence

Does not call
[`release_check_win()`](https://friendly.github.io/myutil/reference/release_check_win.md)
or
[`release_revdep()`](https://friendly.github.io/myutil/reference/release_revdep.md)
by default – both are slow (win-builder is an external upload; revdep
checks every reverse dependency twice) and worth running deliberately
rather than as part of a routine re-run. Set `full = TRUE` to include
them.

## Usage

``` r
release_run_all(full = FALSE, num_workers = 4)
```

## Arguments

- full:

  also run
  [`release_check_win()`](https://friendly.github.io/myutil/reference/release_check_win.md),
  [`release_revdep()`](https://friendly.github.io/myutil/reference/release_revdep.md),
  and
  [`release_cran_comments()`](https://friendly.github.io/myutil/reference/release_cran_comments.md)?

- num_workers:

  passed to
  [`release_revdep()`](https://friendly.github.io/myutil/reference/release_revdep.md)
  when `full = TRUE`

## Value

invisibly, a list of any step failures

## Details

Each step runs even if an earlier one fails (e.g.
[`release_urls()`](https://friendly.github.io/myutil/reference/release_urls.md)
finding a dead link) – failures are collected and reported together at
the end instead of halting the sequence.

## See also

Other release checks:
[`release_build()`](https://friendly.github.io/myutil/reference/release_build.md),
[`release_check()`](https://friendly.github.io/myutil/reference/release_check.md),
[`release_check_win()`](https://friendly.github.io/myutil/reference/release_check_win.md),
[`release_checks`](https://friendly.github.io/myutil/reference/release_checks.md),
[`release_cran_comments()`](https://friendly.github.io/myutil/reference/release_cran_comments.md),
[`release_document()`](https://friendly.github.io/myutil/reference/release_document.md),
[`release_preflight()`](https://friendly.github.io/myutil/reference/release_preflight.md),
[`release_revdep()`](https://friendly.github.io/myutil/reference/release_revdep.md),
[`release_site()`](https://friendly.github.io/myutil/reference/release_site.md),
[`release_spelling()`](https://friendly.github.io/myutil/reference/release_spelling.md),
[`release_spelling_add()`](https://friendly.github.io/myutil/reference/release_spelling_add.md),
[`release_urls()`](https://friendly.github.io/myutil/reference/release_urls.md)
