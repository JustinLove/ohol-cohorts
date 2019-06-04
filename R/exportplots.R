library("dplyr")
library("ggplot2")
evegenderPalette <- c("#E69F00", "#56B4E9", "#D55E00")
w <- 8
h <- 4.5

dangerous <- lives[lives$age >= 8,]
lives$dangerous <- lives$age >= 8
lives$old <- lives$age > 55
eves <- lives[is.na(lives$parent),]


ggplot(lives, aes(gameday)) + geom_freqpoly() + labs(y = "lives") +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("outputall/density_days_released.png", width = w, height = h)

ggplot(lives, aes(daysowned)) + geom_freqpoly() + labs(y = "lives")
ggsave("outputall/density_days_owned.png", width = w, height = h)

ggplot(lives, aes(daysplayed)) + geom_freqpoly() + labs(y = "lives")
ggsave("outputall/density_days_played.png", width = w, height = h)

# Combined gameday

lives %>%
  group_by(gameday) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1),
    players = length(unique(hash))
    ) -> summarygame

dangerous %>%
  group_by(gameday) %>%
  summarize(
    mean_kills = mean(kills),
    kills_per_hour_lived = mean(sum(kills)/sum(lifetime/60))
    ) -> summarygamekills

eves %>%
  group_by(gameday) %>%
  summarize(
    mean_kills = mean(kills),
    total_kills = sum(kills)
  ) -> summaryevekills

lives %>%
  group_by(gameday) %>%
  summarize(
    total_lives = length(kills),
    nondie = length(kills) - sum(lt1),
    oldage = sum(old),
    dangerous_lives = sum(dangerous),
    total_kills = sum(kills)
    ) -> summarygamekillcount

ggplot(summarygame, aes(gameday, players)) +
  geom_line() +
  geom_smooth(span = 0.1) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("outputall/unique_players_by_days_released.png", width = w, height = h)

ggplot(summarygamekills, aes(gameday)) +
  geom_line(data=summarygamekills, aes(y=mean_kills)) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 0.14, angle=270, hjust=0), size=3)
ggsave("outputall/mean_kills_by_days_released.png", width = w, height = h)

ggplot(summaryevekills, aes(gameday)) +
  geom_line(data=summaryevekills, aes(y=mean_kills)) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 0.14, angle=270, hjust=0), size=3)
ggsave("outputall/mean_eve_kills_by_days_released.png", width = w, height = h)

ggplot(summarygamekills, aes(gameday)) +
  geom_line(data=summarygamekills, aes(y=kills_per_hour_lived)) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("outputall/kills_per_hour_lived_by_days_released.png", width = w, height = h)

ggplot(summarygamekillcount, aes(gameday)) +
  geom_line(aes(y=total_lives, color="total_lives")) +
  geom_line(aes(y=nondie, color="age1")) +
  geom_line(aes(y=dangerous_lives, color="age8")) +
  geom_line(aes(y=oldage, color="age55")) +
  geom_line(aes(y=total_kills, color="kills")) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 80000, angle=270, hjust=0), size=3) +
  scale_color_manual(values=c(total_lives="blue",age1="green", age8="yellow",age55="white",kills="red"))
ggsave("outputall/kill_context_by_days_released.png", width = w, height = h)


ggplot(summarygamekillcount, aes(gameday)) +
  geom_line(aes(y=total_kills)) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 900, angle=270, hjust=0), size=3)
ggsave("outputall/kills_by_days_released.png", width = w, height = h)

ggplot(summaryevekills, aes(gameday)) +
  geom_line(aes(y=total_kills)) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 200, angle=270, hjust=0), size=3)
ggsave("outputall/eve_kills_by_days_released.png", width = w, height = h)


livesggplot(summarygame, aes(gameday)) +
  geom_line(data=summarygame, aes(y=mean_lifetime)) +
  geom_smooth(data=lives, aes(y=lifetime)) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("outputall/mean_lifetime_by_days_released.png", width = w, height = h)

ggplot(summarygame, aes(gameday)) +
  geom_line(data=summarygame, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1))) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("outputall/infant_death_rate_by_days_released.png", width = w, height = h)

# Combined daysowned

lives %>%
  group_by(daysowned) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1)
    ) -> summaryowned

dangerous %>%
  group_by(daysowned) %>%
  summarize(
    mean_kills = mean(kills)
    ) -> summaryownedkills

ggplot(summaryowned, aes(daysowned)) +
  geom_line(data=summaryowned, aes(y=mean_lifetime)) +
  geom_smooth(data=lives, aes(y=lifetime))
ggsave("outputall/mean_lifetime_by_days_owned.png", width = w, height = h)

ggplot(summaryowned, aes(daysowned)) +
  geom_line(data=summaryowned, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1)))
ggsave("outputall/infant_death_rate_by_days_owned.png", width = w, height = h)

ggplot(summaryownedkills, aes(daysowned)) +
  geom_line(data=summaryownedkills, aes(y=mean_kills)) +
  geom_smooth(data=dangerous, aes(y=kills))
ggsave("outputall/mean_kills_by_days_owned.png", width = w, height = h)


# Combined daysplayed

lives %>%
  group_by(daysplayed) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1),
    ) -> summaryplayed

dangerous %>%
  group_by(daysplayed) %>%
  summarize(
    mean_kills = mean(kills)
    ) -> summaryplayedkills

ggplot(summaryplayed, aes(daysplayed)) +
  geom_line(data=summaryplayed, aes(y=mean_lifetime)) +
  geom_smooth(data=lives, aes(y=lifetime))
