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
