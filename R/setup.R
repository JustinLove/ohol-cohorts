source("R/loaddirectory.R")
source("R/loadupdates.R")
source("R/derivedlives.R")
source("R/playerstats.R")

servers <- 1:15
serverpaths <- paste("../ohol-family-trees/cache/lifeLog_server", servers, ".onehouronelife.com/", sep = "")
serverlogs <- lapply(serverpaths, FUN=loaddirectory)
serverlives <- lapply(serverlogs, FUN=derivedlives)
lives <- do.call("rbind", serverlives)
lives <- playerstats(lives)

updates <- loadupdates()
majorupdates <- updates[updates$major == TRUE]
