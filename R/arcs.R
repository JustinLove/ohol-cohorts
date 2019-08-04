for (i in 1:length(arcs[,1])) {
  bs2$arc[arcs$tsstart[i] <= bs2$birthtime & bs2$birthtime <= arcs$tsend[i]] <- i
  bs2$arcstart[arcs$tsstart[i] <= bs2$birthtime & bs2$birthtime <= arcs$tsend[i]] <- arcs$tsstart[i]
  
}
sub <- bs2[!is.na(bs2$arc),]
sub$arcbirth <- sub$birthtime - sub$arcstart
sub$arcbirthmin <- round(sub$arcbirth/60)
sub$arcdeath <- sub$deathtime - sub$arcstart
sub$arcdeathmin <- round(sub$arcdeath/60)

library("dplyr")
library("ggplot2")
evegenderPalette <- c("#E69F00", "#56B4E9", "#D55E00")
w <- 7
h <- 7

sub %>%
  group_by(arc,arcbirthmin) %>%
  summarize(
    infant_death_rate = mean(lt1),
    eve_rate = mean(is.na(parent)),
    births = length(arcbirthmin),
    lineages = length(unique(line)),
    age = mean(age),
  ) -> summarybirth


ggplot(summarybirth, aes(arcbirthmin)) +
  facet_grid(arc ~ .) +
  geom_line(aes(y=age))


ksub %>%
  group_by(arc,arcdeathmin) %>%
  summarize(
    age = mean(age),
    deaths = length(arcdeathmin)
  ) -> summarydeath

ggplot(summarydeath, aes(arcdeathmin)) +
  facet_grid(arc ~ .) +
  geom_line(aes(y=age))

