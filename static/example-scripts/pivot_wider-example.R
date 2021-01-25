library(tidyverse)
set.seed(42) # for reproducibility

example_good <- tibble(
  sid = c(1, 1, 1, 2, 2, 2, 3, 3, 3),
  season = rep(c("fall", "winter", "spring"), 3),
  score = rnorm(9)
) 

example_good %>% 
  pivot_wider(names_from = "season",
              values_from = "score")

# we can move them to wide because each SID is associated
# with only one season/score combination. This doesn't work
# if one of the students  had two scores in a season

example_bad <- bind_rows(
  example_good,
  tibble(sid = 3, season = "winter", score = rnorm(1))
)

example_bad %>% 
  pivot_wider(names_from = "season",
              values_from = "score")

# This happens because it doesn't know what to do with the duplicate key.
# The message gives us more information. We can identify it (perhaps to delete
# one of them), or we could summarize it (e.g., take the mean). Let's identify
# first

example_bad %>% 
  pivot_wider(names_from = "season",
              values_from = "score",
              values_fn = length)

# And we see that sid 2 has two observations in the winter. So it doesn't make
# sense to move it this way. The rows need to be uniquely identified. Next let's
# take the mean

example_bad %>% 
  pivot_wider(names_from = "season",
              values_from = "score",
              values_fn = mean)

# And now it works. We could also inspect them more closely to figure out what 
# to do

example_bad %>% 
  filter(sid == 3 & season == "winter")

# maybe we know something about the data and we know the second score was 
# entered incorrectly. We could delete this observation from our dataset by
# using a filtering join

to_remove <- example_bad %>% 
  filter(sid == 3 & season == "winter") %>% 
  slice(2)

fixed <- anti_join(example_bad, to_remove)

# And now our pivot wider works again
fixed %>% 
  pivot_wider(names_from = "season",
              values_from = "score")
