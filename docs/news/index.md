# Changelog

## myutil 1.10.0

- New
  [`upgrade_r_library()`](https://friendly.github.io/myutil/reference/upgrade_r_library.md),
  run in a newly installed R to bring over the packages installed under
  an older one. For a patch upgrade (same `x.y`) it copies the package
  folders, so packages from GitHub, r-universe, R-Forge and local files
  come along without reinstalling; for a minor upgrade it reinstalls
  each package from where it came from. Packages the new R already has
  are left alone; `translations` and packages built under R \< 4.0 are
  skipped; packages installed from local files are listed. With
  `check = TRUE` (default), the packages brought over are test-loaded in
  fresh R processes, in batches; `dry_run = TRUE` shows the plan.
- New
  [`installed_pkg_sources()`](https://friendly.github.io/myutil/reference/installed_pkg_sources.md):
  classifies installed packages by where they came from (CRAN, another
  repository such as an r-universe, R-Forge, Bioconductor,
  GitHub/GitLab/Bitbucket, local), from the `Repository` and `Remote*`
  fields in their `DESCRIPTION`.
- New
  [`outdated_pkgs()`](https://friendly.github.io/myutil/reference/outdated_pkgs.md):
  packages whose *version* on CRAN is newer than the installed one.
  [`old.packages()`](https://rdrr.io/r/utils/update.packages.html) can
  flag hundreds of packages whose version hasn’t changed (e.g., right
  after an R upgrade), which
  [`update.packages()`](https://rdrr.io/r/utils/update.packages.html)
  then reinstalls for nothing. Also shows the newest binary version and
  marks packages whose newer version is so far only available as source.
- [`save_installed_pkgs()`](https://friendly.github.io/myutil/reference/save_installed_pkgs.md)
  also saves `pkginfo`, the output of
  [`installed_pkg_sources()`](https://friendly.github.io/myutil/reference/installed_pkg_sources.md),
  and
  [`restore_installed_pkgs()`](https://friendly.github.io/myutil/reference/restore_installed_pkgs.md)
  uses it to reinstall each package from where it came from, skipping
  packages already installed. Files saved by earlier versions still work
  (CRAN only).
- [`update_github()`](https://friendly.github.io/myutil/reference/update_github.md)
  uses
  [`remotes::install_github()`](https://remotes.r-lib.org/reference/install_github.html);
  it imported
  [`devtools::install_github()`](https://devtools.r-lib.org/reference/install-deprecated.html),
  although devtools is only suggested, which made `R CMD check` fail.
- Fixes so that `R CMD check` is clean (0/0/0):
  - [`ls.objects()`](https://friendly.github.io/myutil/reference/ls.objects.md)
    failed when there were no objects (as in a clean session); the
    example `pattern = "*lm"` was not a valid regular expression.
  - [`setwd()`](https://friendly.github.io/myutil/reference/setwd.md)/[`cd()`](https://friendly.github.io/myutil/reference/cd.md)
    kept the previous directory in `.lastdir` in the user’s workspace;
    it is now kept inside the package.
  - [`dropbox_folder()`](https://friendly.github.io/myutil/reference/dropbox_folder.md)
    no longer calls
    [`require(jsonlite)`](https://jeroen.r-universe.dev/jsonlite) (it is
    imported).
  - Declared the `utils` functions used by
    [`Rpackages.bib()`](https://friendly.github.io/myutil/reference/Rpackages.bib.md),
    [`update_pkgs()`](https://friendly.github.io/myutil/reference/update_pkgs.md)
    and
    [`use_data_doc()`](https://friendly.github.io/myutil/reference/use_data_doc.md);
    `.Rbuildignore` covers the pkgdown files; Description is a sentence.

## myutil 1.9.2

- [`Rpackages.bib()`](https://friendly.github.io/myutil/reference/Rpackages.bib.md)
  gains `add.pkg.doi = TRUE`: fills in the CRAN package DOI
  (`10.32614/CRAN.package.<pkg>`) on a package’s own `@Manual` entry
  when its `inst/CITATION` omits it. Restricted to CRAN-installed
  packages, `Manual` entries recognizably about the package itself (not
  vignettes or other software), and entries with no existing DOI.

## myutil 1.9.1

- [`update_pkgs()`](https://friendly.github.io/myutil/reference/update_pkgs.md):
  packages that stay out of date because this session has them loaded
  (e.g., cli, glue, rlang, vctrs) are now actually updated. The old
  retry ran a child process while this session still held their DLLs, so
  it always failed. Now a background R process, started through WMI so
  that it isn’t killed along with this session, waits for the session to
  exit, then installs them and appends the results to the same log.

## myutil 1.9.0

- First version with NEWS
- Added
  [`reset_par()`](https://friendly.github.io/myutil/reference/reset_par.md)
  (2026-09-01: was defined without `@export`/docs since first added, so
  never actually usable as
  [`myutil::reset_par()`](https://friendly.github.io/myutil/reference/reset_par.md);
  now exported and documented)
- Added
  [`use_data_doc()`](https://friendly.github.io/myutil/reference/use_data_doc.md)
- Added
  [`save_installed_pkgs()`](https://friendly.github.io/myutil/reference/save_installed_pkgs.md)
  and
  [`restore_installed_pkgs()`](https://friendly.github.io/myutil/reference/restore_installed_pkgs.md),
  for saving/reinstalling the set of installed packages across an R
  version upgrade
- Added a CRAN release-check workflow, portable across packages:
  [`release_preflight()`](https://friendly.github.io/myutil/reference/release_preflight.md),
  [`release_document()`](https://friendly.github.io/myutil/reference/release_document.md),
  [`release_spelling()`](https://friendly.github.io/myutil/reference/release_spelling.md),
  [`release_spelling_add()`](https://friendly.github.io/myutil/reference/release_spelling_add.md),
  [`release_urls()`](https://friendly.github.io/myutil/reference/release_urls.md),
  [`release_site()`](https://friendly.github.io/myutil/reference/release_site.md),
  [`release_build()`](https://friendly.github.io/myutil/reference/release_build.md),
  [`release_check()`](https://friendly.github.io/myutil/reference/release_check.md),
  [`release_check_win()`](https://friendly.github.io/myutil/reference/release_check_win.md),
  [`release_revdep()`](https://friendly.github.io/myutil/reference/release_revdep.md),
  [`release_cran_comments()`](https://friendly.github.io/myutil/reference/release_cran_comments.md),
  [`release_run_all()`](https://friendly.github.io/myutil/reference/release_run_all.md)
- Enabled markdown roxygen (`Roxygen: list(markdown = TRUE)`)
- Reorganized README.md into categories
- Added
  [`update_pkgs()`](https://friendly.github.io/myutil/reference/update_pkgs.md),
  for non-interactive CRAN + Bioconductor package updates with logging
  and self-locked-DLL retry handling
- Added
  [`Rpackages.bib()`](https://friendly.github.io/myutil/reference/Rpackages.bib.md),
  for maintaining a master BibTeX file of R package citations. Dropped
  the old per-entry CRAN-DOI-stamping step –
  [`citation()`](https://rdrr.io/r/utils/citation.html) already supplies
  the correct DOI (or none) per entry as of R 4.x, and the old step
  clobbered legitimate non-CRAN DOIs on `Book`/`Article`-type citations
  (e.g. `citation("sf")`)
