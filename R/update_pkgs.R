# Ported from C:/Dropbox/R/update-pkgs.R. That script's own header was
# already written for exactly this: "Tell your AI coding assistant... Run
# this script in the background... let you know when it's done." Packaging
# it as myutil::update_pkgs() means saying so doesn't require locating (or
# copy-pasting) the raw script file first.
#
# DONE: ✔️ The retry for self-locked packages (cli, glue, rlang, ...) never worked: it ran a
#       child process synchronously, while this session still held the DLLs. Now launches a
#       detached process that waits for this session to exit, then installs them. 10/1/2026

#' Update all installed R packages (CRAN + Bioconductor) in one run
#'
#' Designed to be launched non-interactively (e.g. via `Rscript -e
#' "myutil::update_pkgs()"`, in the background), instead of RStudio's
#' Tools > Check for Package Updates, which is slow and blocks the GUI.
#'
#' Which packages need updating is decided by [outdated_pkgs()] -- a newer
#' *version* on CRAN (or Bioconductor) -- not by `old.packages()`, which
#' (also via RStudio's Check for Package Updates and BiocManager) can flag
#' hundreds of packages whose version hasn't changed, e.g. right after an R
#' upgrade, and reinstall them all for nothing.
#'
#' @param log_dir directory to write the run's log file to
#' @param source also update packages whose new version is (so far) only
#'   available as source, compiling them (needs Rtools)? If `FALSE`, they are
#'   listed and left for a later run, when CRAN's binaries are out.
#' @param skip character vector of packages not to update, e.g. ones whose new version needs
#'   software that isn't installed here (e.g. `"rjags"`, which needs JAGS), or that you have installed from
#'   GitHub on purpose
#' @return the log file path, invisibly
#' @export
#' @importFrom utils installed.packages update.packages
#' @section Windows note on file locks:
#' A package can't be overwritten on disk while its DLL is loaded into a
#' running R process. This can be a *separate* RStudio/R session holding the
#' lock, but just as often it's self-inflicted: THIS session's own
#' package-management machinery depends on things like curl/openssl
#' (downloads), jsonlite (repo metadata), and cli/glue/rlang/magrittr
#' (messaging) -- so `update.packages()` can end up unable to overwrite the
#' very packages it needs to run, regardless of whether RStudio is open. R
#' leaves the old version in place rather than corrupting anything, so this
#' is safe, just incomplete.
#'
#' Windows won't replace a DLL that *any* process has loaded, so a child
#' process can't finish the job while this session is still running. This
#' function detects other open RStudio sessions (informational only --
#' doesn't block anything) and, for any packages still out of date after the
#' main pass, launches a detached `Rscript --vanilla` process that waits for
#' this R session to exit, then installs them and appends the results to the
#' same log. So when run as `Rscript -e "myutil::update_pkgs()"`, the
#' leftovers are finished a few seconds after it returns. If you call it from
#' an interactive session, the retry waits until you close that session (up
#' to an hour). If packages are still out of date after the retry, the lock
#' is coming from another running R/RStudio session -- close it and re-run.
#'
#' @section Note on source-only updates:
#' A package sometimes has a newer *source* version on CRAN than the
#' Windows *binary* build ([outdated_pkgs()] marks these `source_only`).
#' This isn't a lock or a failure -- CRAN's Windows binary build for that
#' version just hasn't been published yet, usually within a few days of the
#' source release. This function runs non-interactively (`ask = FALSE`), so
#' it never shows the "install from sources?" prompt -- with `source = TRUE`
#' and Rtools installed, `update.packages()` compiles these silently. The
#' end-of-run summary's "Installed (from source)" count is exactly this set.
update_pkgs <- function(log_dir = "C:/Dropbox/R/update-pkgs-log", source = TRUE,
                        skip = NULL) {
  start_time <- Sys.time()

  if (!dir.exists(log_dir)) dir.create(log_dir, recursive = TRUE)
  log_file <- file.path(log_dir, glue::glue("update-{format(start_time, '%Y%m%d-%H%M%S')}.log"))
  con <- file(log_file, open = "wt")
  sink(con, split = TRUE)
  sink(con, type = "message", append = TRUE)
  closed <- FALSE
  close_log <- function() {
    if (closed) return(invisible())
    sink(type = "message")
    sink()
    close(con)
    closed <<- TRUE
  }
  on.exit(close_log(), add = TRUE)

  cat(glue::glue("=== R package update started {start_time} ===\n\n"))
  if (length(skip)) cat("Skipping (skip =):", paste(skip, collapse = ", "), "\n\n")

  # Detect other running R sessions (Windows) that could be holding package
  # DLLs open -- informational only, doesn't block the update.
  rsessions <- tryCatch({
    tasks <- system("tasklist /FI \"IMAGENAME eq rsession*\"", intern = TRUE)
    sum(grepl("^rsession", tasks))   # RStudio runs R as rsession.exe or rsession-utf8.exe
  }, error = function(e) NA)

  if (!is.na(rsessions) && rsessions > 0) {
    cat(glue::glue(
      "Note: {rsessions} RStudio session(s) (rsession*.exe) currently running. ",
      "Packages loaded there may fail to update (locked DLL) -- safe, just ",
      "incomplete; re-run after closing RStudio to catch the rest.\n\n"
    ))
  }

  # Make sure a CRAN mirror is set (Rscript has no GUI to prompt for one)
  if (identical(getOption("repos")[["CRAN"]], "@CRAN@") || is.null(getOption("repos"))) {
    options(repos = c(CRAN = "https://cloud.r-project.org"))
  }

  # Use multiple cores for downloading/compiling where supported
  options(Ncpus = max(1, parallel::detectCores() - 1))

  # CRAN + Bioconductor repositories, so one pass covers both
  repos <- getOption("repos")
  if (requireNamespace("BiocManager", quietly = TRUE)) {
    repos <- tryCatch(BiocManager::repositories(), error = function(e) {
      cat(glue::glue("BiocManager::repositories() failed ({conditionMessage(e)}); CRAN only.\n"))
      repos
    })
  }

  # Packages with a newer *version* available (not just a newer build)
  find_old <- function() {
    op <- outdated_pkgs(repos = repos)
    op <- op[!op$Package %in% skip, , drop = FALSE]
    if (!source && any(op$source_only)) {
      cat(glue::glue(
        "Skipping {sum(op$source_only)} package(s) whose update is source-only so far ",
        "(source = FALSE): {paste(op$Package[op$source_only], collapse = ', ')}\n\n"
      ))
      op <- op[!op$source_only, , drop = FALSE]
    }
    op
  }

  op <- find_old()
  old <- cbind(Package = op$Package, ReposVer = op$Available)
  rownames(old) <- op$Package
  n_old <- nrow(old)
  cat(glue::glue("{n_old} package(s) have updates available.\n"))
  if (n_old > 0) {
    cat(paste(old[, "Package"], collapse = ", "), "\n\n")
  }

  install_type <- ifelse(op$source_only, "source", "binary")

  if (n_old > 0) {
    update.packages(ask = FALSE, repos = repos, oldPkgs = old[, "Package"])
  }

  # Report anything that's still out of date (e.g. skipped due to a lock)
  still_old <- find_old()
  n_still_old <- nrow(still_old)
  deferred <- FALSE
  if (n_still_old > 0) {
    cat(glue::glue(
      "\n{n_still_old} package(s) still out of date: ",
      "{paste(still_old$Package, collapse = ', ')}\n"
    ))

    # These are often self-locked: THIS session already has them loaded as
    # dependencies of its own tools (cli/glue/rlang/magrittr for messaging,
    # jsonlite, curl, ...). Windows won't replace a DLL that ANY process has
    # loaded, so a child process started from here can't replace them either
    # while this session is still alive (the old synchronous retry failed for
    # exactly this reason). Instead, launch a detached --vanilla process that
    # waits for this session to exit, then installs them and appends the
    # results to this log.
    deferred <- launch_deferred_retry(still_old$Package, log_file, repos = repos)
    if (deferred) {
      cat(glue::glue(
        "\nThese will be installed by a background R process once this ",
        "session exits; its results are appended to this log.\n"
      ))
    }
  } else {
    cat("\nAll packages up to date.\n")
  }

  # Summary: of the packages that were out of date at the start, how many
  # ended up installed via binary vs. source, and how many are still stuck
  # (compared against the actual installed versions now, after any retries).
  if (n_old > 0) {
    final_ver <- tryCatch(installed.packages()[, "Version"], error = function(e) character(0))
    target_ver <- old[, "ReposVer"]
    updated_ok <- vapply(seq_len(n_old), function(i) {
      p <- old[i, "Package"]
      cur <- final_ver[p]
      !is.na(cur) && identical(unname(cur), unname(target_ver[i]))
    }, logical(1))

    n_updated <- sum(updated_ok)
    n_not_updated <- n_old - n_updated
    type_updated <- install_type[updated_ok]
    n_binary <- sum(type_updated == "binary", na.rm = TRUE)
    n_source <- sum(type_updated == "source", na.rm = TRUE)
    n_unknown <- n_updated - n_binary - n_source

    summary_lines <- c(
      "=== Summary ===",
      sprintf("Total packages checked:  %d", n_old),
      sprintf("Installed (binary):      %d", n_binary),
      sprintf("Installed (from source): %d", n_source)
    )
    if (n_unknown > 0) {
      summary_lines <- c(summary_lines, sprintf("Installed (type unknown): %d", n_unknown))
    }
    not_updated_line <- sprintf("Not updated:             %d", n_not_updated)
    if (n_not_updated > 0) {
      not_updated_line <- paste0(
        not_updated_line, " (", paste(old[!updated_ok, "Package"], collapse = ", "), ")",
        if (deferred) " -- deferred retry pending, see end of log" else ""
      )
    }
    summary_lines <- c(summary_lines, not_updated_line, "================")
    cat("\n", paste(summary_lines, collapse = "\n"), "\n", sep = "")
  } else {
    cat("\n=== Summary ===\nNo CRAN packages needed updating.\n================\n")
  }

  end_time <- Sys.time()
  cat(glue::glue("\n=== Finished {end_time} (elapsed: {round(difftime(end_time, start_time, units = 'mins'), 1)} min) ==="), "\n")

  close_log() # close explicitly here so the "Log written to" message below
              # prints to the console, not into the log file it's announcing

  cat(glue::glue("Log written to {log_file}"), "\n")
  invisible(log_file)
}

