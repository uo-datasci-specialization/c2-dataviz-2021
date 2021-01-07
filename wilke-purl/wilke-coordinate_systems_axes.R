## ----echo = FALSE, message = FALSE---------------------------------------
# run setup script
source(here::here("wilke-purl", "_common.R"))

library(lubridate)
library(forcats)
library(tidyr)
library(ggrepel)

## ----cartesian-coord, fig.asp = 0.8, fig.cap = '(ref:cartesian-coord)'----
df_points <- data.frame(x = c(-1, 0, 2),
                        y = c(-1, 0, 1),
                        label = c("(-1, -1)", "(0, 0)", "(2, 1)"),
                        vjust = c(1.4, -.8, -.8),
                        hjust = c(1.1, 1.1, -.1))

df_segments <- data.frame(x0 = c(0, 2, 0, -1),
                          x1 = c(2, 2, -1, -1),
                          y0 = c(1, 0, -1, 0),
                          y1 = c(1, 1, -1, -1))

df_labels <- data.frame(x = c(-1, -.5, 1, 2),
                        y = c(-.5, -1, 1, 0.5),
                        vjust = c(.5, 1.3, -.3, .5),
                        hjust = c(1.1, .5, .5, -.1),
                        label = c("y = -1", "x = -1", "x = 2", "y = 1"))

cartesian <- ggplot(df_points, aes(x, y)) +
  geom_hline(yintercept = 0, color = "gray60") +
  geom_vline(xintercept = 0, color = "gray60") +
  geom_segment(data = df_segments, aes(x = x0, xend = x1, y = y0, yend = y1),
               linetype = 2) +
  geom_point(color = "#0072B2") +
  geom_text(aes(label = label, vjust = vjust, hjust = hjust),
            size = 10, family = dviz_font_family) +
  geom_text(data = df_labels, aes(label = label, hjust = hjust, vjust = vjust),
            size = 10, family = dviz_font_family) +
  coord_fixed(xlim = c(-2.2, 3.2), ylim = c(-2.2, 2.2), expand = FALSE) +
  xlab("x axis") +
  ylab("y axis") +
  theme_dviz_grid(25, font_family = "Roboto Light") +
  theme(axis.ticks.length = grid::unit(0, "pt"))

## ----temperature-normals-Houston, fig.width = 6, fig.asp = 3/4, fig.cap = '(ref:temperature-normals-Houston)'----
temps_wide <- filter(ncdc_normals,
                station_id %in% c(
                  "USW00014819", # Chicago, IL 60638
                  "USC00516128", # Honolulu, HI 96813
                  "USW00027502", # Barrow, AK 99723, coldest point in the US
                  "USC00042319", # Death Valley, CA 92328 hottest point in the US
                  "USW00093107", # San Diego, CA 92145
                  "USW00012918", # Houston, TX 77061
                  "USC00427606"  # Salt Lake City, UT 84103
                )) %>%
  mutate(location = fct_recode(factor(station_id),
                               "Chicago" = "USW00014819",
                               "Honolulu" = "USC00516128",
                               "Barrow, AK" = "USW00027502",
                               "Death Valley" = "USC00042319",
                               "San Diego" = "USW00093107",
                               "Houston" = "USW00012918",
                               "Salt Lake City, UT" = "USC00427606")) %>%
  select(-station_id, -flag) %>%
  spread(location, temperature) %>%
  arrange(date)

temps_wide_label <- mutate(temps_wide,
                           label = ifelse(date %in% c(ymd("0000-01-01"), ymd("0000-04-01"), 
                                                      ymd("0000-07-01"), ymd("0000-10-01")),
                                          format(date, "%b 1st"), ""))

