# upgrade_r_library() and helpers: carry an R package library over to a new R version.
# Written 2026-11-20 after upgrading R 4.6.1 -> 4.6.2 by hand (copy the package folders, then
# check that everything loads), to replace the manual steps in C:/Dropbox/R/reinstall-packages.R.

#' Where each installed package came from
#'
#' Classifies the installed (non-base, non-recommended) packages in a library by where they were
#' installed from, using the `Repository` and `Remote*` fields that `install.packages()`,
#' `remotes`/`devtools` and `pak` record in each package's `DESCRIPTION`. This is what
#' [upgrade_r_library()] and [restore_installed_pkgs()] use to reinstall packages from the right
#' place.
#'
#' @param lib.loc library directories to look in; default: all of [.libPaths()]
#' @return A data frame, one row per package, with columns
#'   * `Package`, `Version`
#'   * `Built`: the R version the package was built under
#'   * `source`: one of
#'      - `"cran"`: from CRAN
#'      - `"repo"`: from another CRAN-like repository, such as an r-universe (URL in `spec`)
#'      - `"rforge"`: from R-Forge
#'      - `"bioc"`: from Bioconductor
#'      - `"github"`, `"gitlab"`, ...: from a remote, via `remotes`/`devtools`/`pak` (`spec` is
#'        `user/repo`, or `user/repo/subdir`)
#'      - `"local"`: from a local source or zip file; cannot be reinstalled automatically
#'      - `"obsolete"`: built under R < 4.0.0, so it cannot be loaded by a current R
#'      - `"skip"`: not an installable package (the `translations` folder that R itself ships)
#'   * `spec`: what to install from, for the `repo` and remote sources
#'   * `LibPath`: the library the package is in
#' @export
#' @seealso [upgrade_r_library()], [save_installed_pkgs()]
#' @examples
#' src <- installed_pkg_sources()
#' table(src$source)
#' subset(src, source != "cran")
installed_pkg_sources <- function(lib.loc = NULL) {
  fields <- c("Repository", "RemoteType", "RemoteUsername", "RemoteRepo", "RemoteSubdir",
              "RemoteHost", "biocViews")
  ip <- utils::installed.packages(lib.loc = lib.loc, fields = fields, noCache = TRUE)
  ip <- ip[!ip[, "Priority"] %in% c("base", "recommended"), , drop = FALSE]   # keep "optional"
  ip <- ip[!duplicated(ip[, "Package"]), , drop = FALSE]    # first one on the search path wins

  built <- built_version(ip[, "Built"])
  src <- spec <- rep(NA_character_, nrow(ip))
  for (i in seq_len(nrow(ip))) {
    x <- ip[i, ]
    remote <- x[["RemoteType"]]
    repo <- x[["Repository"]]
    if (x[["Package"]] == "translations") {
      src[i] <- "skip"
    } else if (!is.na(built[i]) && package_version(built[i]) < "4.0.0") {
      src[i] <- "obsolete"
    } else if (!is.na(remote) && remote %in% c("github", "gitlab", "bitbucket")) {
      src[i] <- remote
      spec[i] <- paste0(x[["RemoteUsername"]], "/", x[["RemoteRepo"]],
                        if (!is.na(x[["RemoteSubdir"]])) paste0("/", x[["RemoteSubdir"]]))
    } else if (!is.na(repo) && repo == "CRAN") {
      src[i] <- "cran"
    } else if (!is.na(repo) && repo == "R-Forge") {
      src[i] <- "rforge"
    } else if ((!is.na(repo) && grepl("^BioC", repo)) ||
               (!is.na(x[["biocViews"]]) && nzchar(x[["biocViews"]]) && is.na(repo))) {
      src[i] <- "bioc"
    } else if (!is.na(repo) && grepl("^https?://", repo)) {
      src[i] <- "repo"
      spec[i] <- repo
    } else if (!is.na(remote) && remote %in% c("standard", "cran", "any")) {
      src[i] <- "cran"
    } else {
      src[i] <- "local"
    }
  }
  data.frame(Package = ip[, "Package"], Version = ip[, "Version"], Built = built,
             source = src, spec = spec, LibPath = ip[, "LibPath"],
             row.names = NULL, stringsAsFactors = FALSE)
}

