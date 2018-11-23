loaddirectory <- function(path) {
  files <- list.files(path = path, full.names=FALSE)
  files <- files[!(files %in% c("index.html", "statsCheckpoint.txt"))]
  files <- files[grep("_names", files, fixed=TRUE) * -1]
  files <- paste(path, files, sep="")

  files <- files[lapply(files, file.size) > 0]
  days <- lapply(files, function(file) {
      print(file)
      textLines <- readLines(file, warn=FALSE)
      counts <- count.fields(textConnection(textLines), sep=" ")
      read.table(text=textLines[counts == 9], header=FALSE, sep=" ")
    })
  #days <- data.frame()
  #for (i in 1:length(files)) {
    #file <- files[i]
    #print(c(i, file))
    #textLines <- readLines(file, warn=FALSE)
    #counts <- count.fields(textConnection(textLines), sep=" ")
    #rbind(days, read.table(text=textLines[counts == 9], header=FALSE, sep=" "))
  #}
  print("binding")
  logs <- do.call("rbind", days)
  logs <- logs[!is.na(logs$V1),]
  logs
}