ggsave("outputall/mean_lifetime_by_days_played.png", width = w, height = h)

ggplot(summaryplayed, aes(daysplayed)) +
  geom_line(data=summaryplayed, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1)))
ggsave("outputall/infant_death_rate_by_days_played.png", width = w, height = h)

ggplot(summaryplayedkills, aes(daysplayed)) +
  geom_line(data=summaryplayedkills, aes(y=mean_kills)) +
  geom_smooth(data=dangerous, aes(y=kills))
ggsave("outputall/mean_kills_by_days_played.png", width = w, height = h)


# Separated gameday

lives %>%
  group_by(gameday, evegender) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1)
    ) -> summarygamegender

ggplot(summarygamegender,
    aes(gameday, color = evegender)) +
  geom_line(data=summarygamegender, aes(y=mean_lifetime)) +
  geom_smooth(data=lives, aes(y=lifetime)) +
  scale_color_manual(values=evegenderPalette) +
  geom_text(majorupdates, mapping = aes(color = 'F', x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("outputall/mean_lifetime_by_days_released_and_gender.png", width = w, height = h)

ggplot(summarygamegender,
    aes(gameday, color = evegender)) +
  geom_line(data=summarygamegender, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1))) +
  scale_color_manual(values=evegenderPalette) +
  geom_text(majorupdates, mapping = aes(color = 'M', x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("outputall/infant_death_rate_by_days_released_and_gender.png", width = w, height = h)

# Separated daysowned

lives %>%
  group_by(daysowned, evegender) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1)
    ) -> summaryownedgender

ggplot(summaryownedgender,
    aes(daysowned, color = evegender)) +
  geom_line(data=summaryownedgender, aes(y=mean_lifetime)) +
  geom_smooth(data=lives, aes(y=lifetime)) +
  scale_color_manual(values=evegenderPalette)
ggsave("outputall/mean_lifetime_by_days_owned_and_gender.png", width = w, height = h)

ggplot(summaryownedgender,
    aes(daysowned, color = evegender)) +
  geom_line(data=summaryownedgender, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1))) +
  scale_color_manual(values=evegenderPalette)
ggsave("outputall/infant_death_rate_by_days_owned_and_gender.png", width = w, height = h)


# Separated daysplayed

lives %>%
  group_by(daysplayed, evegender) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1)
    ) -> summaryplayedgender

ggplot(summaryplayedgender,
    aes(daysplayed, color = evegender)) +
  geom_line(data=summaryplayedgender, aes(y=mean_lifetime)) +
  geom_smooth(data=lives, aes(y=lifetime)) +
  scale_color_manual(values=evegenderPalette)
ggsave("outputall/mean_lifetime_by_days_played_and_gender.png", width = w, height = h)

ggplot(summaryplayedgender,
    aes(daysplayed, color = evegender)) +
  geom_line(data=summaryplayedgender, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1))) +
  scale_color_manual(values=evegenderPalette)
ggsave("outputall/infant_death_rate_by_days_played_and_gender.png", width = w, height = h)

# Cohorts

lives %>%
  group_by(startweek, birthweek) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    sum_lifetime = sum(lifetime),
    infant_death_rate = mean(lt1),
    players = length(unique(hash))
  ) -> cohorts

dangerous %>%
  group_by(startweek, birthweek) %>%
  summarize(
    mean_kills = mean(kills)
  ) -> cohortskills

ggplot(cohorts, aes(birthweek, startweek)) +
  geom_raster(aes(fill=players)) +
  scale_y_discrete(limits=rev(unique(cohorts$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  scale_fill_gradientn(colours = topo.colors(6)) +
  geom_text(majorupdates, mapping = aes(x= week, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("outputall/unique_players_by_cohorts.png", width = w, height = h)

ggplot(cohorts, aes(birthweek, startweek)) +
  geom_raster(aes(fill=log(players))) +
  scale_y_discrete(limits=rev(unique(cohorts$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  geom_text(majorupdates, mapping = aes(x= week, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("outputall/unique_players_by_cohorts_log.png", width = w, height = h)

ggplot(cohorts, aes(birthweek, startweek)) +
  geom_raster(aes(fill=sum_lifetime/players)) +
  scale_y_discrete(limits=rev(unique(cohorts$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  geom_text(majorupdates, mapping = aes(x= week, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("outputall/average_playtime_per_player_by_cohorts.png", width = w, height = h)

ggplot(cohorts, aes(birthweek, startweek)) +
  geom_raster(aes(fill=mean_lifetime)) +
  scale_y_discrete(limits=rev(unique(cohorts$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  geom_text(majorupdates, mapping = aes(x= week, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("outputall/mean_lifetime_by_cohorts.png", width = w, height = h)

ggplot(cohorts, aes(birthweek, startweek)) +
  geom_raster(aes(fill=infant_death_rate)) +
  scale_y_discrete(limits=rev(unique(cohorts$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  geom_text(majorupdates, mapping = aes(x= week, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("outputall/infant_death_rate_by_cohorts.png", width = w, height = h)

ggplot(cohortskills, aes(birthweek, startweek)) +
  geom_raster(aes(fill=mean_kills)) +
  scale_y_discrete(limits=rev(unique(cohortskills$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  geom_text(majorupdates, mapping = aes(x= week, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("outputall/mean_kills_by_cohorts.png", width = w, height = h)


# Violin

ggplot(lives, aes(evegender, age, color = evegender)) +
  geom_violin() +
  scale_color_manual(values=evegenderPalette)
ggsave("outputall/age_distribution_by_gender.png", width = w, height = h)
