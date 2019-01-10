playerstats <- function(lives) {
  print("timeplayed")
  lives$playertime <- ave(lives$lifetime, lives$hash,
                          FUN = function(times) {
                            c(0,cumsum(times)[-length(times)])
                          })
  lives$daysplayed <- round(lives$playertime / (60*24))
  print("calculate started")
  lives$started <- ave(lives$birthtime, lives$hash, FUN=min)
  # needs to be fixed for different years
  lives$startweek <- strftime(as.POSIXct(lives$started, tz = "GMT", "1970-01-01"), format="%G-%V")
  lives$birthweek <- strftime(as.POSIXct(lives$birthtime, tz = "GMT", "1970-01-01"), format="%G-%V")
  lives$daysowned <- round((lives$birthtime - lives$started) / (60*60*24))
  lives$gameday <- round((lives$birthtime - lives$birthtime[1]) / (60*60*24))
  lives$lt1 <- lives$lifetime < 1
  lives$lt3 <- lives$lifetime < 3
  lives
}
