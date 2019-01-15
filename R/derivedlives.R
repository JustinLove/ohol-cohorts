derivedlives <- function(logs) {
  logs$killer <- as.numeric(gsub("killer_", "", logs$V8))

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
      logs$killer[range] <- logs$killer[range] - (1000000 * (1 + length(resets) - i))
      #print(logs$V3[(resets[i]-10):(resets[i]+10)])
    }
  }

  print("separating records")
  births <- logs[(logs[1] == "B"),]
  deaths <- logs[(logs[1] == "D"),]
  colnames(births) <- c("record", "birthtime", "playerid", "hash", "gender", "birthcoords", "parent", "birthpop", "chain", "server", "killer")
  colnames(deaths) <- c("record", "deathtime", "playerid", "hash", "age", "gender", "deathcoords", "causeofdeath", "deathpop", "server", "killer")
  print("merging birth and death")
  biglives <- merge(births, deaths, by.x="playerid", by.y="playerid")
  lives <- biglives[,c("playerid","birthtime","deathtime","hash.x","gender.x","parent","age","causeofdeath", "server.x", "killer.y","birthcoords","deathcoords")]
  colnames(lives)[4] <- "hash"
  colnames(lives)[5] <- "gender"
  colnames(lives)[9] <- "server"
  colnames(lives)[10] <- "killer"

  lives %>%
    filter(!is.na(killer)) %>%
    group_by(killer) %>%
    summarize(
      kills = length(killer)
    ) -> murders

  lives <- merge(lives, murders, by.x="playerid", by.y="killer", all.x = TRUE)
  lives$kills[is.na(lives$kills)] <- 0

  print("gsub age")
  lives$age <- as.numeric(gsub("age=", "", lives$age))
  print("coords")
  lives$birthx <- as.numeric(gsub("\\(|,.*\\)", "", lives$birthcoords))
  lives$birthy <- as.numeric(gsub("\\(.*,|\\)", "", lives$birthcoords))
  lives$deathx <- as.numeric(gsub("\\(|,.*\\)", "", lives$deathcoords))
  lives$deathy <- as.numeric(gsub("\\(.*,|\\)", "", lives$deathcoords))
  lives$gender <- droplevels(lives$gender)
  lives$evegender <- factor(lives$gender, levels=c("F", "M", "EVE"))
  lives$evegender[lives$parent == "noParent"] <- "EVE"
  lives$lifetime = (lives$deathtime - lives$birthtime) / 60
  lives
}
