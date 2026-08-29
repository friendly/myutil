# myutil 1.8.0

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

