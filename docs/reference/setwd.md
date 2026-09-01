# Set Working Directory and Display in Window Title

In Rgui, also remembers the previous directory (for
[`cd()`](https://friendly.github.io/myutil/reference/cd.md)) and updates
the window title. Outside Rgui (e.g. RStudio, a terminal session), this
is a plain passthrough to
[`base::setwd()`](https://rdrr.io/r/base/getwd.html) – masking it is
otherwise just noise in those environments.

## Usage

``` r
setwd(dir)
```

## Arguments

- dir:

  path to new directory
