## ----echo = FALSE, message = FALSE---------------------------------------
# run setup script
source(here::here("wilke-purl", "_common.R"))

library(lubridate)

## ----mpg-cty-displ-solid, fig.width=5.5, fig.asp=.7416, fig.cap='(ref:mpg-cty-displ-solid)'----
p_mpg_solid <- ggplot(mpg, aes(y = cty, x = displ, color = drv, fill = drv)) +
  geom_point(size = 3, shape = 21) + 
  ylab("fuel economy (mpg)") +
  xlab("displacement (l)") +
  scale_color_manual(values=c("#202020", "#E69F00", "#56B4E9"), 
                     name="drive train",
                     breaks=c("f", "r", "4"),
                     labels=c("FWD", "RWD", "4WD")) +
  scale_fill_manual(values=c("#202020", "#E69F00", "#56B4E9"), 
                     name="drive train",
                     breaks=c("f", "r", "4"),
                     labels=c("FWD", "RWD", "4WD")) +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(legend.position = c(.7, .8),
        plot.margin = margin(3, 7, 3, 0))

stamp_bad(p_mpg_solid)

## ----mpg-cty-displ-transp, fig.width=5.5, fig.asp=.7416, fig.cap='(ref:mpg-cty-displ-transp)'----
p_mpg_transp <- ggplot(mpg, aes(y = cty, x = displ, color = drv, fill = drv)) +
  geom_point(size = 3, shape = 21) + 
  ylab("fuel economy (mpg)") +
  xlab("displacement (l)") +
  scale_color_manual(values=c("#202020", "#E69F00", "#56B4E9"), 
                     name="drive train",
                     breaks=c("f", "r", "4"),
                     labels=c("FWD", "RWD", "4WD")) +
  scale_fill_manual(values=c("#20202080", "#E69F0080", "#56B4E980"), 
                     name="drive train",
                     breaks=c("f", "r", "4"),
                     labels=c("FWD", "RWD", "4WD")) +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(legend.position = c(.7, .8),
        plot.margin = margin(3, 7, 3, 0))

p_mpg_transp

## ----mpg-cty-displ-jitter, fig.width=5.5, fig.asp=.7416, fig.cap='(ref:mpg-cty-displ-jitter)'----
p_mpg_jitter <- ggplot(mpg, aes(y = cty, x = displ, color = drv, fill = drv)) +
  geom_point(size = 3, shape = 21,
             position = position_jitter(width = 0.01 * diff(range(mpg$displ)),
                                        height = 0.01 * diff(range(mpg$cty)),
                                        seed = 7384)) + 
  ylab("fuel economy (mpg)") +
  xlab("displacement (l)") +
  scale_color_manual(values=c("#202020", "#E69F00", "#56B4E9"), 
                     name="drive train",
                     breaks=c("f", "r", "4"),
                     labels=c("FWD", "RWD", "4WD")) +
  scale_fill_manual(values=c("#20202080", "#E69F0080", "#56B4E980"), 
                     name="drive train",
                     breaks=c("f", "r", "4"),
                     labels=c("FWD", "RWD", "4WD")) +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(legend.position = c(.7, .8),
        plot.margin = margin(3, 7, 3, 0))

p_mpg_jitter

## ----mpg-cty-displ-jitter-extreme, fig.width=5.5, fig.asp=.7416, fig.cap='(ref:mpg-cty-displ-jitter-extreme)'----
p_mpg_jitter_extreme <- ggplot(mpg, aes(y = cty, x = displ, color = drv, fill = drv)) +
  geom_point(size = 3, shape = 21,
             position = position_jitter(width = 0.1 * diff(range(mpg$displ)),
                                        height = 0.1 * diff(range(mpg$cty)))) + 
  scale_x_continuous(breaks = 2:7) +
  ylab("fuel economy (mpg)") +
  xlab("displacement (l)") +
  scale_color_manual(values=c("#202020", "#E69F00", "#56B4E9"), 
                     name="drive train",
                     breaks=c("f", "r", "4"),
                     labels=c("FWD", "RWD", "4WD")) +
  scale_fill_manual(values=c("#20202080", "#E69F0080", "#56B4E980"), 
                     name="drive train",
                     breaks=c("f", "r", "4"),
                     labels=c("FWD", "RWD", "4WD")) +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(legend.position = c(.7, .8),
        plot.margin = margin(3, 7, 3, 0))

stamp_bad(p_mpg_jitter_extreme)

