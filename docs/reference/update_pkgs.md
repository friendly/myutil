# Update all installed R packages (CRAN + Bioconductor) in one run

Designed to be launched non-interactively (e.g. via
`Rscript -e "myutil::update_pkgs()"`, in the background), instead of
RStudio's Tools \> Check for Package Updates, which is slow and blocks
the GUI.

## Usage

``` r
update_pkgs(log_dir = "C:/Dropbox/R/update-pkgs-log")
```

## Arguments

- log_dir:

  directory to write the run's log file to

## Value

the log file path, invisibly

## Windows note on file locks

A package can't be overwritten on disk while its DLL is loaded into a
running R process. This can be a *separate* RStudio/R session holding
the lock, but just as often it's self-inflicted: THIS session's own
package-management machinery depends on things like curl/openssl
(downloads), jsonlite (repo metadata), and cli/glue/rlang/magrittr
(messaging) – so
[`update.packages()`](https://rdrr.io/r/utils/update.packages.html) can
end up unable to overwrite the very packages it needs to run, regardless
of whether RStudio is open. R leaves the old version in place rather
than corrupting anything, so this is safe, just incomplete.

Windows won't replace a DLL that *any* process has loaded, so a child
process can't finish the job while this session is still running. This
function detects other open RStudio sessions (informational only –
doesn't block anything) and, for any packages still out of date after
the main pass, launches a detached `Rscript --vanilla` process that
waits for this R session to exit, then installs them and appends the
results to the same log. So when run as
`Rscript -e "myutil::update_pkgs()"`, the leftovers are finished a few
seconds after it returns. If you call it from an interactive session,
the retry waits until you close that session (up to an hour). If
packages are still out of date after the retry, the lock is coming from
another running R/RStudio session – close it and re-run.

## Note on needs_compilation packages

A package sometimes has a newer *source* version on CRAN than the
Windows *binary* build (`old.packages(checkBuilt = TRUE)` shows this as
`needs_compilation: TRUE`, with `Installed < ReposVer` even right after
an update). This isn't a lock or a failure – CRAN's Windows binary build
for that version just hasn't been published yet, usually within a day or
so of the source release. This function runs non-interactively
(`ask = FALSE`), so it never shows the "install from sources?" prompt –
but with Rtools installed,
[`update.packages()`](https://rdrr.io/r/utils/update.packages.html)
compiles these silently and resolves them in the same run. The
end-of-run summary's "Installed (from source)" count is exactly this
set.
