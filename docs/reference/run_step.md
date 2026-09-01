# Run one release step, catching (not swallowing) any error

So the rest of the sequence still runs; failures are collected and
reported at the end by
[`release_run_all()`](https://friendly.github.io/myutil/reference/release_run_all.md)
instead of halting things partway through. Internal helper, not
exported.

## Usage

``` r
run_step(name, step)
```

## Arguments

- name:

  label for the step, used in progress/error messages

- step:

  a zero-argument function to run

## Value

`NULL` on success, or a one-line error summary string on failure