## ----nycflights-points, fig.asp = 0.75, fig.cap = '(ref:nycflights-points)'----
# break points along the x axis
breaks_x <- c("0:00", "6:00", "12:00", "18:00", "24:00")

p_flights_base <- ggplot(flight_delays, aes(`departure time`, `departure delay (minutes)`)) + 
  geom_abline(slope = 0, intercept = 0, color="grey80") +
  scale_x_time(
    name = "departure time",
    breaks = hm(breaks_x),
    labels = breaks_x
  ) +
  scale_y_continuous(
    name = "departure delay (minutes)"
  ) +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(plot.margin = margin(3, 7, 3, 0))
  
p_flights_scatter <- p_flights_base + geom_point(alpha = 0.2)

stamp_bad(p_flights_scatter)

## ----nycflights-2d-bins, fig.asp = 0.75, fig.cap = '(ref:nycflights-2d-bins)'----
p_flights_2d_bins <- p_flights_base +
  geom_bin2d(bins=50) +
  #scale_fill_continuous_sequential(palette = "Blue-Yellow", l2 = 90, c2 = 20) +
    scale_fill_continuous_sequential(
    h1 = -83, h2 = 20, c1 = 30, cmax = 40, c2 = 0, l1 = 20, l2 = 100, p1 = 1, p2 = 1.2, 
    rev = TRUE,
    begin = 0.2,
    name = "departures"
  ) +
  theme(legend.position = c(0.85, .85))

p_flights_2d_bins

## ----nycflights-hex-bins, fig.asp = 0.75, fig.cap = '(ref:nycflights-hex-bins)'----
p_flights_hex_bins <- p_flights_base +
  geom_hex(bins=50) +
  #scale_fill_continuous_sequential(palette = "Blue-Yellow", l2 = 90, c2 = 20) +
  scale_fill_continuous_sequential(
    h1 = -83, h2 = 20, c1 = 30, cmax = 40, c2 = 0, l1 = 20, l2 = 100, p1 = 1, p2 = 1.2, 
    rev = TRUE,
    begin = 0.2,
    name = "departures"
  ) +
  theme(legend.position = c(0.85, .85))

p_flights_hex_bins

## ----blue-jays-contour, fig.width = 6, fig.asp = 3/4, fig.cap='(ref:blue-jays-contour)'----

blue_jays_base <- ggplot(blue_jays, aes(Mass, Head)) + 
  scale_x_continuous(
    limits = c(57, 82),
    expand = c(0, 0),
    name = "body mass (g)") +
  scale_y_continuous(
    limits = c(49, 61),
    expand = c(0, 0),
    name = "head length (mm)"
  ) +
  theme_dviz_grid(font_family = "Roboto Light")

blue_jays_base + 
  stat_density_2d(color = "black", size = 0.4, binwidth = 0.004) +
  geom_point(color = "black", size = 1.5, alpha = 1/3)

## ----blue-jays-contour-filled, fig.width = 6, fig.asp = 3/4, fig.cap='(ref:blue-jays-contour-filled)'----
blue_jays_base + 
  stat_density_2d(aes(fill = ..level..), geom = "polygon", color = "black", size = 0.15, binwidth = 0.004) +
  geom_point(color = "black", size = 1.5, alpha = .4) +
  scale_fill_gradient(low = "grey95", high = "grey70", guide = "none")

## ----blue-jays-contour-by-sex, fig.width = 6, fig.asp = 3/4, fig.cap='(ref:blue-jays-contour-by-sex)'----
blue_jays_base + 
  aes(color = KnownSex) +
  stat_density_2d(size = 0.4, binwidth = 0.006) +
  geom_point(size = 1.5, alpha = 0.7) +
  scale_color_manual(
    values = c(F = "#D55E00", M = "#0072B2"),
    breaks = c("F", "M"),
    labels = c("female birds   ", "male birds"),
    name = NULL,
    guide = guide_legend(
      direction = "horizontal",
      override.aes = list(size = 2, linetype = 0)
    )
  ) +
  theme_dviz_grid(font_family = "Roboto Light") +
  theme(
    legend.position = c(1, 0),
    legend.justification = c(1, 0),
    #legend.position = "top",
    #legend.justification = "right",
    #legend.box.spacing = unit(3.5, "pt"), # distance between legend and plot
    legend.text = element_text(vjust = 0.6),
    legend.spacing.x = unit(2, "pt"),
    legend.background = element_rect(fill = "white", color = NA),
    #legend.key.width = unit(10, "pt")
    axis.ticks.length = unit(0, "pt"),
    axis.ticks = element_blank()
  )