temp_plot <- ggplot(temps_wide_label, aes(x = date, y = `Houston`)) +
  geom_line(color = "#0072B2") +
  scale_x_date(name = "month", limits = c(ymd("0000-01-01"), ymd("0001-01-03")),
               breaks = c(ymd("0000-01-01"), ymd("0000-04-01"), ymd("0000-07-01"),
                          ymd("0000-10-01"), ymd("0001-01-01")),
               labels = c("Jan", "Apr", "Jul", "Oct", "Jan"), expand = c(2/366, 0)) + 
  scale_y_continuous(limits = c(50, 90),
                     name = "temperature (°F)") +
  theme_dviz_grid(25, font_family = "Roboto Light") +
  theme(plot.margin = margin(3, 12, 12, 0))

plot_grid(plot_grid(temp_plot, temp_plot, rel_widths = c(1, 2), labels = "auto"),
          temp_plot, rel_heights = c(1.5, 1), labels = c("", "c"), label_y = c(1, 1.15), ncol = 1)

## ----temperature-normals-Houston-San-Diego, fig.width = 8.5, fig.asp = 0.5, fig.cap = '(ref:temperature-normals-Houston-San-Diego)'----
tempsplot_F <- ggplot(temps_wide_label, aes(x = `San Diego`, y = `Houston`)) +
  geom_path(color = "#0072B2") +
  geom_text_repel(aes(label = label), point.padding = .4, color = "black",
                  min.segment.length = 0, size = 8,
                  family = dviz_font_family) +
  coord_fixed(xlim = c(45, 85), ylim = c(48, 88),
              expand = FALSE) +
  scale_color_continuous_qualitative(guide = "none") +
  scale_x_continuous(breaks = c(10*(5:8))) +
  xlab("temperature in San Diego (°F)") +
  ylab("temperature in Houston (°F)") +
  theme_dviz_grid(25, font_family = "Roboto Light") +
  theme(plot.margin = margin(3, 14, 3, 0))

# Fahrenheit to Celsius conversion

F2C <- function(t) {(t-32)*5/9}

tempsplot_C <- ggplot(temps_wide_label, aes(x = F2C(`San Diego`), y = F2C(`Houston`))) +
  geom_path(size = 1, color = "#0072B2") +
  geom_text_repel(aes(label = label), point.padding = .4, color = "black",
                  min.segment.length = 0, size = 12/.pt,
                  family = dviz_font_family) +
  coord_fixed(xlim = F2C(c(45, 85)), ylim = F2C(c(48, 88)),
              expand = FALSE) +
  scale_color_continuous_qualitative(guide = "none") +
  scale_x_continuous(breaks = c(5*(2:6))) +
  xlab("temperature in San Diego (°C)") +
  ylab("temperature in Houston (°C)") +
  theme_dviz_grid(font_family = "Roboto Light") +
  theme(plot.margin = margin(3, 14, 3, 0))


plot_grid(tempsplot_F, tempsplot_C, labels = "auto")

## ----linear-log-scales, fig.width = 6, fig.asp = 3/4, fig.cap = '(ref:linear-log-scales)'----
df <- data.frame(x = c(1, 3.16, 10, 31.6, 100))

xaxis_lin <- ggplot(df, aes(x, y = 1)) + 
  geom_point(size = 3, color = "#0072B2") + 
  scale_y_continuous(limits = c(0.8, 1.2), expand = c(0, 0), breaks = 1) +
  theme_dviz_grid(14, rel_large = 1, font_family = "Roboto Light") +
  theme(axis.ticks.length = grid::unit(0, "pt"),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        plot.title = element_text(face = "plain"),
        plot.margin = margin(3, 14, 3, 0))

xaxis_log <- ggplot(df, aes(log10(x), y = 1)) + 
  geom_point(size = 3, color = "#0072B2") + 
  scale_y_continuous(limits = c(0.8, 1.2), expand = c(0, 0), breaks = 1) +
  theme_dviz_grid(14, rel_large = 1, font_family = "Roboto Light") +
  theme(axis.ticks.length = grid::unit(0, "pt"),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        plot.title = element_text(face = "plain"),
        plot.margin = margin(3, 14, 3, 0))

