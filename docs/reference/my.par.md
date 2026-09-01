# Set nicer default par()

Set nicer default par()

## Usage

``` r
my.par(mar = c(3, 3, 2, 1), mgp = c(2, 0.7, 0), tck = -0.01, ...)
```

## Arguments

- mar:

  plot margins, c(bottom, left, top, right)

- mgp:

  margin line (in mex units) for the axis title axis labels and axis
  line.

- tck:

  length of tick marks

- ...:

  other arguments passed to `par`

## Value

the old [`par()`](https://rdrr.io/r/graphics/par.html) settings,
invisibly
