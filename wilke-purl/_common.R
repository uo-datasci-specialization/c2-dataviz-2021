set.seed(7654)
options(digits = 3)

options(dplyr.print_min = 6, dplyr.print_max = 6)

library(dviz.supp)

tech_stocks <- ungroup(tech_stocks)
blue_jays <- ungroup(blue_jays)

dviz_font_family <- "Roboto Light"