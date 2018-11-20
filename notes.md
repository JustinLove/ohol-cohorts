day1 <- read.table("../ohol-family-trees/cache/lifeLog_server1.onehouronelife.com/2018_11November_06_Tuesday.txt", header=FALSE, sep=" ")

logs <- loaddirectory( "../ohol-family-trees/cache/lifeLog_server1.onehouronelife.com/")
lives <- derivedlives(logs)


servers <- 1:15
serverpaths <- paste("../ohol-family-trees/cache/lifeLog_server", servers, ".onehouronelife.com/", sep = "")
serverlogs <- lapply(serverpaths, FUN=loaddirectory)
serverlives <- lapply(serverlogs, FUN=derivedlives)
lives <- do.call("rbind", serverlives)
lives <- playerstats(lives)

tapply(lives$lifetime, lives$daysowned, mean)

lives$lt1 <- lives$lifetime < 1
plot(tapply(lives$lt1, lives$daysplayed, mean))
plot(tapply(lives$lt1, lives$dayowned, mean))

lives$gameday <- round((lives$birthtime - lives$birthtime[1]) / (60*60*24))

tapply(lives$lifetime, list(lives$daysowned, lives$gender), mean)

library("dplyr")
lives %>% group_by(daysplayed, evegender) %>% summarize(mean_lifetime = mean(lifetime), infant_death_rate = mean(lt1)) -> summaryplayed
lives %>% group_by(daysowned, evegender) %>% summarize(mean_lifetime = mean(lifetime), infant_death_rate = mean(lt1)) -> summaryowned
summaryowned %>% with(plot(daysowned, lifetime, col = gender))

library("ggplot2")
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
ggplot(summaryplayed, aes(daysplayed, infant_death_rate, color = evegender)) + geom_point() + scale_color_manual(values=cbPalette)

lives %>% group_by(startweek, birthweek) %>% summarize(mean_lifetime = mean(lifetime), infant_death_rate = mean(lt1)) -> cohorts
ggplot(cohorts, aes(birthweek, startweek)) + geom_raster(aes(fill=mean_lifetime)) + scale_y_discrete(limits=rev(unique(cohorts$startweek)))

ggplot(lives, aes(evegender, age, color = evegender)) + geom_violin() + scale_color_manual(values=cbPalette)


https://onehouronelife.com/forums/viewtopic.php?pid=35163#p35163
"Player life expectancy (average life time per day) vs. number of days since game purchase."

density plot of days owned and days played
curve of best fit
- mean_lifetime vs. days owned
- infant death rate vs. days owned
confidence interval `geom_smooth`
