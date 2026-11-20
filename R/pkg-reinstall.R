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
#' Since myutil 1.10.0 the file also holds `pkginfo`, the output of
#' [installed_pkg_sources()], recording where each package came from (CRAN,
#' GitHub, r-universe, ...), so that [restore_installed_pkgs()] can reinstall
#' packages that are not on CRAN too. For a patch upgrade of R (e.g., 4.6.1 to
#' 4.6.2), [upgrade_r_library()] is simpler: it copies the packages directly.
#'
#' @param file path to save the package list to. Defaults to a location
#'   under [tools::R_user_dir()] that survives an R version upgrade.
#' @return the character vector of package names, invisibly
#' @export
#' @seealso [restore_installed_pkgs()], [upgrade_r_library()]
#' @examples
#' \dontrun{
#' save_installed_pkgs()
#' }
save_installed_pkgs <- function(file = file.path(tools::R_user_dir("myutil", "data"), "installed_pkgs.rda")) {
  dir.create(dirname(file), recursive = TRUE, showWarnings = FALSE)
  pkginfo <- installed_pkg_sources()
  installedpkgs <- pkginfo$Package
  save(installedpkgs, pkginfo, file = file)
  message("Saved ", length(installedpkgs), " package names to ", file)
  invisible(installedpkgs)
}

#' Reinstall packages from a saved list
#'
#' Reinstalls packages previously saved by [save_installed_pkgs()] --
#' typically run after upgrading to a new R version, to restore the
#' packages that were installed under the old one.
#'
#' If the file was saved by myutil >= 1.10.0, each package is reinstalled from
#' where it came from (see [installed_pkg_sources()]); packages already
#' installed are skipped, and packages installed from local files, built under
#' R < 4.0, or not installable (`translations`) are listed instead. Files from
#' older versions hold only package names, which are installed from CRAN.
#'
#' @param file path the package list was saved to
#' @param update also call `update.packages()` afterward?
#' @return the character vector of package names, invisibly
#' @export
#' @seealso [save_installed_pkgs()], [upgrade_r_library()]
#' @examples
#' \dontrun{
#' restore_installed_pkgs()
#' }
restore_installed_pkgs <- function(file = file.path(tools::R_user_dir("myutil", "data"), "installed_pkgs.rda"), update = TRUE) {
  e <- new.env()
  load(file, envir = e)
  installedpkgs <- e$installedpkgs
  if (is.null(e$pkginfo)) {
    utils::install.packages(installedpkgs)
  } else {
    info <- e$pkginfo
    have <- rownames(utils::installed.packages(noCache = TRUE))
    info <- info[!info$Package %in% have, , drop = FALSE]
    skip <- info$source %in% c("local", "obsolete", "skip")
    if (any(skip))
      message("Not reinstalled (", paste(unique(info$source[skip]), collapse = ", "), "): ",
              paste(info$Package[skip], collapse = ", "))
    if (any(!skip)) {
      res <- reinstall_pkgs(info[!skip, , drop = FALSE])
      failed <- res$Package[res$action != "installed"]
      if (length(failed)) message("
Could not be installed: ", paste(failed, collapse = ", "))
    }
  }
  if (update) utils::update.packages(ask = "graphics")
  invisible(installedpkgs)
}
