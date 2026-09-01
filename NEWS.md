# myutil 1.9.0

* First version with NEWS
* Added `reset_par()`
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

