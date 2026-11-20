# ls with added information on objects

`ls` with added information on object Type, Size, Rows, and Columns

## Usage

``` r
ls.objects(pos = 1, pattern, order.by)
```

## Source

Peter Pikal, from R-help 8-2-2016

## Arguments

- pos:

  position in the search list

- pattern:

  an optional regular expression. Only names matching pattern are
  returned.

- order.by:

  one of `"Type"`, `"Size"`, `"Rows"`, `"Columns"`

## Value

a data frame, with columns Type, Size, Rows, Columns. Object names are
the row names.

## Examples

``` r
ls.objects()
#> [1] Type    Size    Rows    Columns
#> <0 rows> (or 0-length row.names)
ls.objects(pattern="lm$")
#> [1] Type    Size    Rows    Columns
#> <0 rows> (or 0-length row.names)
ls.objects(order.by="Type")
#> [1] Type    Size    Rows    Columns
#> <0 rows> (or 0-length row.names)
```
