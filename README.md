# One Hour One Life Cohorts

The developer of OHOL [posed a question](https://onehouronelife.com/forums/viewtopic.php?pid=35163#p35163)

> Player life expectancy (average life time per day) vs. number of days since game purchase.

I thought it would be a fun exercise to play with [R](https://www.r-project.org/). Several caveats:

- I don't have a statistics background. No controls have been attempted, and I might be looking at the wrong things.
- I think I've combined servers and such correctly, but maybe I didn't.
- I believe data was last fetched yesterday morning, 2018-11-13.

I was also curious about other related questions. For instance, days owned, which might have long gaps, vs. time played. I reduced it to days as well to get approximately similar units.

Finally, I thought it would be interesting to try a (totally unskilled) cohort analysis to see how different groups of players (week started with arbitrary week alignment) game updates interacted (Still haven't gotten a game update overlay).

## Dependencies

This currently assumes things about peer directories in my filesystem, in particular it is using the lifelog data cached by [ohol-family-trees](https://github.com/JustinLove/ohol-family-trees)
