# Automate CRAN release checks for a package

`release_*()` functions automate the repetitive parts of preparing an R
package for a CRAN release: cross-checking DESCRIPTION/NEWS.md,
rebuilding documentation and running spelling/URL checks, rebuilding the
README and pkgdown site, building the tarball/vignettes/manual, running
`R CMD check`, remote checks (win-builder), reverse dependency checks,
and assembling `cran-comments.md`. Run them individually while iterating
on a release, or run the whole non-interactive sequence at once with
[`release_run_all()`](https://friendly.github.io/myutil/reference/release_run_all.md).

## Details

All of them must be run with the working directory set to the *target*
package's root (the package being released), not to myutil's.

Intended order:

1.  [`release_preflight()`](https://friendly.github.io/myutil/reference/release_preflight.md)
    – sanity-check Version/Date/NEWS.md against CRAN

2.  [`release_document()`](https://friendly.github.io/myutil/reference/release_document.md),
    [`release_spelling()`](https://friendly.github.io/myutil/reference/release_spelling.md)
    /
    [`release_spelling_add()`](https://friendly.github.io/myutil/reference/release_spelling_add.md),
    [`release_urls()`](https://friendly.github.io/myutil/reference/release_urls.md)
    – documentation, spelling, and URL checks

3.  [`release_site()`](https://friendly.github.io/myutil/reference/release_site.md)
    – rebuild README and pkgdown site

4.  [`release_build()`](https://friendly.github.io/myutil/reference/release_build.md),
    [`release_check()`](https://friendly.github.io/myutil/reference/release_check.md)
    – build tarball/vignettes/manual, then `R CMD check --as-cran`

5.  [`release_check_win()`](https://friendly.github.io/myutil/reference/release_check_win.md)
    – win-builder (R-devel); slow, so not run by
    [`release_run_all()`](https://friendly.github.io/myutil/reference/release_run_all.md)
    unless `full = TRUE`

6.  [`release_revdep()`](https://friendly.github.io/myutil/reference/release_revdep.md)
    – reverse dependency checks; also opt-in via `full = TRUE`

7.  [`release_cran_comments()`](https://friendly.github.io/myutil/reference/release_cran_comments.md)
    – assemble `cran-comments.md` from the saved
    [`release_check()`](https://friendly.github.io/myutil/reference/release_check.md)
    and
    [`release_revdep()`](https://friendly.github.io/myutil/reference/release_revdep.md)
    output

What's still manual: bumping DESCRIPTION's Version/Date, writing the
NEWS.md entry, and the actual submission
([`devtools::submit_cran()`](https://devtools.r-lib.org/reference/submit_cran.html)
after reviewing `cran-comments.md`/the diff yourself, for routine
releases; or
[`usethis::use_release_issue()`](https://usethis.r-lib.org/reference/use_release_issue.html)
first when a release has open questions worth documenting in a GitHub
issue). See the comments at the top of `release_checks.R` for why the
submission itself isn't automated, and for notes on related tooling
(fledge, rhub, goodpractice, foghorn, etc).

## See also

Other release checks:
[`release_build()`](https://friendly.github.io/myutil/reference/release_build.md),
[`release_check()`](https://friendly.github.io/myutil/reference/release_check.md),
[`release_check_win()`](https://friendly.github.io/myutil/reference/release_check_win.md),
[`release_cran_comments()`](https://friendly.github.io/myutil/reference/release_cran_comments.md),
[`release_document()`](https://friendly.github.io/myutil/reference/release_document.md),
[`release_preflight()`](https://friendly.github.io/myutil/reference/release_preflight.md),
[`release_revdep()`](https://friendly.github.io/myutil/reference/release_revdep.md),
[`release_run_all()`](https://friendly.github.io/myutil/reference/release_run_all.md),
[`release_site()`](https://friendly.github.io/myutil/reference/release_site.md),
[`release_spelling()`](https://friendly.github.io/myutil/reference/release_spelling.md),
[`release_spelling_add()`](https://friendly.github.io/myutil/reference/release_spelling_add.md),
[`release_urls()`](https://friendly.github.io/myutil/reference/release_urls.md)
