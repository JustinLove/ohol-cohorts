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

Sys.time() - (12 * 7 * 24 * 60 * 60) -> date_cutoff
strftime(as.POSIXct(date_cutoff, tz = "GMT", "1970-01-01"), format="%G-%V") -> week_cutoff

alllives <- lives
alllives[alllives$birthweek > week_cutoff,] -> lives
majorupdates <- updates[updates$major == TRUE & as.POSIXlt(updates$date) > date_cutoff,]
#majorupdates <- updates[as.POSIXlt(updates$date) > date_cutoff,]
recentupdates <- updates[as.POSIXlt(updates$date) > date_cutoff,]
