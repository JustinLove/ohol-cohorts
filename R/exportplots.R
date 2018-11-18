library("dplyr")
library("ggplot2")
evegenderPalette <- c("#E69F00", "#56B4E9", "#D55E00")

# Combined daysowned

lives %>%
  group_by(daysowned) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1)
    ) -> summaryowned

ggplot(summaryowned, aes(daysowned, mean_lifetime)) +
  geom_point()
ggsave("mean_lifetime_by_days_owned.png")

ggplot(summaryowned, aes(daysowned, infant_death_rate)) +
  geom_point()
ggsave("infant_death_rate_by_days_owned.png")

# Combined daysplayed

lives %>%
  group_by(daysplayed) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1)
    ) -> summaryplayed

ggplot(summaryplayed, aes(daysplayed, mean_lifetime)) +
  geom_point()
ggsave("mean_lifetime_by_days_played.png")

ggplot(summaryplayed, aes(daysplayed, infant_death_rate)) +
  geom_point()
ggsave("infant_death_rate_by_days_played.png")

# Separated daysowned

lives %>%
  group_by(daysowned, evegender) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1)
    ) -> summaryownedgender

ggplot(summaryownedgender,
    aes(daysowned, mean_lifetime, color = evegender)) +
  geom_point() +
  scale_color_manual(values=evegenderPalette)
ggsave("mean_lifetime_by_days_owned_and_gender.png")

ggplot(summaryownedgender,
    aes(daysowned, infant_death_rate, color = evegender)) +
  geom_point() +
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
    aes(daysplayed, mean_lifetime, color = evegender)) +
  geom_point() +
  scale_color_manual(values=evegenderPalette)
ggsave("mean_lifetime_by_days_played_and_gender.png")

ggplot(summaryplayedgender,
    aes(daysplayed, infant_death_rate, color = evegender)) +
  geom_point() +
  scale_color_manual(values=evegenderPalette)
ggsave("infant_death_rate_by_days_played_and_gender.png")

# Cohorts

lives %>%
  group_by(startweek, birthweek) %>%
  summarize(
    mean_lifetime = mean(lifetime),
    infant_death_rate = mean(lt1)
  ) -> cohorts

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
