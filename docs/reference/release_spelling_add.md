# Add specific words to a package's `inst/WORDLIST`

Selective and additive, unlike
[`spelling::update_wordlist()`](https://docs.ropensci.org/spelling//reference/wordlist.html)
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
