# Changelog

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
