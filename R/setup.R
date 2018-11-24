source("R/loaddirectory.R")
source("R/loadupdates.R")
source("R/derivedlives.R")
source("R/playerstats.R")

servers <- 1:15
serverpath <- function(server) {
  paste("../ohol-family-trees/cache/lifeLog_server", server, ".onehouronelife.com/", sep = "")
}
serverlogs <- lapply(X = servers, FUN=loaddirectory, serverpath = serverpath)
serverlives <- lapply(serverlogs, FUN=derivedlives)
lives <- do.call("rbind", serverlives)
lives <- playerstats(lives)

updates <- loadupdates()
majorupdates <- updates[updates$major == TRUE]
