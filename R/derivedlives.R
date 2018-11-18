derivedlives <- function(logs) {
  print("separating records")
  births <- logs[(logs[1] == "B"),]
  deaths <- logs[(logs[1] == "D"),]
  colnames(births) <- c("record", "birthtime", "playerid", "hash", "gender", "birthcoords", "parent", "birthpop", "chain")
  colnames(deaths) <- c("record", "deathtime", "playerid", "hash", "age", "gender", "deathcoords", "causeofdeath", "deathpop")
  print("merging birth and death")
  biglives <- merge(births, deaths, by.x="playerid", by.y="playerid")
  lives <- biglives[,c("playerid","birthtime","deathtime","hash.x","gender.x","parent","age","causeofdeath")]
  colnames(lives)[4] <- "hash"
  colnames(lives)[5] <- "gender"
  print("gsub age")
  lives$age <- as.numeric(gsub("age=", "", lives$age))
  lives$gender <- droplevels(lives$gender)
  lives$evegender <- factor(lives$gender, levels=c("F", "M", "EVE"))
  lives$evegender[lives$parent == "noParent"] <- "EVE"
  lives$lifetime = (lives$deathtime - lives$birthtime) / 60
  lives
}
