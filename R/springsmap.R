library("dplyr")
library("ggplot2")
library("gganimate")
w <- 7
h <- 7

Sys.time() - (7 * 24 * 60 * 60) -> date_cutoff
#as.POSIXct(1557610000, origin="1970-01-01") -> date_cutoff
#as.POSIXct(1558158000, origin="1970-01-01") -> date_cutoff
#          1558200000
lives$birthdate <- as.POSIXct(lives$birthtime, origin="1970-01-01")

#lives -> springs
#lives[lives$birthtime > 1558150000 & lives$birthtime < 1558160000 & is.na(lives$parent),] -> springs
#lives[lives$birthdate > date_cutoff & is.na(lives$parent),] -> springs
lives[lives$birthdate > date_cutoff,] -> springs
#springs[-500000 < springs$birthx & springs$birthx < 5000000,] -> mainarea
#springs[500000 < springs$birthx,] -> mainarea
#springs -> mainarea
springs[-60000 < springs$birthx & springs$birthx < 5000000,] -> mainarea
#springs[-28200 < springs$birthx & springs$birthx < -27600 & -31400 < springs$birthy & springs$birthy < -31000,] -> mainarea

#mainarea %>%
  #group_by(server) %>%
  #summarize(
    #min_birthx = min(birthx),
    #min_birthy = min(birthy),
    #max_birthx = max(birthx),
    #max_birthy = max(birthy)
  #) -> serverrange

#bs2 -75000,-75000 : 50000,50000
#bs1 -30000,-30000 : 30000,30000
#server1 -100000,-50000 : 330000,200000
#server2 -120000,-110000 : 51000,140000
#server3 -250000,-60000 : 75000,60000
#server4 -200000,-75000 : 30000,51000
#server5 -76000,-40000 : 27000,130000
target <- mainarea[mainarea$server == 17,]
eves <- target[is.na(target$parent),]


#ggplot(target, aes(birthtime)) + geom_histogram()

#ggplot(target, aes(birthx, birthy)) +
  #geom_point(aes(color=birthdate)) +
  #coord_fixed()

target$fline <- factor((target$line * 49157) %% 98317)

ggplot(target, aes(birthx, birthy)) +
  geom_point(aes(color=fline)) +
  theme(legend.position="none") +
  coord_fixed()
ggsave("output/lineages.png", width = w, height = h)

  
ggplot(target, aes(birthx, birthy)) +
  geom_point(aes(color=birthdate)) +
  geom_point(data=eves,color="green") +
  coord_fixed()
ggsave("output/near_spawn.png", width = w, height = h)

#geom_point(data=eves,color="green") +

ggplot(target, aes(birthx, birthy)) +
  geom_point(aes(color=fline)) +
  theme(legend.position="none") +
  coord_fixed() +
  labs(title='{frame_time}') +
  transition_time(birthdate)
anim_save("output/lineages.gif", width = w, height = h)
