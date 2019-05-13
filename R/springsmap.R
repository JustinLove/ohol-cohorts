library("dplyr")
library("ggplot2")
library("gganimate")
evegenderPalette <- c("#E69F00", "#56B4E9", "#D55E00")
w <- 7
h <- 7

#Sys.time() - (30 * 60 * 60) -> date_cutoff
as.POSIXct(1557610000, origin="1970-01-01") -> date_cutoff

lives$birthdate <- as.POSIXct(lives$birthtime, origin="1970-01-01")

lives[lives$birthdate > date_cutoff & lives$parent == "noParent",] -> springs
springs[-40000 < springs$birthx & springs$birthx < 5000000,] -> mainarea
#springs[-28200 < springs$birthx & springs$birthx < -27600 & -31400 < springs$birthy & springs$birthy < -31000,] -> mainarea
bs2 <- mainarea[mainarea$server == 17,]
ggplot(bs2, aes(birthx, birthy)) +
  geom_point(aes(color=birthdate)) +
  coord_fixed()
  #labs(title='{frame_time}') +
  #transition_time(birthdate)

  
#ggplot(bs2, aes(birthtime)) + geom_histogram()
ggsave("output/springs_spawn2.png", width = w, height = h)
#anim_save("output/springs_spawn2.gif", width = w, height = h)
