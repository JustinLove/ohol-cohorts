library("dplyr")
library("ggplot2")
evegenderPalette <- c("#E69F00", "#56B4E9", "#D55E00")
w <- 7
h <- 7

dangerous <- lives[lives$age >= 8,]

ggplot(lives, aes(gameday)) + geom_freqpoly() + labs(y = "lives") +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("output/density_days_released.png", width = w, height = h)

# Combined gameday

lives %>%
  group_by(gameday) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    sum_lifetime = sum(lifetime),
    infant_death_rate = mean(lt1),
    players = length(unique(hash))
    ) -> summarygame

dangerous %>%
  group_by(gameday) %>%
  summarize(
    mean_kills = mean(kills)
    ) -> summarygamekills

ggplot(summarygame, aes(gameday, players)) +
  geom_line() +
  geom_smooth(span = 0.1) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("output/unique_players_by_days_released.png", width = w, height = h)

ggplot(summarygamekills, aes(gameday)) +
  geom_line(data=summarygamekills, aes(y=mean_kills)) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("output/mean_kills_by_days_released.png", width = w, height = h)
#geom_smooth(data=dangerous, aes(y=kills)) +
  

ggplot(summarygame, aes(gameday)) +
  geom_line(data=summarygame, aes(y=mean_lifetime)) +
  geom_smooth(data=lives, aes(y=lifetime)) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("output/mean_lifetime_by_days_released.png", width = w, height = h)

ggplot(summarygame, aes(gameday)) +
  geom_line(data=summarygame, aes(y=sum_lifetime/players)) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("output/average_playtime_per_player_days_released.png", width = w, height = h)

ggplot(summarygame, aes(gameday)) +
  geom_line(data=summarygame, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1))) +
  geom_text(majorupdates, mapping = aes(x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("output/infant_death_rate_by_days_released.png", width = w, height = h)


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
ggsave("output/mean_lifetime_by_days_released_and_gender.png", width = w, height = h)

ggplot(summarygamegender,
    aes(gameday, color = evegender)) +
  geom_line(data=summarygamegender, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1))) +
  scale_color_manual(values=evegenderPalette) +
  geom_text(majorupdates, mapping = aes(color = 'M', x= gameday, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("output/infant_death_rate_by_days_released_and_gender.png", width = w, height = h)


# Cohorts

lives %>%
  group_by(startweek, birthweek) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    sum_lifetime = sum(lifetime),
    infant_death_rate = mean(lt1),
    players = length(unique(hash)),
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
ggsave("output/unique_players_by_cohorts.png", width = w, height = h)

ggplot(cohorts, aes(birthweek, startweek)) +
  geom_raster(aes(fill=log(players))) +
  scale_y_discrete(limits=rev(unique(cohorts$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  geom_text(majorupdates, mapping = aes(x= week, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("output/unique_players_by_cohorts_log.png", width = w, height = h)

ggplot(cohorts, aes(birthweek, startweek)) +
  geom_raster(aes(fill=sum_lifetime/players)) +
  scale_y_discrete(limits=rev(unique(cohorts$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  geom_text(majorupdates, mapping = aes(x= week, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("output/average_playtime_per_player_by_cohorts.png", width = w, height = h)

ggplot(cohorts, aes(birthweek, startweek)) +
  geom_raster(aes(fill=mean_lifetime)) +
  scale_y_discrete(limits=rev(unique(cohorts$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  geom_text(majorupdates, mapping = aes(x= week, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("output/mean_lifetime_by_cohorts.png", width = w, height = h)

ggplot(cohorts, aes(birthweek, startweek)) +
  geom_raster(aes(fill=infant_death_rate)) +
  scale_y_discrete(limits=rev(unique(cohorts$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  geom_text(majorupdates, mapping = aes(x= week, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("output/infant_death_rate_by_cohorts.png", width = w, height = h)

ggplot(cohortskills, aes(birthweek, startweek)) +
  geom_raster(aes(fill=mean_kills)) +
  scale_y_discrete(limits=rev(unique(cohortskills$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  geom_text(majorupdates, mapping = aes(x= week, label = name, y = 0, angle=90, hjust=0), size=3)
ggsave("output/mean_kills_by_cohorts.png", width = w, height = h)


# Violin

ggplot(lives, aes(evegender, age, color = evegender)) +
  geom_violin() +
  scale_color_manual(values=evegenderPalette)
ggsave("output/age_distribution_by_gender.png", width = w, height = h)

ggplot(lives, aes(evegender, age, color = evegender)) +
  facet_wrap(~birthweek) +
  geom_violin() +
  scale_color_manual(values=evegenderPalette)
ggsave("output/age_distribution_by_gender_by_week.png", width = w*2, height = h*2)
