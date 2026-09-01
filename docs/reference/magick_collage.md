# Arrange a collection of images into a collage

Reads a set of PNG/JPEG images and arranges them into a single montage
image, via the `magick` package.

## Usage

``` r
magick_collage(
  path = ".",
  files = NULL,
  columns = 2,
  pattern = "\\.(png|jpe?g)$",
  recursive = FALSE,
  geometry = "x500+10+5",
  out_file = NULL,
  format = "jpg",
  quality = 100,
  ...
)
```

## Source

Adapted from
<https://stackoverflow.com/questions/62516742/create-multi-panel-figure-using-png-jpeg-images>

## Arguments

- path:

  directory to search for image files in, when `files` isn't supplied

- files:

  optional character vector of image file paths to use directly,
  overriding `path`/`pattern`/`recursive`

- columns:

  number of columns in the collage; rows are filled automatically

- pattern:

  regular expression matching image file names, used when `files` isn't
  supplied

- recursive:

  search `path` recursively?

- geometry:

  a `magick` geometry string controlling the size of, and spacing
  between, each image in the collage – see
  [`magick::image_montage()`](https://docs.ropensci.org/magick/reference/animation.html)

- out_file:

  path to write the collage to. Defaults to `"collage.<format>"` inside
  `path`

- format:

  output image format, e.g. `"jpg"` or `"png"`

- quality:

  output quality, `0`-`100`, used for lossy formats like jpg

- ...:

  other arguments passed to
  [`magick::image_montage()`](https://docs.ropensci.org/magick/reference/animation.html),
  e.g. `bg`, `shadow`, `gravity`

## Value

the path to the collage file, invisibly

## Examples

``` r
if (FALSE) { # \dontrun{
magick_collage(path = "figures", columns = 3)
magick_collage(files = c("a.png", "b.jpg", "c.png"), columns = 2)
} # }
```
