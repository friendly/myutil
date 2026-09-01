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
