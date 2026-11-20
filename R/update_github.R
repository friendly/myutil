#' Update installed Github packages
#'
#' Find the local packages that were installed from Github and update them
#' 
#' @title update_github
#' @return none
#' @author From: https://stackoverflow.com/questions/32538052/update-all-packages-from-github
#' @export
#' @importFrom utils installed.packages
#' @seealso [installed_pkg_sources()], which also lists GitHub packages

update_github <- function() {
  if (!requireNamespace("remotes", quietly = TRUE))
    stop("update_github() needs the remotes package: install.packages(\"remotes\")")
  src <- installed_pkg_sources()
  gh <- src[src$source == "github", ]
  print(gh$Package)
  for (i in seq_len(nrow(gh))) {
    message("Updating ", gh$Package[i], " from GitHub (", gh$spec[i], ") ...")
    remotes::install_github(gh$spec[i])
  }
  invisible(gh$Package)
}
