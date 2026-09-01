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
#> Error in is.na(obj.dim)[, 1]: subscript out of bounds
ls.objects(pattern="*lm")
#> Error in is.na(obj.dim)[, 1]: subscript out of bounds
ls.objects(order.by="Type")
#> Error in is.na(obj.dim)[, 1]: subscript out of bounds
```
