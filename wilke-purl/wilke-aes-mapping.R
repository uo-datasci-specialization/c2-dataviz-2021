## ----echo = FALSE, message = FALSE---------------------------------------
# run setup script
source(here::here("wilke-purl", "_common.R"))

library(forcats)
library(patchwork)
library(lubridate)

## ----common-aesthetics, fig.width = 6, fig.asp = 0.45, fig.cap = '(ref:common-aesthetics)'----
aes_pos <- ggdraw() + 
  geom_segment(data = data.frame(x = c(0, 0.5),
                                 xend = c(1, 0.5),
                                 y = c(0.5, 0),
                                 yend = c(0.5, 1)),
                aes(x = x, y = y, xend = xend, yend = yend),
                arrow = arrow(length = grid::unit(12, "pt")), size = .75) +
  draw_text("y", .5, 1, size = 22, vjust = 1, hjust = 2.5, family = dviz_font_family) +
  draw_text("x", 1, .5, size = 22, vjust = 2, hjust = 1, family = dviz_font_family) + 
  coord_cartesian(xlim = c(-.2, 1.2), ylim = c(-.2, 1.2))

aes_color <- ggdraw() +
  geom_tile(data = data.frame(x = 0.15 + .2333*(0:3)),
            aes(x, y = .5, fill = factor(x)), width = .2, height = .6) +
  scale_fill_OkabeIto(guide = "none")

aes_shape <- ggdraw() +
  geom_point(data = data.frame(x = (.5 + 0:3)/4),
             aes(x, y = .5, shape = factor(x)), size = 16, fill = "grey80") +
  scale_shape_manual(values = 21:24)

aes_size <- ggdraw() +
  geom_point(data = data.frame(x = (.5 + 0:3)/4),
             aes(x, y = .5, size = factor(x)), shape = 21, fill = "grey80") +
  scale_size_manual(values = c(2, 5, 8, 11)*3)

aes_lwd <- ggdraw() +
  geom_segment(data = data.frame(x = rep(0.05, 4),
                                 xend = rep(0.95, 4),
                                 y = (1.5 + 0:3)/6,
                                 yend = (1.5 + 0:3)/6,
                                 size = 4:1),
               aes(x = x, y = y, xend = xend, yend = yend, size = size)) +
  scale_size_identity()

aes_ltp <- ggdraw() +
  geom_segment(data = data.frame(x = rep(0.05, 4),
                                 xend = rep(0.95, 4),
                                 y = (1.5 + 0:3)/6,
                                 yend = (1.5 + 0:3)/6,
                                 linetype = 4:1),
               aes(x = x, y = y, xend = xend, yend = yend, linetype = linetype), size = 1) +
  scale_linetype_identity()




## ----basic-scales-example, fig.width = 5.5, fig.asp = 0.3, fig.cap = '(ref:basic-scales-example)'----
df <- data.frame(x = c(1:4))

scale_num <- ggplot(df, aes(x)) + 
  geom_point(size = 20, color = "#0072B2", y = 1) + 
  scale_y_continuous(limits = c(0.8, 1.2), expand = c(0, 0), breaks = 1, label = "position  ") +
  scale_x_continuous(limits = c(.7, 4.4), breaks = 1:5, labels = c("1", "2", "3", "4", "5"), name = NULL, position = "top") +
  theme_dviz_grid(font_family = "Roboto Light") +
  theme(axis.ticks.length = grid::unit(0, "pt"),
        axis.text = element_text(size = 30),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank())

scale_color <- ggplot(df, aes(x, color = factor(x), fill = factor(x))) + 
  geom_point(size = 20, shape = 22, y = 1) + 
  scale_y_continuous(limits = c(0.8, 1.2), expand = c(0, 0), breaks = 1, label = "color  ") +
  scale_x_continuous(limits = c(.7, 4.4), breaks = NULL) +
  scale_color_manual(values = darken(c("#0082A6", "#4EBBB9", "#9CDFC2", "#D8F0CD"), .1), guide = "none") +
  scale_fill_manual(values = c("#0082A6", "#4EBBB9", "#9CDFC2", "#D8F0CD"), guide = "none") +
  theme_dviz_grid(font_family = "Roboto Light") +
  theme(axis.ticks.length = grid::unit(0, "pt"),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 30),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.grid.major = element_blank()) 

scale_shape <- ggplot(df, aes(x, shape = factor(x))) + 
  geom_point(size = 20, color = "grey30", y = 1, fill = "grey80") + 
  scale_y_continuous(limits = c(0.8, 1.2), expand = c(0, 0), breaks = 1, label = "shape  ") +
  scale_x_continuous(limits = c(.7, 4.4), breaks = NULL) +
  scale_shape_manual(values = 21:24, guide = "none") +
  theme_dviz_grid(font_family = "Roboto Light") +
  theme(axis.ticks.length = grid::unit(0, "pt"),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 30),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.grid.major = element_blank()) 

