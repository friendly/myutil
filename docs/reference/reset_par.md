# Reset graphics parameters to default values

Returns a named list of default
[`par()`](https://rdrr.io/r/graphics/par.html) values, snapshotted from
a fresh graphics device – pass it to
[`par()`](https://rdrr.io/r/graphics/par.html) to actually reset the
current device, e.g. `par(reset_par())`. Useful after a plotting
function leaves [`par()`](https://rdrr.io/r/graphics/par.html) in a
state you don't want to keep (e.g. `mfrow`, margins), without the side
effects of [`dev.off()`](https://rdrr.io/r/grDevices/dev.html).

## Usage

``` r
reset_par()
```

## Source

<https://stackoverflow.com/questions/9292563/reset-the-graphical-parameters-back-to-default-values-without-use-of-dev-off>

## Value

A named list of [`par()`](https://rdrr.io/r/graphics/par.html) values,
suitable for passing to [`par()`](https://rdrr.io/r/graphics/par.html)

## Examples

``` r
if (FALSE) { # \dontrun{
par(mfrow = c(2, 2), mar = c(0, 0, 0, 0))
plot(1)
par(reset_par())  # back to single-panel, default margins
} # }
```
