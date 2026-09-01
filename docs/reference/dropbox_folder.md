# Find the Dropbox folder on a Windows machine

Sourcing functions or reading data files can be a problem when they are
stored in a Dropbox folder you access on different machines. This
function uses the Dropbox file, `info.json`, always found at either
`%APPDATA%\Dropbox\info.json` or `%LOCALAPPDATA%\Dropbox\info.json`

## Usage

``` r
dropbox_folder()
```

## Source

This solution comes from
<http://stackoverflow.com/questions/35985167/determining-the-dropbox-path-in-r>

## Value

The path to the Dropbox folder, a character string

## Examples

``` r
if (FALSE) { # \dontrun{
.Dropbox <- dropbox_folder()
my_file <- paste(.Dropbox, "R/my_file.csv", sep="")
mydata <- read.csv(my_file)
} # }
```