## ----diamonds-points, fig.asp = 3/4, fig.cap = '(ref:diamonds-points)'----
p <- ggplot(diamonds, aes(carat, price, color = cut)) + 
  geom_point(size = .2, alpha = 1/5) +
  scale_x_continuous(
    limits = c(-1, 5.1)
  ) +
  scale_y_log10(
    name = "price (USD)",
    breaks = c(300, 1000, 3000, 10000),
    labels = c("$300", "$1,000", "$3,000", "$10,000")
  ) +
  scale_color_discrete_sequential(
    palette = "Inferno",
    nmax = 6,
    order = 1:5,
    breaks = c("Ideal", "Premium", "Very Good", "Good", "Fair"),
    labels = c("ideal", "premium", "very good", "good", "fair"),
    guide = guide_legend(
      override.aes = list(size = 2, alpha = 1)
    )
  ) +
  coord_cartesian(xlim = c(-.1, 3.2), ylim = c(240, 25000), expand = FALSE) + 
  theme_dviz_grid(font_family = "Roboto Light") +
  panel_border() +
  theme(
    plot.margin = margin(18, 7, 1, 0),
    legend.key.width = unit(6, "pt"),
    legend.spacing.y = unit(3, "pt"),
    legend.title = element_text(hjust = 0, margin = margin(0, 0, 0, 0)),
    legend.position = c(.97, .3),
    legend.justification = c(1, 0.5),
    legend.box.margin = margin(7, 7, 7, 7),
    legend.box.background = element_rect(fill = "white", color = NA),
    axis.ticks.length = unit(0, "pt")
  )

stamp_bad(p)

## ----diamonds-contour-colors, fig.asp = 3/4, fig.cap = '(ref:diamonds-contour-colors)'----
p <- ggplot(diamonds, aes(carat, price, color = cut)) + 
  geom_density2d(size = .35, binwidth = 0.8) +
  scale_x_continuous(
    limits = c(-1, 5.1)
  ) +
  scale_y_log10(
    name = "price (USD)",
    breaks = c(300, 1000, 3000, 10000),
    labels = c("$300", "$1,000", "$3,000", "$10,000")
  ) +
  scale_color_discrete_sequential(
    palette = "Inferno",
    nmax = 6,
    order = 1:5,
    breaks = c("Ideal", "Premium", "Very Good", "Good", "Fair"),
    labels = c("ideal", "premium", "very good", "good", "fair"),
    guide = guide_legend(
      override.aes = list(size = 0.5)
    )
  ) +
  coord_cartesian(xlim = c(-.1, 2.3), ylim = c(240, 25000), expand = FALSE) + 
  theme_dviz_grid(font_family = "Roboto Light") +
  panel_border() +
  theme(
    plot.margin = margin(18, 7, 1, 0),
    legend.spacing.y = unit(3, "pt"),
    legend.title = element_text(hjust = 0, margin = margin(0, 0, 0, 0)),
    legend.position = c(.97, .3),
    legend.justification = c(1, 0.5),
    legend.box.margin = margin(7, 7, 7, 7),
    legend.box.background = element_rect(fill = "white", color = NA),
    axis.ticks.length = unit(0, "pt")
  )

stamp_bad(p)

## ----diamonds-contour-facets, fig.width = 8.5, fig.asp = 3/4, fig.cap = "(ref:diamonds-contour-facets)"----
ggplot(diamonds, aes(carat, price)) + 
  stat_density_2d(aes(fill = ..level..), geom = "polygon", color = darken("#0072B2", .2), size = .3, binwidth = 0.8) +
  #geom_density2d(color = darken("#0072B2", .2), size = .3, binwidth = 0.8) +
  scale_fill_gradient(low = desaturate(lighten("#0072B2", .9), .6), high = desaturate(lighten("#0072B2", .6), .6), guide = "none") +
  scale_x_continuous(
    limits = c(-1, 5.1)
  ) +
  scale_y_log10(
    name = "price (USD)",
    breaks = c(300, 1000, 3000, 10000),
    labels = c("$300", "$1,000", "$3,000", "$10,000")
  ) +
  coord_cartesian(xlim = c(-.1, 2.3), ylim = c(200, 25000), expand = FALSE) + 
  facet_wrap(~cut, scales = "free_x", labeller = labeller(cut = tolower)) +
  theme_dviz_grid(font_family = "Roboto Light") +
  panel_border() +
  theme(
    legend.title = element_text(hjust = 0.5),
    legend.position = c(.95, .05),
    legend.justification = c(1, 0),
    axis.ticks.length = unit(0, "pt")
  )

