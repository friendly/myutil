# Check a package's documentation URLs

One-time setup if `urlchecker` isn't installed:
`install.packages('urlchecker', repos = 'https://r-lib.r-universe.dev')`

## Usage

``` r
release_urls(update = FALSE)
```

## Arguments

- update:

  Rewrite URLs found to have moved? Default `FALSE`, same reasoning as
  [`release_spelling()`](https://friendly.github.io/myutil/reference/release_spelling.md).

## Value

invisible NULL
