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