#' Carry an R package library over to a new version of R
#'
#' Run this from the **new** R, right after installing it, to bring over the packages installed
#' under an older R.
#'
#' * For a patch upgrade (same `x.y`, e.g. 4.6.1 to 4.6.2), the package folders are simply
#'   **copied**: packages built for one `x.y.*` release work in any other, so nothing needs to
#'   be downloaded or rebuilt, and packages from GitHub, r-universe, R-Forge or local files come
#'   along too.
#' * For a minor or major upgrade (e.g. 4.6 to 4.7), packages must be **reinstalled**. Each one
#'   is reinstalled from where it originally came from (see [installed_pkg_sources()]): CRAN,
#'   another CRAN-like repository, R-Forge, Bioconductor or GitHub. Packages installed from local
#'   files are listed for you to reinstall by hand.
#'
#' Either way, packages that the new R already has (its base and recommended packages, or
#' anything already installed) are left alone, `translations` and packages built under R < 4.0
#' are skipped, and with `check = TRUE` the packages brought over are test-loaded in fresh R
#' processes, in batches (loading 1000 packages in one session runs into the limit on loaded
#' DLLs).
#'
#' Close other R sessions using the *new* R first; sessions running the old R don't matter.
#' Afterwards, [outdated_pkgs()] lists the packages with newer versions on CRAN.
#'
#' @param from the old R installation (e.g., `"C:/R/R-4.6.1"`) or one of its package libraries
#' @param to the library to put the packages in; default: the first of [.libPaths()]
#' @param method `"auto"` (copy for a patch upgrade, otherwise reinstall), `"copy"` or
#'   `"reinstall"`
#' @param check test-load the packages brought over?
#' @param dry_run if `TRUE`, only report what would be done
#' @return A data frame, invisibly: the output of [installed_pkg_sources()] for the old library,
#'   with columns `action` (what was done) and `problem` (why a package failed to install or
#'   load, if it did).
#' @export
#' @seealso [installed_pkg_sources()], [outdated_pkgs()], [update_pkgs()],
#'   [save_installed_pkgs()]
#' @examples
#' \dontrun{
#' # in the newly installed R 4.6.2:
#' res <- upgrade_r_library("C:/R/R-4.6.1", dry_run = TRUE)   # see the plan
#' res <- upgrade_r_library("C:/R/R-4.6.1")
#' subset(res, !is.na(problem))
#' }
upgrade_r_library <- function(from, to = .libPaths()[1],
                              method = c("auto", "copy", "reinstall"),
                              check = TRUE, dry_run = FALSE) {
  method <- match.arg(method)
  from_lib <- lib_dir(from)
  to <- normalizePath(to, winslash = "/", mustWork = TRUE)
  if (identical(tolower(from_lib), tolower(to)))
    stop("'from' and 'to' are the same library: ", to)

  old_ver <- lib_r_version(from_lib)
  new_ver <- getRversion()
  same_minor <- !is.na(old_ver) && identical(unclass(old_ver)[[1]][1:2], unclass(new_ver)[[1]][1:2])
  if (method == "auto") method <- if (same_minor) "copy" else "reinstall"
  if (method == "copy" && !same_minor)
    stop("Packages built under R ", old_ver, " can't be copied to R ", new_ver,
         "; use method = \"reinstall\"")

  info <- installed_pkg_sources(from_lib)
  have <- rownames(utils::installed.packages(lib.loc = unique(c(to, .libPaths())), noCache = TRUE))
  info$action <- ifelse(info$Package %in% have, "already installed",
                 ifelse(info$source %in% c("skip", "obsolete"), paste0("skipped (", info$source, ")"),
                 if (method == "copy") "copy"
                 else ifelse(info$source == "local", "reinstall by hand", "reinstall")))
  info$problem <- NA_character_

  message("From: ", from_lib, " (R ", old_ver, ")\nTo:   ", to, " (R ", new_ver, ")\n",
          "Method: ", method)
  print(table(action = info$action, source = info$source))
  todo <- info$action %in% c("copy", "reinstall")
  if (dry_run || !any(todo)) {
    if (!any(todo)) message("\nNothing to do.")
    return(invisible(info))
  }

  if (method == "copy") {
    pk <- info$Package[todo]
    message("\nCopying ", length(pk), " packages ...")
    ok <- vapply(pk, function(p) {
      file.copy(file.path(from_lib, p), to, recursive = TRUE, copy.date = TRUE)
    }, logical(1))
    info$action[todo] <- ifelse(ok, "copied", "copy failed")
  } else {
    info[todo, ] <- reinstall_pkgs(info[todo, ], lib = to)
  }

  new <- info$action %in% c("copied", "installed")
  if (check && any(new)) {
    message("\nTest-loading ", sum(new), " packages ...")
    bad <- check_pkgs_load(info$Package[new], libs = unique(c(to, .libPaths())))
    if (nrow(bad)) {
      i <- match(bad$package, info$Package)
      info$action[i] <- paste(info$action[i], "(fails to load)")
      info$problem[i] <- bad$message
    }
  }

  message("\nDone:")
  print(table(info$action))
  probs <- info[!is.na(info$problem), c("Package", "source", "action", "problem")]
  if (nrow(probs)) {
    message("\nProblems:")
    probs$problem <- substr(probs$problem, 1, 80)
    print(probs, row.names = FALSE)
  }
  by_hand <- info$Package[info$action == "reinstall by hand"]
  if (length(by_hand))
    message("\nInstalled from local files; reinstall these by hand: ", paste(by_hand, collapse = ", "))
  invisible(info)
}