# Launch a detached `Rscript --vanilla` that waits for this R session (the one
# holding the DLL locks) to exit, then installs `pkgs` and appends the results
# to `log_file`. The script is written next to the log, not in tempdir(),
# because this session's tempdir() is deleted when it exits. Gives up after
# `max_wait` seconds if the session is still running (e.g. when update_pkgs()
# was called from an interactive session that stays open).
# Returns TRUE if the process was launched.
launch_deferred_retry <- function(pkgs, log_file, max_wait = 3600,
                                  repos = getOption("repos")) {
  script_file <- sub("\\.log$", "-deferred-retry.R", log_file)
  script <- c(
    glue::glue("pid <- {Sys.getpid()}"),
    glue::glue("pkgs <- {paste(deparse(unname(pkgs)), collapse = '')}"),
    glue::glue("log_file <- {deparse(log_file)}"),
    glue::glue("max_wait <- {max_wait}"),
    glue::glue("options(repos = {paste(deparse(repos), collapse = '')})"),
    'alive <- function() {',
    '  out <- system(paste0("tasklist /FI \\"PID eq ", pid, "\\" /NH"), intern = TRUE)',
    '  any(grepl(paste0("\\\\b", pid, "\\\\b"), out))',
    '}',
    'waited <- 0',
    'while (alive() && waited < max_wait) { Sys.sleep(2); waited <- waited + 2 }',
    'con <- file(log_file, open = "at")',
    'sink(con); sink(con, type = "message")',
    'cat("\\n=== Deferred retry started", format(Sys.time()), "===\\n")',
    'if (alive()) {',
    '  cat("Gave up: R session", pid, "is still running after", max_wait / 60, "min.",',
    '      "Close it and run update_pkgs() again.\\n")',
    '} else {',
    '  install.packages(pkgs)',
    '  still <- intersect(pkgs, myutil::outdated_pkgs(getOption("repos"))$Package)',
    '  if (length(still) > 0) {',
    '    cat("\\nStill out of date (probably locked by another R/RStudio session;",',
    '        "close it and run update_pkgs() again):", paste(still, collapse = ", "), "\\n")',
    '  } else {',
    '    cat("\\nAll", length(pkgs), "deferred package(s) are now up to date.\\n")',
    '  }',
    '}',
    'cat("=== Deferred retry finished", format(Sys.time()), "===\\n")',
    'sink(type = "message"); sink(); close(con)'
  )
  writeLines(script, script_file)

  # Start it via WMI (Win32_Process.Create), not as a child of this process:
  # when R runs inside a Windows job object (e.g. a terminal or an AI coding
  # tool that kills the whole process tree when the command ends), an
  # ordinary child would be killed as soon as this session exits.
  rscript_bin <- normalizePath(file.path(R.home("bin"), "Rscript.exe"))
  cmdline <- paste0('"', rscript_bin, '" --vanilla "', normalizePath(script_file), '"')
  ps <- paste0("(Invoke-CimMethod -ClassName Win32_Process -MethodName Create ",
               "-Arguments @{CommandLine='", cmdline, "'}).ReturnValue")
  status <- tryCatch(
    system2("powershell", c("-NoProfile", "-Command", shQuote(ps, type = "cmd")),
            stdout = TRUE, stderr = TRUE),
    error = function(e) conditionMessage(e)
  )
  if (identical(trimws(status[length(status)]), "0")) return(TRUE)

  # Fallback: an ordinary detached child (survives unless killed with this
  # session's process tree)
  cat(glue::glue("WMI launch failed ({paste(status, collapse = ' ')}); using a detached child process.\n"))
  tryCatch({
    system2(rscript_bin, c("--vanilla", shQuote(script_file, type = "cmd")),
            wait = FALSE, invisible = TRUE)
    TRUE
  }, error = function(e) {
    cat(glue::glue("Could not launch the deferred retry: {conditionMessage(e)}\n"))
    FALSE
  })
}
