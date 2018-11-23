loadupdates <- function() {
  updates <- read.table("updates.csv", header=FALSE, sep=",", quote='"')
  colnames(updates) <- c("version", "date", "name","major")
  updates$gameday <- as.numeric(round(as.POSIXct(updates$date, tz="GMT") - as.POSIXct(lives$birthtime[1], tz = "GMT", "1970-01-01")))
  updates$week <- strftime(as.POSIXct(updates$date, tz = "GMT"), format="%Y-%V")
  updates$major <- !is.na(updates$major)
  updates
}
