# Where each installed package came from

Classifies the installed (non-base, non-recommended) packages in a
library by where they were installed from, using the `Repository` and
`Remote*` fields that
[`install.packages()`](https://rdrr.io/r/utils/install.packages.html),
`remotes`/`devtools` and `pak` record in each package's `DESCRIPTION`.
This is what
[`upgrade_r_library()`](https://friendly.github.io/myutil/reference/upgrade_r_library.md)
and
[`restore_installed_pkgs()`](https://friendly.github.io/myutil/reference/restore_installed_pkgs.md)
use to reinstall packages from the right place.

## Usage

``` r
installed_pkg_sources(lib.loc = NULL)
```

## Arguments

- lib.loc:

  library directories to look in; default: all of
  [`.libPaths()`](https://rdrr.io/r/base/libPaths.html)

## Value

A data frame, one row per package, with columns

- `Package`, `Version`

- `Built`: the R version the package was built under

- `source`: one of

  - `"cran"`: from CRAN

  - `"repo"`: from another CRAN-like repository, such as an r-universe
    (URL in `spec`)

  - `"rforge"`: from R-Forge

  - `"bioc"`: from Bioconductor

  - `"github"`, `"gitlab"`, ...: from a remote, via
    `remotes`/`devtools`/`pak` (`spec` is `user/repo`, or
    `user/repo/subdir`)

  - `"local"`: from a local source or zip file; cannot be reinstalled
    automatically

  - `"obsolete"`: built under R \< 4.0.0, so it cannot be loaded by a
    current R

  - `"skip"`: not an installable package (the `translations` folder that
    R itself ships)

- `spec`: what to install from, for the `repo` and remote sources

- `LibPath`: the library the package is in

## See also

[`upgrade_r_library()`](https://friendly.github.io/myutil/reference/upgrade_r_library.md),
[`save_installed_pkgs()`](https://friendly.github.io/myutil/reference/save_installed_pkgs.md)

## Examples

``` r
src <- installed_pkg_sources()
table(src$source)
#> 
#>     cran   github    local obsolete     repo   rforge     skip 
#>     1040       11        3        2        2        1        1 
subset(src, source != "cran")
#>           Package    Version Built   source                            spec
#> 1          myutil     1.10.0 4.6.2    local                            <NA>
#> 14    BiocVersion     3.23.1 4.6.0     repo     https://bioc.r-universe.dev
#> 69         MHplot 0.0.0.9000 4.6.1   github              SShinodaPhD/MHplot
#> 150        UBFigs      3.0.1 3.0.1 obsolete                            <NA>
#> 151        UBbipl      3.0.4 3.0.2 obsolete                            <NA>
#> 211    biplot2d3d      1.0.1 4.6.1   github         Andros-Spica/biplot2d3d
#> 281      countreg      0.3-0 4.6.1   rforge                            <NA>
#> 286     crancache 0.0.0.9001 4.6.1   github                 r-lib/crancache
#> 356           emo 0.0.0.9000 4.6.1   github                      hadley/emo
#> 413      genridge      0.8.1 4.6.1    local                            <NA>
#> 427      ggbiplot      0.6.6 4.6.1   github               friendly/ggbiplot
#> 435    ggfourfold 0.1.1.9000 4.6.1    local                            <NA>
#> 443         ggord      1.1.8 4.6.1     repo https://fawda123.r-universe.dev
#> 452       ggradar        0.2 4.6.1   github            ricardo-bion/ggradar
#> 812   revdepcheck 1.0.0.9002 4.6.1   github               r-lib/revdepcheck
#> 924        spida2 0.2.3.9008 4.6.1   github                 gmonette/spida2
#> 937      strapgod 0.0.4.9000 4.6.1   github           DavisVaughan/strapgod
#> 995  translations      4.6.2 4.6.2     skip                            <NA>
#> 1009      ungeviz      0.1.0 4.6.1   github                wilkelab/ungeviz
#> 1032     webshot2 0.1.2.9000 4.6.1   github                rstudio/webshot2
#>                                                                       LibPath
#> 1    C:/Users/friendly/AppData/Local/Temp/RtmpqiZZ4c/temp_libpath64745c853b3e
#> 14                                                       C:/R/R-4.6.2/library
#> 69                                                       C:/R/R-4.6.2/library
#> 150                                                      C:/R/R-4.6.2/library
#> 151                                                      C:/R/R-4.6.2/library
#> 211                                                      C:/R/R-4.6.2/library
#> 281                                                      C:/R/R-4.6.2/library
#> 286                                                      C:/R/R-4.6.2/library
#> 356                                                      C:/R/R-4.6.2/library
#> 413                                                      C:/R/R-4.6.2/library
#> 427                                                      C:/R/R-4.6.2/library
#> 435                                                      C:/R/R-4.6.2/library
#> 443                                                      C:/R/R-4.6.2/library
#> 452                                                      C:/R/R-4.6.2/library
#> 812                                                      C:/R/R-4.6.2/library
#> 924                                                      C:/R/R-4.6.2/library
#> 937                                                      C:/R/R-4.6.2/library
#> 995                                                      C:/R/R-4.6.2/library
#> 1009                                                     C:/R/R-4.6.2/library
#> 1032                                                     C:/R/R-4.6.2/library
```
