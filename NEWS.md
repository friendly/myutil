# myutil 1.10.0

* `update_pkgs()` gains a `skip` argument, for packages not to update (e.g. `skip = "rjags"`).
  Its check for open RStudio sessions now also finds `rsession-utf8.exe`, the name that
  current RStudio uses for its R process.
* New `upgrade_r_library()`, run in a newly installed R to bring over the packages installed
  under an older one. For a patch upgrade (same `x.y`) it copies the package folders, so packages
  from GitHub, r-universe, R-Forge and local files come along without reinstalling; for a minor
  upgrade it reinstalls each package from where it came from. Packages the new R already has are
  left alone; `translations` and packages built under R < 4.0 are skipped; packages installed
  from local files are listed. With `check = TRUE` (default), the packages brought over are
  test-loaded in fresh R processes, in batches; `dry_run = TRUE` shows the plan.
* New `installed_pkg_sources()`: classifies installed packages by where they came from (CRAN,
  another repository such as an r-universe, R-Forge, Bioconductor, GitHub/GitLab/Bitbucket, local),
  from the `Repository` and `Remote*` fields in their `DESCRIPTION`.
  Packages that declare `Priority: optional` (e.g. `deming`) are included; only base and
  recommended packages are left out.
* New `outdated_pkgs()`: packages whose *version* on CRAN is newer than the installed one.
  `old.packages()` can flag hundreds of packages whose version hasn't changed (e.g., right
  after an R upgrade), which `update.packages()` then reinstalls for nothing. Also shows the newest
  binary version and marks packages whose newer version is so far only available as source.
* `update_pkgs()` decides what to update with `outdated_pkgs()` rather than
  `old.packages(checkBuilt = TRUE)`, over the CRAN and Bioconductor repositories in one pass
  (replacing `BiocManager::install(update = TRUE)`, which has the same problem), so it no
  longer reinstalls same-version packages. New argument `source` (default `TRUE`): `FALSE`
  skips updates that are so far source-only.
* `save_installed_pkgs()` also saves `pkginfo`, the output of `installed_pkg_sources()`, and
  `restore_installed_pkgs()` uses it to reinstall each package from where it came from, skipping
  packages already installed. Files saved by earlier versions still work (CRAN only).
* `update_github()` uses `remotes::install_github()`; it imported `devtools::install_github()`,
  although devtools is only suggested, which made `R CMD check` fail.
* Fixes so that `R CMD check` is clean (0/0/0):
    - `ls.objects()` failed when there were no objects (as in a clean session); the example
      `pattern = "*lm"` was not a valid regular expression.
    - `setwd()`/`cd()` kept the previous directory in `.lastdir` in the user's workspace; it is
      now kept inside the package.
    - `dropbox_folder()` no longer calls `require(jsonlite)` (it is imported).
    - Declared the `utils` functions used by `Rpackages.bib()`, `update_pkgs()` and
      `use_data_doc()`; `.Rbuildignore` covers the pkgdown files; Description is a sentence.

# myutil 1.9.2

* `Rpackages.bib()` gains `add.pkg.doi = TRUE`: fills in the CRAN package DOI
  (`10.32614/CRAN.package.<pkg>`) on a package's own `@Manual` entry when its `inst/CITATION`
  omits it. Restricted to CRAN-installed packages, `Manual` entries recognizably about the
  package itself (not vignettes or other software), and entries with no existing DOI.

# myutil 1.9.1

* `update_pkgs()`: packages that stay out of date because this session has them loaded
  (e.g., cli, glue, rlang, vctrs) are now actually updated. The old retry ran a child
  process while this session still held their DLLs, so it always failed. Now a background
  R process, started through WMI so that it isn't killed along with this session, waits
  for the session to exit, then installs them and appends the results to the same log.

# myutil 1.9.0

* First version with NEWS
* Added `reset_par()` (2026-09-01: was defined without `@export`/docs since first added,
  so never actually usable as `myutil::reset_par()`; now exported and documented)
* Added `use_data_doc()`
* Added `save_installed_pkgs()` and `restore_installed_pkgs()`, for saving/reinstalling
  the set of installed packages across an R version upgrade
* Added a CRAN release-check workflow, portable across packages: `release_preflight()`,
  `release_document()`, `release_spelling()`, `release_spelling_add()`, `release_urls()`,
  `release_site()`, `release_build()`, `release_check()`, `release_check_win()`,
  `release_revdep()`, `release_cran_comments()`, `release_run_all()`
* Enabled markdown roxygen (`Roxygen: list(markdown = TRUE)`)
* Reorganized README.md into categories
* Added `update_pkgs()`, for non-interactive CRAN + Bioconductor package updates
  with logging and self-locked-DLL retry handling
* Added `Rpackages.bib()`, for maintaining a master BibTeX file of R package
  citations. Dropped the old per-entry CRAN-DOI-stamping step -- `citation()`
  already supplies the correct DOI (or none) per entry as of R 4.x, and the
  old step clobbered legitimate non-CRAN DOIs on `Book`/`Article`-type
  citations (e.g. `citation("sf")`)

