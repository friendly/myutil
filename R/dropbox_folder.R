# http://stackoverflow.com/questions/35985167/determining-the-dropbox-path-in-r

#' Find the Dropbox folder on a Windows machine
#' 
#' Sourcing functions or reading data files can be a problem when they are stored in a Dropbox
#' folder you access on different machines.  This function uses the Dropbox file, 
#' \code{info.json}, always found at either \code{\%APPDATA\%\Dropbox\info.json} or
#' \code{\%LOCALAPPDATA\%\Dropbox\info.json}
#' 
#' @return The path to the Dropbox folder, a character string
#' @importFrom jsonlite fromJSON
#' @source This solution comes from \url{http://stackoverflow.com/questions/35985167/determining-the-dropbox-path-in-r}
#' @export
#'
#' @examples
#' \dontrun{
#' .Dropbox <- dropbox_folder()
#' my_file <- paste(.Dropbox, "R/my_file.csv", sep="/")}
#' mydata <- read.csv(my_file)
#' }

dropbox_folder <- function() {

  if (Sys.info()["sysname"]!="Windows") stop("Currently, 'dropbox_folder' works for Windows only. Sorry.")
 	if (!require(jsonlite, quietly=TRUE)) stop ("You need to install the jsonlite package.")

	file_name<-list.files(paste(Sys.getenv(x = "APPDATA"),"Dropbox", sep="/"), 
	                      pattern = "*.json", full.names = TRUE)
	if (length(file_name)==0){
	   file_name<-list.files(paste(Sys.getenv(x = "LOCALAPPDATA"),"Dropbox", sep="/"), 
	                         pattern = "*.json", full.names = TRUE)}
	
	file_content <- jsonlite::fromJSON(txt=file_name)$personal
	path <-file_content$path
	path
}