## ----temp-normals-vs-time, fig.cap = '(ref:temp-normals-vs-time)'--------
temps_long <- filter(ncdc_normals,
                station_id %in% c(
                  "USW00014819", # Chicago, IL 60638
                  #"USC00516128", # Honolulu, HI 96813
                  #"USW00027502", # Barrow, AK 99723, coldest point in the US
                  "USC00042319", # Death Valley, CA 92328 hottest point in the US
                  "USW00093107", # San Diego, CA 92145
                  #"USC00427606"  # Salt Lake City, UT 84103
                  "USW00012918" # Houston, TX 77061
                )) %>%
  mutate(location = fct_recode(factor(station_id),
                               "Chicago" = "USW00014819",
                               #"Honolulu, HI" = "USC00516128",
                               #"Barrow, AK" = "USW00027502",
                               "Death Valley" = "USC00042319",
                               "San Diego" = "USW00093107",
                               #"Salt Lake City, UT" = "USC00427606",
                               "Houston" = "USW00012918")) %>%
  mutate(location = factor(location, levels = c("Death Valley", "Houston", "San Diego", "Chicago")))

ggplot(temps_long, aes(x = date, y = temperature, color = location)) +
  geom_line(size = 1) +
  scale_x_date(name = "month", limits = c(ymd("0000-01-01"), ymd("0001-01-04")),
               breaks = c(ymd("0000-01-01"), ymd("0000-04-01"), ymd("0000-07-01"),
                          ymd("0000-10-01"), ymd("0001-01-01")),
               labels = c("Jan", "Apr", "Jul", "Oct", "Jan"), expand = c(1/366, 0)) + 
  scale_y_continuous(limits = c(15, 110),
                     breaks = seq(20, 100, by = 20),
                     name = "temperature (°F)") +
  scale_color_OkabeIto(order = c(1:3, 7), name = NULL) +
  theme_dviz_grid(font_family = "Roboto Light") +
  theme(legend.title.align = 0.5)

## ----four-locations-temps-by-month, fig.width = 8.5, fig.asp = .3, fig.cap = '(ref:four-locations-temps-by-month)'----
month_names <- c("01" = "Jan", "02" = "Feb", "03" = "Mar", "04" = "Apr", "05" = "May", "06" = "Jun",
                   "07" = "Jul", "08" = "Aug", "09" = "Sep", "10" = "Oct", "11" = "Nov", "12" = "Dec")


mean_temps <- temps_long %>%
  group_by(location, month) %>%
  summarize(mean = mean(temperature)) %>%
  ungroup() %>%
  mutate(month = month_names[month]) %>%
  mutate(month = factor(month, levels = unname(month_names)))

p <- ggplot(mean_temps, aes(x = month, y = location, fill = mean)) + 
  geom_tile(width = .95, height = 0.95) + 
  scale_fill_viridis_c(option = "B", begin = 0.15, end = 0.98,
                       name = "Temperature (°F)") + 
  scale_y_discrete(name = NULL) +
  coord_fixed(expand = FALSE) +
  theme_dviz_open(font_family = "Roboto Light", font_size = 25) +
  theme(axis.line = element_blank(),
        axis.ticks = element_blank(),
        #axis.text.y = element_text(size = 14),
        legend.title = element_text(size = 18)
        )
# fix legend (make it centered)
ggdraw(align_legend(p))

## ----mtcars-five-scale, fig.width = 6, fig.asp = .8, fig.cap = '(ref:mtcars-five-scale)'----
p_mtcars <- ggplot(mtcars, aes(disp, mpg, fill = hp, shape = factor(cyl), size = wt)) + 
  geom_point(color = "white") +
  scale_shape_manual(values = c(23, 24, 21), name = "cylinders") +
  scale_fill_continuous_sequential(palette = "Emrld", name = "power (hp)", breaks = c(100, 200, 300)) +
  xlab("displacement (cu. in.)") +
  ylab("fuel efficiency (mpg)") +
  guides(shape = guide_legend(override.aes = list(size = 4, fill = "#329D84")),
         size = guide_legend(override.aes = list(shape = 21, fill = "#329D84"),
                             title = "weight (1000 lbs)")) +
  theme_dviz_open(font_family = "Roboto Light", font_size = 20) + background_grid() +
  theme(#legend.title = element_text(size = 12),
        legend.box.background = element_rect(fill = "white", color = "white"),
        legend.position = "top",
        legend.direction = "vertical",
        legend.justification = "center",
        legend.box.margin = margin(7, 7, 7, 7))

legend <- get_legend(align_legend(p_mtcars))

ggdraw() + 
  draw_plot(p_mtcars + theme(legend.position = "none")) + 
  draw_grob(legend, x = .36, y = .7, width = .7, height = .3)

