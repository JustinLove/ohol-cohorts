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
  logs <- do.call("rbind", days)
  logs <- logs[!is.na(logs$V1),]

  resets <- c(1,which((logs$V3 == 2) & (logs$V1 == "B")))
  if (length(resets) > 1) {
    print("compenstating for id reset")
    for (i in 2:length(resets)) {
      range <- resets[i-1]:(resets[i]-1)
      #print(range)
      #print(resets[i])
      #print(logs$V3[(resets[i]-10):(resets[i]+10)])
      #print(1000000 * (1 + length(resets) - i))
      logs$V3[range] <- logs$V3[range] - (1000000 * (1 + length(resets) - i))
      #print(logs$V3[(resets[i]-10):(resets[i]+10)])
    }
  }

  logs
}
