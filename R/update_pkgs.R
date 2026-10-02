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
#' @param log_dir directory to write the run's log file to
#' @return the log file path, invisibly
#' @export
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
#' @section Note on needs_compilation packages:
#' A package sometimes has a newer *source* version on CRAN than the
#' Windows *binary* build (`old.packages(checkBuilt = TRUE)` shows this as
#' `needs_compilation: TRUE`, with `Installed < ReposVer` even right after
#' an update). This isn't a lock or a failure -- CRAN's Windows binary
#' build for that version just hasn't been published yet, usually within a
#' day or so of the source release. This function runs non-interactively
#' (`ask = FALSE`), so it never shows the "install from sources?" prompt --
#' but with Rtools installed, `update.packages()` compiles these silently
#' and resolves them in the same run. The end-of-run summary's "Installed
#' (from source)" count is exactly this set.
update_pkgs <- function(log_dir = "C:/Dropbox/R/update-pkgs-log") {
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

  # Detect other running R sessions (Windows) that could be holding package
  # DLLs open -- informational only, doesn't block the update.
  rsessions <- tryCatch({
    tasks <- system("tasklist /FI \"IMAGENAME eq rsession.exe\"", intern = TRUE)
    sum(grepl("rsession.exe", tasks, fixed = TRUE))
  }, error = function(e) NA)

  if (!is.na(rsessions) && rsessions > 0) {
    cat(glue::glue(
      "Note: {rsessions} RStudio session(s) (rsession.exe) currently running. ",
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

  # For each package, work out whether the version R will fetch is only
  # available (or newer) as a source tarball vs. a Windows binary -- this is
  # the same binary-vs-source comparison install.packages(type = "both")
  # does internally, just exposed so the end-of-run summary can report it.
  classify_install_type <- function(pkgs, repos) {
    bin <- tryCatch(available.packages(repos = repos, type = "win.binary"), error = function(e) NULL)
    src <- tryCatch(available.packages(repos = repos, type = "source"), error = function(e) NULL)
    vapply(pkgs, function(p) {
      bv <- if (!is.null(bin) && p %in% rownames(bin)) bin[p, "Version"] else NA_character_
      sv <- if (!is.null(src) && p %in% rownames(src)) src[p, "Version"] else NA_character_
      if (is.na(bv) && is.na(sv)) return(NA_character_)
      if (is.na(bv)) return("source")
      if (is.na(sv)) return("binary")
      if (package_version(sv) > package_version(bv)) "source" else "binary"
    }, character(1))
  }

  old <- old.packages(checkBuilt = TRUE)
  n_old <- if (is.null(old)) 0 else nrow(old)
  cat(glue::glue("{n_old} package(s) have updates available.\n"))
  if (n_old > 0) {
    cat(paste(old[, "Package"], collapse = ", "), "\n\n")
  }

  install_type <- if (n_old > 0) classify_install_type(old[, "Package"], getOption("repos")) else character(0)

  if (n_old > 0) {
    update.packages(ask = FALSE, checkBuilt = TRUE, oldPkgs = old[, "Package"])
  }

  if (requireNamespace("BiocManager", quietly = TRUE)) {
    cat("\n--- Checking Bioconductor packages ---\n")
    tryCatch(
      BiocManager::install(update = TRUE, ask = FALSE),
      error = function(e) cat(glue::glue("BiocManager update failed: {conditionMessage(e)}\n"))
    )
  }

  # Report anything that's still out of date (e.g. skipped due to a lock)
  still_old <- old.packages(checkBuilt = TRUE)
  n_still_old <- if (is.null(still_old)) 0 else nrow(still_old)
  deferred <- FALSE
  if (n_still_old > 0) {
    cat(glue::glue(
      "\n{n_still_old} package(s) still out of date: ",
      "{paste(still_old[, 'Package'], collapse = ', ')}\n"
    ))

    # These are often self-locked: THIS session already has them loaded as
    # dependencies of its own tools (cli/glue/rlang/magrittr for messaging,
    # jsonlite, curl, ...). Windows won't replace a DLL that ANY process has
    # loaded, so a child process started from here can't replace them either
    # while this session is still alive (the old synchronous retry failed for
    # exactly this reason). Instead, launch a detached --vanilla process that
    # waits for this session to exit, then installs them and appends the
    # results to this log.
    deferred <- launch_deferred_retry(still_old[, "Package"], log_file)
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
  cat(glue::glue("\n=== Finished {end_time} (elapsed: {round(difftime(end_time, start_time, units = 'mins'), 1)} min) ===\n"))

  close_log() # close explicitly here so the "Log written to" message below
              # prints to the console, not into the log file it's announcing

  cat(glue::glue("Log written to {log_file}\n"))
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
                                  repos = getOption("repos")["CRAN"]) {
  script_file <- sub("\\.log$", "-deferred-retry.R", log_file)
  script <- c(
    glue::glue("pid <- {Sys.getpid()}"),
    glue::glue("pkgs <- {paste(deparse(unname(pkgs)), collapse = '')}"),
    glue::glue("log_file <- {deparse(log_file)}"),
    glue::glue("max_wait <- {max_wait}"),
    glue::glue("options(repos = c(CRAN = {deparse(unname(repos))}))"),
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
    '  install.packages(pkgs, type = "win.binary")',
    '  still <- intersect(pkgs, rownames(old.packages(checkBuilt = TRUE)))',
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
