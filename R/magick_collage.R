# Generalized from C:/Dropbox/R/magick-collage.R -- the original was tied
# to a specific project (here::here("png_ouput_folder"), an undefined
# `name` variable in the output filename, png-only, no way to pass an
# explicit file list or tune the output).

#' Arrange a collection of images into a collage
#'
#' Reads a set of PNG/JPEG images and arranges them into a single montage
#' image, via the `magick` package.
#'
#' @param path directory to search for image files in, when `files` isn't
#'   supplied
#' @param files optional character vector of image file paths to use
#'   directly, overriding `path`/`pattern`/`recursive`
#' @param columns number of columns in the collage; rows are filled
#'   automatically
#' @param pattern regular expression matching image file names, used when
#'   `files` isn't supplied
#' @param recursive search `path` recursively?
#' @param geometry a `magick` geometry string controlling the size of, and
#'   spacing between, each image in the collage -- see
#'   [magick::image_montage()]
#' @param out_file path to write the collage to. Defaults to
#'   `"collage.<format>"` inside `path`
#' @param format output image format, e.g. `"jpg"` or `"png"`
#' @param quality output quality, `0`-`100`, used for lossy formats like jpg
#' @param ... other arguments passed to [magick::image_montage()], e.g.
#'   `bg`, `shadow`, `gravity`
#' @return the path to the collage file, invisibly
#' @export
#' @source Adapted from <https://stackoverflow.com/questions/62516742/create-multi-panel-figure-using-png-jpeg-images>
#'
#' @examples
#' \dontrun{
#' magick_collage(path = "figures", columns = 3)
#' magick_collage(files = c("a.png", "b.jpg", "c.png"), columns = 2)
#' }
magick_collage <- function(path = ".",
                            files = NULL,
                            columns = 2,
                            pattern = "\\.(png|jpe?g)$",
                            recursive = FALSE,
                            geometry = "x500+10+5",
                            out_file = NULL,
                            format = "jpg",
                            quality = 100,
                            ...) {
  if (!requireNamespace("magick", quietly = TRUE)) {
    stop("magick_collage() requires the 'magick' package; install.packages(\"magick\")")
  }

  if (is.null(files)) {
    files <- list.files(path, pattern = pattern, recursive = recursive,
                         full.names = TRUE, ignore.case = TRUE)
    if (length(files) == 0) {
      stop("No image files matching '", pattern, "' found in ", path)
    }
  } else if (length(files) == 0) {
    stop("'files' is empty")
  }

  if (is.null(out_file)) {
    out_file <- file.path(path, paste0("collage.", format))
  }

  collage <- magick::image_read(files)
  collage <- magick::image_montage(collage, tile = as.character(columns), geometry = geometry, ...)
  collage <- magick::image_convert(collage, format)
  magick::image_write(collage, path = out_file, format = format, quality = quality)

  message("Wrote collage of ", length(files), " image(s) to ", out_file)
  invisible(out_file)
}