plotlist <- 
  align_plots(xaxis_lin + scale_x_continuous(limits = c(0, 100)) + 
                ggtitle("original data, linear scale"),
              xaxis_log + scale_x_continuous(limits = c(0, 2)) +
                xlab(expression(paste("log"["10"], "(x)"))) + 
                ggtitle("log-transformed data, linear scale"),
              xaxis_lin + scale_x_log10(limits = c(1, 100), breaks = c(1, 3.16, 10, 31.6, 100),
                                        labels = c("1", "3.16", "10", "31.6", "100")) + 
                ggtitle("original data, logarithmic scale"),
              xaxis_lin + scale_x_log10(limits = c(1, 100), breaks = c(1, 3.16, 10, 31.6, 100),
                                        labels = c("1", "3.16", "10", "31.6", "100")) +
                xlab(expression(paste("log"["10"], "(x)"))) + 
                ggtitle("logarithmic scale with incorrect axis title"),
              align = 'vh')

plot_grid(plotlist[[1]], plotlist[[2]], plotlist[[3]], stamp_wrong(plotlist[[4]]), ncol = 1)


## ----texas-counties-pop-ratio-log, fig.width = 7.5, fig.asp = 0.6, fig.cap = '(ref:texas-counties-pop-ratio-log)'----
set.seed(3878)
US_census %>% filter(state == "Texas") %>%
  select(name, pop2010) %>%
  extract(name, "county", regex = "(.+) County") %>%
  mutate(popratio = pop2010/median(pop2010)) %>%
  arrange(desc(popratio)) %>%
  mutate(index = 1:n(),
         label = ifelse(index <= 3 | index > n()-3 | runif(n()) < .04, county, ""),
         label_large = ifelse(index <= 6, county, "")) -> tx_counties

ggplot(tx_counties, aes(x = index, y = popratio)) +
  geom_hline(yintercept = 1, linetype = 2, color = "grey40") +
  geom_point(size = 0.5, color = "#0072B2") +
  geom_text_repel(aes(label = label), point.padding = .4, color = "black",
                  min.segment.length = 0, family = dviz_font_family) +
  scale_y_log10(breaks = c(.01, .1, 1, 10, 100),
                name = "population number / median",
                labels = label_log10) +
  scale_x_continuous(limits = c(.5, nrow(tx_counties) + .5), expand = c(0, 0),
                     breaks = NULL, #c(1, 50*(1:5)),
                     name = "Texas counties, from most to least populous") +
  theme_dviz_hgrid(font_family = "Roboto Light") +
  theme(axis.line = element_blank(),
        plot.margin = margin(3, 7, 3, 0))

## ----texas-counties-pop-ratio-lin, fig.width = 7.5, fig.asp = 0.6, fig.cap = '(ref:texas-counties-pop-ratio-lin)'----
counties_lin <- ggplot(tx_counties, aes(x = index, y = popratio)) +
  geom_point(size = 0.5, color = "#0072B2") +
  geom_text_repel(aes(label = label_large), point.padding = .4, color = "black",
                  min.segment.length = 0, family = dviz_font_family) +
  scale_y_continuous(name = "population number / median") +
  scale_x_continuous(limits = c(.5, nrow(tx_counties) + .5), expand = c(0, 0),
                     breaks = NULL, #c(1, 50*(1:5)),
                     name = "Texas counties, from most to least populous") +
  theme_dviz_hgrid(font_family = "Roboto Light") +
  theme(axis.line = element_blank(),
        plot.margin = margin(3, 7, 3, 0))

stamp_bad(counties_lin)

## ----sqrt-scales, fig.width = 6, fig.asp = 3*(3/4)/4, fig.cap = '(ref:sqrt-scales)'----
df <- data.frame(x = c(0, 1, 4, 9, 16, 25, 36, 49))