#' Installed packages with newer versions available
#'
#' Unlike [utils::old.packages()], lists only the packages whose *version* on the repository is
#' newer than the installed one. `old.packages()` can also flag hundreds of packages whose version
#' hasn't changed, e.g. right after an R upgrade or when CRAN rebuilds its binaries, and
#' `update.packages()` then reinstalls them all for nothing.
#'
#' On Windows and macOS, a new version is often on CRAN as source for a day or two before the
#' binary is built; the `binary` column shows the newest binary version, and `source_only` marks
#' packages for which only the source is newer (these need compiling if installed now).
#'
#' @param repos repositories to compare with; default: `getOption("repos")`, or the cloud CRAN
#'   mirror if none is set
#' @param lib.loc libraries to check; default: all of [.libPaths()]
#' @return A data frame with columns `Package`, `Installed`, `Available` (newest version,
#'   any type), `binary` (newest binary version; `NA` on Linux), `source_only` and `LibPath`.
#' @export
#' @seealso [update_pkgs()], [upgrade_r_library()]
#' @examples
#' \dontrun{
#' op <- outdated_pkgs()
#' op
#' # install the ones with binaries now; leave the rest for a few days
#' install.packages(op$Package[!op$source_only])
#' }
outdated_pkgs <- function(repos = getOption("repos"), lib.loc = NULL) {
  if (is.null(repos) || identical(unname(repos["CRAN"]), "@CRAN@"))
    repos <- c(CRAN = "https://cloud.r-project.org")
  ip <- utils::installed.packages(lib.loc = lib.loc, noCache = TRUE)
  ip <- ip[!duplicated(ip[, "Package"]), , drop = FALSE]
  src <- utils::available.packages(repos = repos, type = "source")
  bin <- if (.Platform$pkgType != "source")
    tryCatch(utils::available.packages(repos = repos, type = .Platform$pkgType),
             error = function(e) NULL)
  pk <- intersect(ip[, "Package"], rownames(src))
  inst <- ip[match(pk, ip[, "Package"]), "Version"]
  sv <- src[pk, "Version"]
  bv <- if (is.null(bin)) rep(NA_character_, length(pk))
        else unname(bin[match(pk, rownames(bin)), "Version"])
  newer <- function(a, b) !is.na(a) & package_version(ifelse(is.na(a), "0", a)) > package_version(b)
  avail <- ifelse(newer(bv, sv), bv, sv)
  keep <- newer(avail, inst)
  data.frame(Package = pk, Installed = inst, Available = avail, binary = bv,
             source_only = !is.null(bin) & !newer(bv, inst),
             LibPath = ip[match(pk, ip[, "Package"]), "LibPath"],
             row.names = NULL, stringsAsFactors = FALSE)[keep, , drop = FALSE]
}

# ---- internal helpers --------------------------------------------------------------------

# R version in a "Built" field ("R 4.6.1; x86_64-w64-mingw32; ..." or "4.6.1")
built_version <- function(x) {
  m <- regmatches(x, regexpr("[0-9]+\\.[0-9]+(\\.[0-9]+)?", x))
  out <- rep(NA_character_, length(x))
  out[!is.na(x) & grepl("[0-9]+\\.[0-9]+", x)] <- m
  out
}

# library directory, given an R home or a library
lib_dir <- function(path) {
  path <- normalizePath(path, winslash = "/", mustWork = TRUE)
  if (file.exists(file.path(path, "library", "base", "DESCRIPTION"))) return(file.path(path, "library"))
  if (!length(Sys.glob(file.path(path, "*", "DESCRIPTION"))))
    stop("No R installation or package library found at ", path)
  path
}

