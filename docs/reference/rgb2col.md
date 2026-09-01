# Find Named Color Closest to Given Hex RGB Colors This function calculates the distance (in CIE Lab color space) between the input colors (in RGB hex notation) and all named `colors()` It returns the closest named color within a given threshold distance.

Find Named Color Closest to Given Hex RGB Colors This function
calculates the distance (in CIE Lab color space) between the input
colors (in RGB hex notation) and all named
[`colors()`](https://rdrr.io/r/grDevices/colors.html) It returns the
closest named color within a given threshold distance.

## Usage

``` r
rgb2col(cols, near = 2.3)
```

## Source

From J. Fox, R-help, 5-30-2013

## Arguments

- cols:

  A vector of colors, in RGB hex notation, e.g., `"\#00AE30"`

- near:

  Threshold for nearest color from
  [`colors()`](https://rdrr.io/r/grDevices/colors.html). The default
  corresponds to 1 JND in Lab space.

## Value

    A vector of color names, or the hex value if no color is close enough

## Examples

``` r
cols <- c("#010101", "#EEEEEE", "#AA0000", "#00AA00", "#0000AA", "#AAAA00", "#AA00AA", "#00AAAA")
(nms <- rgb2col(cols))
#> [1] "black"         "gray93"        "firebrick3"    "limegreen"    
#> [5] "blue4"         "yellow4"       "darkmagenta"   "lightseagreen"
pie(rep(1, 2*length(cols)), labels=c(rbind(cols, nms)), col=c(rbind(cols, nms)))
```
