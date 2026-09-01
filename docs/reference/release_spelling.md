# Spell-check a package

Spell-check a package

## Usage

``` r
release_spelling(update = FALSE)
```

## Arguments

- update:

  Replace `inst/WORDLIST` wholesale via
  [`spelling::update_wordlist()`](https://docs.ropensci.org/spelling//reference/wordlist.html)?
  Default `FALSE`, and deliberately hard to trigger by accident – see
  Details.

## Value

invisibly, the spelling check results

## Details

[`spelling::update_wordlist()`](https://docs.ropensci.org/spelling//reference/wordlist.html)
doesn't add *selected* words, it replaces the entire wordlist with
whatever `spell_check_package()` finds at that moment. Its confirmation
prompt only fires when
[`interactive()`](https://rdrr.io/r/base/interactive.html); in a
non-interactive run (e.g. inside
[`release_run_all()`](https://friendly.github.io/myutil/reference/release_run_all.md)
run in the background) that check is silently skipped, so it would
accept every flagged word – real typos included – with no confirmation
at all. Use
[`release_spelling_add()`](https://friendly.github.io/myutil/reference/release_spelling_add.md)
instead to add specific words you've actually reviewed.
