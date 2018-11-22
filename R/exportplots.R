library("dplyr")
library("ggplot2")
evegenderPalette <- c("#E69F00", "#56B4E9", "#D55E00")

ggplot(lives, aes(gameday)) + geom_freqpoly() + labs(y = "lives")
ggsave("density_days_released.png")

ggplot(lives, aes(daysowned)) + geom_freqpoly() + labs(y = "lives")
ggsave("density_days_owned.png")

ggplot(lives, aes(daysplayed)) + geom_freqpoly() + labs(y = "lives")
ggsave("density_days_played.png")

# Combined gameday

lives %>%
  group_by(gameday) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1),
    players = length(unique(hash))
    ) -> summarygame

ggplot(summarygame, aes(gameday, players)) +
  geom_point() +
  geom_smooth()
ggsave("unique_players_by_days_released.png")

ggplot(summarygame, aes(gameday, players)) +
  geom_point() +
  geom_smooth()
ggsave("mean_lifetime_by_days_released.png")

ggplot(summarygame, aes(gameday)) +
  geom_point(data=summarygame, aes(y=mean_lifetime)) +
  geom_smooth(data=lives, aes(y=lifetime))
ggsave("mean_lifetime_by_days_released.png")

ggplot(summarygame, aes(gameday)) +
  geom_point(data=summarygame, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1)))
ggsave("infant_death_rate_by_days_released.png")

# Combined daysowned

lives %>%
  group_by(daysowned) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1)
    ) -> summaryowned

ggplot(summaryowned, aes(daysowned)) +
  geom_point(data=summaryowned, aes(y=mean_lifetime)) +
  geom_smooth(data=lives, aes(y=lifetime))
ggsave("mean_lifetime_by_days_owned.png")

ggplot(summaryowned, aes(daysowned)) +
  geom_point(data=summaryowned, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1)))
ggsave("infant_death_rate_by_days_owned.png")


# Combined daysplayed

lives %>%
  group_by(daysplayed) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1)
    ) -> summaryplayed

ggplot(summaryplayed, aes(daysplayed)) +
  geom_point(data=summaryplayed, aes(y=mean_lifetime)) +
  geom_smooth(data=lives, aes(y=lifetime))
ggsave("mean_lifetime_by_days_played.png")

ggplot(summaryplayed, aes(daysplayed)) +
  geom_point(data=summaryplayed, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1)))
ggsave("infant_death_rate_by_days_played.png")


# Separated gameday

lives %>%
  group_by(gameday, evegender) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1)
    ) -> summarygamegender

ggplot(summarygamegender,
    aes(gameday, color = evegender)) +
  geom_point(data=summarygamegender, aes(y=mean_lifetime)) +
  geom_smooth(data=lives, aes(y=lifetime)) +
  scale_color_manual(values=evegenderPalette)
ggsave("mean_lifetime_by_days_released_and_gender.png")

ggplot(summarygamegender,
    aes(gameday, color = evegender)) +
  geom_point(data=summarygamegender, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1))) +
  scale_color_manual(values=evegenderPalette)
ggsave("infant_death_rate_by_days_released_and_gender.png")

# Separated daysowned

lives %>%
  group_by(daysowned, evegender) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1)
    ) -> summaryownedgender

ggplot(summaryownedgender,
    aes(daysowned, color = evegender)) +
  geom_point(data=summaryownedgender, aes(y=mean_lifetime)) +
  geom_smooth(data=lives, aes(y=lifetime)) +
  scale_color_manual(values=evegenderPalette)
ggsave("mean_lifetime_by_days_owned_and_gender.png")

ggplot(summaryownedgender,
    aes(daysowned, color = evegender)) +
  geom_point(data=summaryownedgender, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1))) +
  scale_color_manual(values=evegenderPalette)
ggsave("infant_death_rate_by_days_owned_and_gender.png")


# Separated daysplayed

lives %>%
  group_by(daysplayed, evegender) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1)
    ) -> summaryplayedgender

ggplot(summaryplayedgender,
    aes(daysplayed, color = evegender)) +
  geom_point(data=summaryplayedgender, aes(y=mean_lifetime)) +
  geom_smooth(data=lives, aes(y=lifetime)) +
  scale_color_manual(values=evegenderPalette)
ggsave("mean_lifetime_by_days_played_and_gender.png")

ggplot(summaryplayedgender,
    aes(daysplayed, color = evegender)) +
  geom_point(data=summaryplayedgender, aes(y=infant_death_rate)) +
  geom_smooth(data=lives, aes(y=as.numeric(lt1))) +
  scale_color_manual(values=evegenderPalette)
ggsave("infant_death_rate_by_days_played_and_gender.png")

# Cohorts

lives %>%
  group_by(startweek, birthweek) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1),
    players = length(unique(hash))
  ) -> cohorts

ggplot(cohorts, aes(birthweek, startweek)) +
  geom_raster(aes(fill=players)) +
  scale_y_discrete(limits=rev(unique(cohorts$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  scale_fill_gradientn(colours = topo.colors(6))
ggsave("unique_players_by_cohorts.png")

ggplot(cohorts, aes(birthweek, startweek)) +
  geom_raster(aes(fill=log(players))) +
  scale_y_discrete(limits=rev(unique(cohorts$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))
ggsave("unique_players_by_cohorts_log.png")

ggplot(cohorts, aes(birthweek, startweek)) +
  geom_raster(aes(fill=mean_lifetime)) +
  scale_y_discrete(limits=rev(unique(cohorts$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))
ggsave("mean_lifetime_by_cohorts.png")

ggplot(cohorts, aes(birthweek, startweek)) +
  geom_raster(aes(fill=infant_death_rate)) +
  scale_y_discrete(limits=rev(unique(cohorts$startweek))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))
ggsave("infant_death_rate_by_cohorts.png")

# Violin

ggplot(lives, aes(evegender, age, color = evegender)) +
  geom_violin() +
  scale_color_manual(values=evegenderPalette)
ggsave("age_distribution_by_gender.png")
