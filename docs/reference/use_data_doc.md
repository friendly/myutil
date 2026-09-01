# Generate Outline Documentation for a Data Set in Roxygen Format

Generates a shell of documentation for a data set or other object in
roxygen format. This function was created by editing
[`promptData`](https://rdrr.io/r/utils/promptData.html) to replace the
old style `.Rd` formatting with code suitable for processing with
[`document`](https://devtools.r-lib.org/reference/document.html).

## Usage

``` r
use_data_doc(object, filename = NULL, name = NULL, labels = NULL)
```

## Arguments

- object:

  an R object to be documented as a data set

- filename:

  usually, a `connection` or a character string giving the name of the
  file to which the documentation shell should be written. The default
  corresponds to a file whose name is `name` followed by `".R"`. Can
  also be `NA` (see details below).

- name:

  a character string specifying the name of the object. Defaults to the
  name of `object`.

- labels:

  a character vector of variable labels or strings describing each
  column in the data set.

## Value

If `filename` is `NA`, a list-style representation of the documentation
shell. Otherwise, the name of the file written to is returned invisibly.

## Details

Unless `filename` is `NA`, a documentation shell for `object` is written
in roxygen format to the file specified by `filename`, and a message
about this is given.

If `filename` is `NA`, a list-style representation of the documentation
shell is created and returned. Writing the shell to a file amounts to
`cat(unlist(x), file = filename, sep = "\n")`, where `x` is the
list-style representation.

Currently, only data frames are handled explicitly by the code.

## See also

[`promptData`](https://rdrr.io/r/utils/promptData.html)

## Author

Michael Friendly

## Examples

``` r
if (FALSE) { # \dontrun{
use_data_doc(iris)
unlink("iris.R")

# using variable labels
labels <- c("Sepal length (mm)", "Sepal width (mm)", "Petal length (mm)", "Petal width (mm)", "Iris species" )
# console output
zz <- use_data_doc(iris, filename=NA, labels=labels)
cat(unlist(zz), sep="\n")
} # }
```
