#' Update installed Github packages
#'
#' Find the local packages that were installed from Github and update them
#' 
#' @title update_github
#' @return none
#' @author From: https://stackoverflow.com/questions/32538052/update-all-packages-from-github
#' @export
#' @importFrom utils installed.packages packageDescription
#' @importFrom devtools install_github

update_github <- function() {
  # check/load necessary packages
  # devtools package
  if (!("package:devtools" %in% search())) {
    tryCatch(require(devtools), error = function(x) {warning(x); cat("Cannot load devtools package \n")})
    on.exit(detach("package:devtools", unload=TRUE))
  }

  pkgs <- installed.packages(fields = "RemoteType")
  github_pkgs <- pkgs[pkgs[, "RemoteType"] %in% "github", "Package"]

  print(github_pkgs)
  lapply(github_pkgs, function(pac) {
    message("Updating ", pac, " from GitHub...")

    repo = packageDescription(pac, fields = "GithubRepo")
    username = packageDescription(pac, fields = "GithubUsername")

    install_github(repo = paste0(username, "/", repo))
  })
}
