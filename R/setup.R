source("R/loaddirectory.R")
source("R/loadupdates.R")
source("R/derivedlives.R")
source("R/playerstats.R")

library(dplyr)

servers <- 1:15
serverpath <- function(server) {
  paste("../ohol-family-trees/cache/lifeLog_server", server, ".onehouronelife.com/", sep = "")
}
serverlogs <- lapply(X = servers, FUN=loaddirectory, serverpath = serverpath)
bigserverpath <- function(server) {
  paste("../ohol-family-trees/cache/lifeLog_bigserver", server-15, ".onehouronelife.com/", sep = "")
}
serverlogs[[16]] <- loaddirectory(16, serverpath=bigserverpath)
serverlogs[[17]] <- loaddirectory(17, serverpath=bigserverpath)
serverlives <- lapply(serverlogs, FUN=derivedlives)
lives <- do.call("rbind", serverlives)
lives <- playerstats(lives)

updates <- loadupdates()
majorupdates <- updates[updates$major == TRUE,]