# R version a library belongs to: its base package if it has one, else the most common Built
lib_r_version <- function(lib) {
  base <- file.path(lib, "base", "DESCRIPTION")
  if (file.exists(base)) return(package_version(read.dcf(base, "Version")[1, 1]))
  b <- built_version(utils::installed.packages(lib.loc = lib, noCache = TRUE)[, "Built"])
  if (!length(b) || all(is.na(b))) return(NA)
  package_version(names(which.max(table(b))))
}

# reinstall packages from where they came from; returns info with action/problem filled in
reinstall_pkgs <- function(info, lib = .libPaths()[1]) {
  repos <- getOption("repos")
  if (is.null(repos) || identical(unname(repos["CRAN"]), "@CRAN@"))
    repos <- c(CRAN = "https://cloud.r-project.org")
  installed_now <- function() rownames(utils::installed.packages(lib.loc = lib, noCache = TRUE))
  try_install <- function(pk, expr) {
    message("\n--- ", length(pk), " package(s): ", paste(utils::head(pk, 8), collapse = ", "),
            if (length(pk) > 8) ", ...")
    tryCatch(expr, error = function(e) message("  error: ", conditionMessage(e)))
  }

  cran <- info$Package[info$source == "cran"]
  if (length(cran)) try_install(cran, utils::install.packages(cran, lib = lib, repos = repos))

  for (url in unique(stats::na.omit(info$spec[info$source == "repo"]))) {
    pk <- info$Package[info$source == "repo" & info$spec %in% url]
    try_install(pk, utils::install.packages(pk, lib = lib, repos = c(url, repos)))
  }

  rf <- info$Package[info$source == "rforge"]
  if (length(rf))
    try_install(rf, utils::install.packages(rf, lib = lib,
                                            repos = c("https://R-Forge.R-project.org", repos)))

  bioc <- info$Package[info$source == "bioc"]
  if (length(bioc)) {
    if (requireNamespace("BiocManager", quietly = TRUE))
      try_install(bioc, BiocManager::install(bioc, lib = lib, update = FALSE, ask = FALSE))
    else message("\nBiocManager is not installed; skipping Bioconductor packages: ",
                 paste(bioc, collapse = ", "))
  }

  rem <- info$source %in% c("github", "gitlab", "bitbucket")
  if (any(rem)) {
    if (requireNamespace("remotes", quietly = TRUE)) {
      for (i in which(rem)) {
        fun <- switch(info$source[i], github = remotes::install_github,
                      gitlab = remotes::install_gitlab, bitbucket = remotes::install_bitbucket)
        try_install(info$Package[i], fun(info$spec[i], lib = lib, upgrade = "never"))
      }
    } else message("\nremotes is not installed; skipping: ", paste(info$Package[rem], collapse = ", "))
  }

  now <- installed_now()
  auto <- info$source != "local"
  info$action[auto] <- ifelse(info$Package[auto] %in% now, "installed", "not installed")
  info$problem[auto & !info$Package %in% now] <- paste("could not be installed from", info$source[auto & !info$Package %in% now])
  info
}

# load each package in a fresh R process, in batches; returns data frame of failures
check_pkgs_load <- function(pkgs, libs = .libPaths(), batch = 100) {
  rscript <- file.path(R.home("bin"), if (.Platform$OS.type == "windows") "Rscript.exe" else "Rscript")
  script <- tempfile(fileext = ".R")
  libfile <- tempfile()
  writeLines(libs, libfile)
  writeLines(c(
    'Sys.setenv(RGL_USE_NULL = "TRUE")',
    'args <- commandArgs(TRUE)',
    '.libPaths(readLines(args[2]))',
    'for (p in readLines(args[1])) {',
    '  r <- tryCatch({suppressWarnings(suppressMessages(loadNamespace(p))); NULL},',
    '                error = function(e) conditionMessage(e))',
    '  if (!is.null(r)) cat("FAIL\\t", p, "\\t", gsub("[\\r\\n]+", " ", r), "\\n", sep = "")',
    '}'), script)
  chunks <- split(pkgs, ceiling(seq_along(pkgs) / batch))
  out <- character()
  for (ch in chunks) {
    f <- tempfile()
    writeLines(ch, f)
    res <- suppressWarnings(system2(rscript, c("--vanilla", shQuote(script), shQuote(f), shQuote(libfile)),
                                    stdout = TRUE, stderr = FALSE))
    out <- c(out, grep("^FAIL\t", res, value = TRUE))
  }
  parts <- strsplit(out, "\t", fixed = TRUE)
  data.frame(package = vapply(parts, `[`, "", 2), message = vapply(parts, `[`, "", 3),
             stringsAsFactors = FALSE)
}
