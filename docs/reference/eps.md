# Specialized version of postscript for eps files `eps` simply calls `postscript` with sensible defaults

Specialized version of postscript for eps files `eps` simply calls
`postscript` with sensible defaults

## Usage

``` r
eps(
  file = "Rplot.eps",
  horizontal = FALSE,
  paper = "special",
  height = 6,
  width = 6,
  ...
)
```

## Arguments

- file:

  a character string giving the name of the file.

- horizontal:

  the orientation of the printed image, a logical.

- paper:

  the size of paper in the printer.

- height, width:

  height and width of eps graphic

- ...:

  other arguments passed down
