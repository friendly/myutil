# Add specific words to a package's `inst/WORDLIST`

Selective and additive, unlike
[`spelling::update_wordlist()`](https://docs.ropensci.org/spelling/reference/wordlist.html)
(see
[`release_spelling()`](https://friendly.github.io/myutil/reference/release_spelling.md)).
Existing entries are kept; `words` is merged in, deduplicated, and
re-sorted.

## Usage

``` r
release_spelling_add(words)
```

## Arguments

- words:

  character vector of words to accept, e.g. copied from
  [`release_spelling()`](https://friendly.github.io/myutil/reference/release_spelling.md)'s
  printed output after reviewing which flagged words are genuine false
  positives (proper nouns, technical terms) rather than actual typos.

## Value

invisibly, the updated word list

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
[`release_run_all()`](https://friendly.github.io/myutil/reference/release_run_all.md),
[`release_site()`](https://friendly.github.io/myutil/reference/release_site.md),
[`release_spelling()`](https://friendly.github.io/myutil/reference/release_spelling.md),
[`release_urls()`](https://friendly.github.io/myutil/reference/release_urls.md)
