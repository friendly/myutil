# Distilled from C:/Dropbox/R/reinstall-packages.R -- the recurring part of
# that script (save the installed package list before upgrading R, restore
# it after) generalized into functions; the one-off install_github() calls
# and per-R-version notes in the original were personal history, not kept.

#' Save names of installed packages
#'
#' Saves the names of currently installed (non-base) packages to a file, so
#' they can be reinstalled later with [restore_installed_pkgs()] --
#' typically run just before upgrading to a new R version.
#'
#' @param file path to save the package list to. Defaults to a location
#'   under [tools::R_user_dir()] that survives an R version upgrade.
#' @return the character vector of package names, invisibly
#' @export
#' @seealso [restore_installed_pkgs()]
#' @examples
#' \dontrun{
#' save_installed_pkgs()
#' }
save_installed_pkgs <- function(file = file.path(tools::R_user_dir("myutil", "data"), "installed_pkgs.rda")) {
  dir.create(dirname(file), recursive = TRUE, showWarnings = FALSE)
  ip <- utils::installed.packages()
  installedpkgs <- as.vector(ip[is.na(ip[, "Priority"]), 1])
  save(installedpkgs, file = file)
  message("Saved ", length(installedpkgs), " package names to ", file)
  invisible(installedpkgs)
}

#' Reinstall packages from a saved list
#'
#' Reinstalls packages previously saved by [save_installed_pkgs()] --
#' typically run after upgrading to a new R version, to restore the
#' packages that were installed under the old one.
#'
#' @param file path the package list was saved to
#' @param update also call `update.packages()` afterward?
#' @return the character vector of package names, invisibly
#' @export
#' @seealso [save_installed_pkgs()]
#' @examples
#' \dontrun{
#' restore_installed_pkgs()
#' }
restore_installed_pkgs <- function(file = file.path(tools::R_user_dir("myutil", "data"), "installed_pkgs.rda"), update = TRUE) {
  installedpkgs <- local({
    e <- new.env()
    load(file, envir = e)
    e$installedpkgs
  })
  utils::install.packages(installedpkgs)
  if (update) utils::update.packages(ask = "graphics")
  invisible(installedpkgs)
}