xaxis_lin <- ggplot(df, aes(x, y = 1)) + 
  geom_point(size = 3, color = "#0072B2") + 
  scale_y_continuous(limits = c(0.8, 1.2), expand = c(0, 0), breaks = 1) +
  theme_dviz_grid(14, rel_large = 1, font_family = "Roboto Light") +
  theme(axis.ticks.length = grid::unit(0, "pt"),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        plot.title = element_text(face = "plain"),
        plot.margin = margin(3, 14, 3, 0))

xaxis_sqrt <- ggplot(df, aes(sqrt(x), y = 1)) + 
  geom_point(size = 3, color = "#0072B2") + 
  scale_y_continuous(limits = c(0.8, 1.2), expand = c(0, 0), breaks = 1) +
  theme_dviz_grid(14, rel_large = 1, font_family = "Roboto Light") +
  theme(axis.ticks.length = grid::unit(0, "pt"),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        plot.title = element_text(face = "plain"),
        plot.margin = margin(3, 14, 3, 0))

plotlist <- 
  align_plots(xaxis_lin + scale_x_continuous(limits = c(0, 50)) + 
                ggtitle("original data, linear scale"),
              xaxis_sqrt + scale_x_continuous(limits = c(0, 7.07)) +
                xlab(expression(sqrt(x))) + 
                ggtitle("square-root-transformed data, linear scale"),
              xaxis_sqrt + scale_x_continuous(limits = c(0, 7.07), breaks = c(0, 1, sqrt(5), sqrt(10*(1:5))),
                                              labels = c(0, 1, 5, 10*(1:5)), name = "x") + 
                expand_limits(expand = c(0, 1)) +
                ggtitle("original data, square-root scale"),
              align = 'vh')

plot_grid(plotlist[[1]], plotlist[[2]], plotlist[[3]], ncol = 1)

