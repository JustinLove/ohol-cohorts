loadFile <- function(file) {
  print(file)
  textLines <- readLines(file, warn=FALSE)
  counts <- count.fields(file, sep=" ")
  read.table(text=textLines[counts == 9], header=FALSE, sep=" ")
}

loaddirectory <- function(server, serverpath) {
  path <- serverpath(server)
  files <- list.files(path = path, full.names=FALSE)
  
  if ("all.txt" %in% files) {
    file <- paste(path, "all.txt", sep="")
    logs <- loadFile(file)
  } else {
    files <- files[!(files %in% c("index.html", "statsCheckpoint.txt", "all.txt"))]
    files <- files[grep("_names", files, fixed=TRUE) * -1]
    files <- paste(path, files, sep="")
    
    files <- files[lapply(files, file.size) > 0]
    days <- lapply(files, loadFile)
    print("binding")
    logs <- do.call("rbind", days)
  }
  logs <- logs[!is.na(logs$V1),]
  logs$server <- server
  logs
}