## ----northeast-state-areas, fig.width = 8.5, fig.asp = 0.4, fig.cap = '(ref:northeast-state-areas)'----
# areas in square miles
# source: Google, 01/07/2018
northeast_areas <- read.csv(text = "state_abr,area
NY,54556
PA,46055
ME,35385
MA,10565
VT,9616
NH,9349
NJ,8723
CT,5543
RI,1212")

northeast_areas$state_abr <- factor(northeast_areas$state_abr, levels = northeast_areas$state_abr)

areas_base <- ggplot(northeast_areas, aes(x = state_abr, y = area)) +
  geom_col(fill = "#56B4E9") +
  ylab("area (square miles)") +
  xlab("state") +
  theme_dviz_hgrid(font_family = "Roboto Light") +
  theme(plot.margin = margin(3, 14, 3, 0))

p1 <- areas_base + scale_y_sqrt(limits = c(0, 55000), breaks = c(0, 1000, 5000, 10000*(1:5)), 
                                expand = c(0, 0))
  
p2 <- areas_base + scale_y_continuous(limits = c(0, 55000), breaks = 10000*(0:6), expand = c(0, 0))

plot_grid(p2, p1, labels = "auto")

## ----polar-coord, fig.width = 6, fig.asp = 0.5, fig.cap = '(ref:polar-coord)'----
df_points <- data.frame(x = c(1, 3.5, 0),
                        y = c(3, 4, 0),
                        label = c("(1, 3)", "(3.5, 4)", "(0, 0)"),
                        vjust_polar = c(1.6, 1, 1.6),
                        hjust_polar = c(.5, -.1, 0.5),
                        vjust_cart = c(1.6, 1.6, -.6),
                        hjust_cart = c(0.5, 1.1, -.1))

df_segments <- data.frame(x0 = c(0, 1, 2, 3, 0, 0, 0, 0),
                          x1 = c(0, 1, 2, 3, 4, 4, 4, 4),
                          y0 = c(0, 0, 0, 0, 1, 2, 3, 4),
                          y1 = c(4, 4, 4, 4, 1, 2, 3, 4))


p_cart <- ggplot(df_points, aes(x, y)) +
  geom_point(size = 2, color = "#0072B2") +
  geom_text(aes(label = label, vjust = vjust_cart, hjust = hjust_cart),
            size = 12/.pt, family = dviz_font_family) +
  scale_x_continuous(limits = c(-0.5, 4.5), expand = c(0, 0)) +
  scale_y_continuous(limits = c(-0.5, 4.5), expand = c(0, 0)) +
  coord_fixed() +
  xlab("x axis") +
  ylab("y axis") +
  theme_dviz_grid(12, font_family = "Roboto Light") +
  theme(axis.ticks = element_blank(),
        axis.ticks.length = grid::unit(0, "pt"),
        plot.margin = margin(3, 12, 3, 0))


p_polar <- ggplot(df_points, aes(x, y)) +
  geom_segment(
    data = df_segments,
    aes(x = x0, xend = x1, y = y0, yend = y1),
    size = theme_dviz_grid(font_family = "Roboto Light")$panel.grid$size,
    color = theme_dviz_grid(font_family = "Roboto Light")$panel.grid$colour,
    inherit.aes = FALSE
  ) +
  geom_point(size = 2, color = "#0072B2") +
  geom_text(
    aes(label = label, vjust = vjust_polar, hjust = hjust_polar),
    size = 12/.pt, family = dviz_font_family
  ) +
  scale_x_continuous(limits = c(0, 4)) +
  scale_y_continuous(limits = c(0, 4)) +
  coord_polar() +
  xlab("x values (circular axis)") +
  ylab("y values (radial axis)") +
  theme_dviz_grid(12, font_family = "Roboto Light") +
  background_grid(major = "none") +
  theme(axis.line.x = element_blank(),
        axis.ticks = element_line(color = "black"),
        plot.margin = margin(3, 12, 3, 0))

plot_grid(p_cart, p_polar, labels = "auto")

## ----temperature-normals-polar, fig.width = 6, fig.cap = '(ref:temperature-normals-polar)'----
temps_long <- gather(temps_wide, location, temperature, -month, -day, -date) %>%
  filter(location %in% c("Chicago",
                         "Death Valley",
                         "Houston",
                         "San Diego")) %>%
  mutate(location = factor(location, levels = c("Death Valley",
                                                "Houston",
                                                "San Diego",
                                                "Chicago")))

ggplot(temps_long, aes(x = date, y = temperature, color = location)) +
  geom_line(size = 1) +
  scale_x_date(name = "date", expand = c(0, 0)) + 
  scale_y_continuous(limits = c(0, 105), expand = c(0, 0),
                     breaks = seq(-30, 90, by = 30),
                     name = "temperature (°F)") +
  scale_color_OkabeIto(order = c(1:3, 7), name = NULL) +
  coord_polar(theta = "x", start = pi, direction = -1) +
  theme_dviz_grid(font_family = "Roboto Light")

## ----worldmap-four-projections, fig.width = 8.5, fig.cap = '(ref:worldmap-four-projections)'----
# library(sf)
# 
# world_sf <- sf::st_as_sf(rworldmap::getMap(resolution = "low"))
# 
# ## world in long-lat
# crs_longlat <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
# 
# p_longlat <- ggplot(world_sf) + 
#   geom_sf(fill = "#E69F00B0", color = "black", size = 0.5/.pt) + 
#   coord_sf(expand = FALSE, crs = crs_longlat) + 
#   scale_x_continuous(
#     name = "longitude",
#     breaks = seq(-160, 160, by = 20),
#     labels = parse(text = c("NA", "NA", "120*degree*W", "NA", "NA", "60*degree*W", "NA", "NA", "0*degree", "NA", "NA", "60*degree*E", "NA", "NA", "120*degree*E", "NA", "NA"))
#   ) +
#   scale_y_continuous(
#     name = "latitude",
#     breaks = seq(-80, 80, by = 20),
#     labels = parse(text = c("80*degree*S", "NA", "40*degree*S", "NA", "0*degree", "NA", "40*degree*N", "NA", "80*degree*N"))
#   ) +
#   theme_dviz_grid(12, font_family = "Roboto Light") +
#   theme(
#     panel.background = element_rect(fill = "#56B4E950", color = "grey30", size = 0.5),
#     panel.grid.major = element_line(color = "gray30", size = 0.25),
#     axis.ticks = element_line(color = "gray30", size = 0.5/.pt),
#     plot.margin = margin(5, 10, 0, 1)
#   )
# 
# 
# ## Interrupted Goode homolosine
# crs_goode <- "+proj=igh"
# 
# # projection outline in long-lat coordinates
# lats <- c(
#   90:-90, # right side down
#   -90:0, 0:-90, # third cut bottom
#   -90:0, 0:-90, # second cut bottom
#   -90:0, 0:-90, # first cut bottom
#   -90:90, # left side up
#   90:0, 0:90, # cut top
#   90 # close
# )
# longs <- c(
#   rep(180, 181), # right side down
#   rep(c(80.01, 79.99), each = 91), # third cut bottom
#   rep(c(-19.99, -20.01), each = 91), # second cut bottom
#   rep(c(-99.99, -100.01), each = 91), # first cut bottom
#   rep(-180, 181), # left side up
#   rep(c(-40.01, -39.99), each = 91), # cut top
#   180 # close
# )
# 
# goode_outline <- 
#   list(cbind(longs, lats)) %>%
#   st_polygon() %>%
#   st_sfc(
#     crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
#   ) %>% 
#   st_transform(crs = crs_goode)
# 
# # bounding box in transformed coordinates
# xlim_goode <- c(-21945470, 21963330)
# ylim_goode <- c(-9538022, 9266738)
# goode_bbox <- 
#   list(
#     cbind(
#       c(xlim_goode[1], xlim_goode[2], xlim_goode[2], xlim_goode[1], xlim_goode[1]), 
#       c(ylim_goode[1], ylim_goode[1], ylim_goode[2], ylim_goode[2], ylim_goode[1])
#     )
#   ) %>%
#   st_polygon() %>%
#   st_sfc(crs = crs_goode)
# 
# # area outside the earth outline
# goode_without <- st_difference(goode_bbox, goode_outline)
# 
# p_goode <- ggplot(world_sf) + 
#   geom_sf(fill = "#E69F00B0", color = "black", size = 0.5/.pt) +
#   geom_sf(data = goode_without, fill = "white", color = NA) +
#   geom_sf(data = goode_outline, fill = NA, color = "grey30", size = 0.5/.pt) +
#   scale_x_continuous(
#     name = NULL,
#     breaks = seq(-160, 160, by = 20)
#   ) +
#   scale_y_continuous(
#     name = NULL,
#     breaks = seq(-80, 80, by = 20)
#   ) + 
#   coord_sf(xlim = 0.95*xlim_goode, ylim = 0.95*ylim_goode, expand = FALSE, crs = crs_goode, ndiscr = 1000) + 
#   theme_dviz_grid(12, rel_small = 1, font_family = "Roboto Light") +
#   theme(
#     panel.background = element_rect(fill = "#56B4E950", color = "white", size = 1),
#     panel.grid.major = element_line(color = "gray30", size = 0.25),
#     plot.margin = margin(0, 0, 24, 0)
#   )
# 
# 
# ## Robinson projection
# crs_robin <- "+proj=robin +lat_0=0 +lon_0=0 +x0=0 +y0=0"
# 
# # projection outline in long-lat coordinates
# lats <- c(90:-90, -90:90, 90)
# longs <- c(rep(c(180, -180), each = 181), 180)
# 
# robin_outline <- 
#   list(cbind(longs, lats)) %>%
#   st_polygon() %>%
#   st_sfc(
#     crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
#   ) %>% 
#   st_transform(crs = crs_robin)
# 
# # bounding box in transformed coordinates
# xlim_robin <- c(-18494733, 18613795)
# ylim_robin <- c(-9473396, 9188587)
# robin_bbox <- 
#   list(
#     cbind(
#       c(xlim_robin[1], xlim_robin[2], xlim_robin[2], xlim_robin[1], xlim_robin[1]), 
#       c(ylim_robin[1], ylim_robin[1], ylim_robin[2], ylim_robin[2], ylim_robin[1])
#     )
#   ) %>%
#   st_polygon() %>%
#   st_sfc(crs = crs_robin)
# 
# # area outside the earth outline
# robin_without <- st_difference(robin_bbox, robin_outline)
# 
# p_robin <- ggplot(world_sf) + 
#   geom_sf(fill = "#E69F00B0", color = "black", size = 0.5/.pt) + 
#   geom_sf(data = robin_without, fill = "white", color = NA) +
#   geom_sf(data = robin_outline, fill = NA, color = "grey30", size = 0.5/.pt) +
#   scale_x_continuous(
#     name = NULL,
#     breaks = seq(-160, 160, by = 20)
#   ) +
#   scale_y_continuous(
#     name = NULL,
#     breaks = seq(-80, 80, by = 20)
#   ) +
#   coord_sf(xlim = 0.95*xlim_robin, ylim = 0.95*ylim_robin, expand = FALSE, crs = crs_robin, ndiscr = 1000) + 
#   theme_dviz_grid(12, rel_small = 1, font_family = "Roboto Light") +
#   theme(
#     panel.background = element_rect(fill = "#56B4E950", color = "white", size = 1),
#     panel.grid.major = element_line(color = "gray30", size = 0.25),
#     plot.margin = margin(6, 0, 0, 0)
#   )
# 
# 
# ## Winkel tripel
# # The Winkel tripel projection needs to be done manually, it is not supported by sf.
# crs_wintri <- "+proj=wintri +datum=WGS84 +no_defs +over"
# 
# # world
# world_wintri <- lwgeom::st_transform_proj(world_sf, crs = crs_wintri)
# 
# # graticule
# grat_wintri <- sf::st_graticule(lat = c(-89.9, seq(-80, 80, 20), 89.9))
# grat_wintri <- lwgeom::st_transform_proj(grat_wintri, crs = crs_wintri)
# 
# # earth outline
# lats <- c(90:-90, -90:90, 90)
# longs <- c(rep(c(180, -180), each = 181), 180)
# wintri_outline <- 
#   list(cbind(longs, lats)) %>%
#   st_polygon() %>%
#   st_sfc(
#     crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
#   ) %>% 
#   lwgeom::st_transform_proj(crs = crs_wintri)
# 
# p_wintri <- ggplot() + 
#   geom_sf(data = wintri_outline, fill = "#56B4E950", color = NA) +
#   geom_sf(data = grat_wintri, color = "gray30", size = 0.25/.pt) + 
#   geom_sf(data = world_wintri, fill = "#E69F00B0", color = "black", size = 0.5/.pt) + 
#   geom_sf(data = wintri_outline, fill = NA, color = "grey30", size = 0.5/.pt) +
#   coord_sf(datum = NA, expand = FALSE) +
#   theme_dviz_grid(12, rel_small = 1, font_family = "Roboto Light") +
#   theme(
#     plot.margin = margin(6, 0, 3, 0)
#   )
# 
# p <- plot_grid(
#   p_longlat, p_goode, p_robin, p_wintri,
#   labels = c(
#     "Cartesian longitude and latitude", "Interrupted Goode homolosine", 
#     "Robinson", "Winkel tripel"
#   )
# )
# 
# p

