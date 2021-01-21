## ----echo = FALSE, message = FALSE---------------------------------------
# run setup script
source(here::here("wilke-purl", "_common.R"))

library(tidyr)
library(forcats)
library(ggforce)
library(ggridges)

main_size = 14 / .pt
small_rel <- 12/14
small_size <- small_rel * main_size

## Remember: You always need to pick the visualization that best fits your specific dataset and that highlights the key data features you want to show.

## ---- bundestag-pie, fig.cap='(ref:bundestag-pie)'-----------------------
# calculate the start and end angles for each pie
bund_pie <- bundestag %>%
  arrange(seats) %>%
  mutate(
    seat_total = sum(seats),
    end_angle = 2*pi*cumsum(seats)/seat_total,   # ending angle for each pie slice
    start_angle = lag(end_angle, default = 0),   # starting angle for each pie slice
    mid_angle = 0.5*(start_angle + end_angle),   # middle of each pie slice, for the text label
    hjust = ifelse(mid_angle>pi, 1, 0),
    vjust = ifelse(mid_angle<pi/2 | mid_angle>3*pi/2, 0, 1)
  )

rpie = 1
rlabel = 1.05 * rpie

wilke_pie <- ggplot(bund_pie) + 
  geom_arc_bar(
    aes(
      x0 = 0, y0 = 0, r0 = 0, r = rpie,
      start = start_angle, end = end_angle, fill = party
    ),
    color = "white", size = 0.5
  ) +
  geom_text(
    aes(
      x = rlabel*sin(mid_angle),
      y = rlabel*cos(mid_angle),
      label = party,
      hjust = hjust, vjust = vjust
    ),
    family = dviz_font_family, size = 10
  ) +
  geom_text(
    aes(
      x = 0.6*sin(mid_angle),
      y = 0.6*cos(mid_angle),
      label = seats
    ),
    family = dviz_font_family, size = 10,
    color = c("black", "white", "white")
  ) +
  coord_fixed(clip = "off") +
  scale_x_continuous(
    limits = c(-1.5, 1.5),
    expand = c(0, 0),
    name = "",
    breaks = NULL,
    labels = NULL
  ) +
  scale_y_continuous(
    limits = c(-1.01, 1.15),
    expand = c(0, 0),
    name = "",
    breaks = NULL,
    labels = NULL
  ) +
  scale_fill_manual(
    values = bund_pie$colors[order(bund_pie$party)]
  ) +
  theme_dviz_map(25, font_family = "Roboto Light") +
  theme(
    legend.position = "none",
    plot.margin = margin(3.5, 0, 3.5, 0)
  )

## ---- bundestag-stacked-bars, fig.width = 8.5, fig.cap='(ref:bundestag-stacked-bars)'----
bundestag <- mutate(bundestag,
                    label_y = cumsum(seats) - seats/2)

bt_bars_stacked_base <- ggplot(bundestag, 
                               aes(x = 1, y = seats, fill = factor(party, levels = rev(party)))) + 
  geom_col(position = "stack", color = "white") + 
  geom_text(aes(x = 1., y = label_y, label = seats), 
            size = 10, family = dviz_font_family,
            color = c("white", "white", "black")) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_discrete(expand = c(0, 0), breaks = NULL, name = NULL) +
  scale_fill_manual(values = rev(bundestag$colors), guide = "none")

bt_bars_yax <- axis_canvas(bt_bars_stacked_base, axis = "y") +
  geom_text(data = bundestag,
            aes(x = 0.06, y = label_y, label = party),
            hjust = 0, vjust = 0.5, size = 10,
            family = dviz_font_family) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1))

bt_bars_stacked <- insert_yaxis_grob(
  bt_bars_stacked_base + 
    theme_dviz_hgrid(25, font_family = "Roboto Light") +
    theme(plot.margin = margin(7, 0, 7, 0)),
  bt_bars_yax, grid::unit(.5, "null"))

bt_bars_xax <- axis_canvas(bt_bars_stacked_base, axis = "y") +
  geom_text(data = bundestag,
            aes(x = 0., y = label_y, label = party, hjust = 0.5, vjust = 0),
            size = 10,
            family = dviz_font_family) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1)) +
  coord_flip()

bt_bars_hstacked <- insert_xaxis_grob(
  bt_bars_stacked_base + coord_flip() +
    scale_y_continuous(expand = c(0, 0), position = "right") +
    theme_dviz_vgrid(25, font_family = "Roboto Light") +
    theme(plot.margin = margin(3, 0, 3, 7)),
  bt_bars_xax, grid::unit(40, "pt"), position = "bottom")
ggdraw(bt_bars_hstacked)
plot_grid(bt_bars_stacked, plot_grid(NULL, bt_bars_hstacked, NULL,
                                     ncol = 1, rel_heights = c(1, 6, 7.5)),
          rel_widths = c(4, 7), labels = "auto")

## ----bundestag-bars-side-by-side, fig.width = 5, fig.asp = 3/4, fig.cap='(ref:bundestag-bars-side-by-side)'----
bt_bars <- ggplot(bundestag, aes(x = factor(party, levels = bundestag$party), y = seats, fill = party)) + 
  geom_col() + 
  geom_text(aes(label = seats), size = 10, vjust = 1.5, color = c("white", "white", "black")) +
  scale_x_discrete(name = NULL) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_fill_manual(values = bundestag$colors[order(bundestag$party)], guide = "none") + 
  #geom_hline(yintercept = c(50, 100, 150, 200), color = "#ffffff70", size = .5) +
  theme_dviz_hgrid(25, font_family = "Roboto Light") +
  theme(axis.ticks.x = element_blank())

bt_bars

## ----marketshare-pies, fig.width = 8.5, fig.asp = .35, fig.cap='(ref:marketshare-pies)'----
# calculate the start and end angles for each pie
market_pies_df <- marketshare %>%
  group_by(year) %>%
  mutate(total = sum(percent),
         end_angle = 2*pi*cumsum(percent)/total,      # ending angle for each pie slice
         start_angle = lag(end_angle, default = 0),   # starting angle for each pie slice
         mid_angle = 0.5*(start_angle + end_angle),   # middle of each pie slice, for the text label
         hjust = ifelse(mid_angle>pi, 1, 0),
         vjust = ifelse(mid_angle<pi/2 | mid_angle>3*pi/2, 0, 1))

rpie = 1
rlabel = 1.05 * rpie

market_pies <- ggplot(market_pies_df) + 
  geom_arc_bar(aes(x0 = 0, y0 = 0, r0 = 0, r = rpie,
                   start = start_angle, end = end_angle, fill = company), color = NA) +
  geom_text(aes(x = rlabel*sin(mid_angle), y = rlabel*cos(mid_angle), label = company,
                family = dviz_font_family,
                hjust = hjust, vjust = vjust)) +
  coord_fixed() +
  facet_wrap(~year) +
  scale_x_continuous(limits = c(-1.2, 1.2), expand = c(0, 0), name = "", breaks = NULL, labels = NULL) +
  scale_y_continuous(limits = c(-1.2, 1.2), expand = c(0, 0),name = "", breaks = NULL, labels = NULL) +
  scale_fill_OkabeIto(order = c(1:3, 5, 4)) + 
  guides(fill = "none") +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(axis.line.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.y = element_blank(),
        plot.margin = margin(7, 7, 0, 7),
        legend.position = "none",
        strip.background = element_blank(),
        strip.text.x = element_text(margin = margin(0, 0, 0.1, 0)))

stamp_bad(market_pies)

## ----marketshare-stacked, fig.cap='(ref:marketshare-stacked)'------------
stacked_bars <- ggplot(marketshare, aes(x = year, y = percent, fill = company)) + 
  geom_col(position = "stack") + 
  scale_y_continuous(expand = c(0, 0)) +
  scale_fill_OkabeIto(order = c(1:3, 5, 4)) + 
  theme_dviz_open(font_family = "Roboto Light") +
  theme(plot.margin = margin(14, 7, 3, 0))

stamp_bad(stacked_bars)

## ----marketshare-side-by-side, fig.cap='(ref:marketshare-side-by-side)'----
ggplot(marketshare, aes(x = company, y = percent, fill = company)) + 
  geom_col() + 
  facet_wrap(~year) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_fill_OkabeIto(order = c(1:3, 5, 4), guide = "none") + 
  theme_dviz_open(font_family = "Roboto Light") +
  theme(strip.background = element_blank())

## ----women-parliament, fig.width = 6, fig.asp = .55, fig.cap = '(ref:women-parliament)'----
ccode = "RWA" # Rwanda
#ccode = "BEL" # Belgium
#ccode = "ARB" # Arab world
#ccode = "BOL" # Bolivia
#ccode = "EUU" # European Union

women_parliaments %>% filter(country_code == ccode & year > 1990) %>%
  mutate(women = perc_women, men = 100 - perc_women) %>%
  select(-perc_women) %>%
  gather(gender, percent, women, men) %>%
  mutate(gender = factor(gender, levels = c("women", "men"))) -> women_rwanda

plot_base <- ggplot(women_rwanda, aes(x = year, y = percent, fill = gender)) +
    #geom_col(position = "stack", width = .9, color = "white") +
    geom_col(position = "stack", width = 1, color = "white", size = .75) +
    geom_hline(yintercept = c(50), color = "#FFFFFFA0") +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_fill_manual(values = c("#D55E00E0", "#0072B2E0"), guide = "none") +
    theme_dviz_open(font_family = "Roboto Light") + 
    theme(#axis.ticks.y = element_blank(),
          #axis.ticks.x = element_blank(),
          #axis.line.x = element_blank(),
          axis.line.y = element_blank(),
          plot.margin = margin(14, 0, 3, 0))

# calculate label position
labels <- filter(women_rwanda, year == max(year)) %>%
  mutate(pos = 100 - cumsum(percent) + 0.5*percent)

yax <- axis_canvas(plot_base, axis = "y") +
  geom_text(data = labels, aes(y = pos, label = paste0(" ", gender)),
            family = dviz_font_family,
            x = 0, hjust = 0, size = 14/.pt)

ggdraw(insert_yaxis_grob(plot_base, yax, grid::unit(.15, "null")))


## ----health-vs-age, fig.asp = .5, fig.cap='(ref:health-vs-age)'----------
df_health <- select(happy, age, health) %>%
  na.omit()

# color brewer 5-class PuBu
colors = c('#f1eef6', '#bdc9e1', '#74a9cf', '#2b8cbe', '#045a8d')[5:1]

p_health <- ggplot(df_health, aes(x = age, y = ..count.., fill = health, color = health)) + 
  geom_density(position = "fill") +
  #geom_hline(yintercept = c(.25, .50, .75), color = "#FFFFFF60") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0), name = "percent",
                     labels = c(0, 25, 50, 75, 100)) + 
  scale_color_manual(values = colors) + 
  scale_fill_manual(values = colors) +
  theme_dviz_open(font_family = "Roboto Light") + 
  theme(#axis.ticks.y = element_blank(),
        #axis.ticks.x = element_blank(),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        plot.margin = margin(7, 7, 3, 0))

df_marital <- select(happy, age, marital) %>%
  na.omit() %>%
  filter(marital != "separated") %>% # remove separated to make plot simpler
  mutate(marital = factor(marital, levels = c("widowed", "divorced", "married", "never married")))

p_marital <- ggplot(df_marital, aes(x = age, y = ..count.., fill = marital, color = marital)) + 
  geom_density(position = "fill") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0), name = "percent",
                     labels = c(0, 25, 50, 75, 100)) + 
  scale_color_manual(values = colors, name = "marital status") + 
  scale_fill_manual(values = colors, name = "marital status") +
  theme_dviz_open(font_family = "Roboto Light") + 
  theme(#axis.ticks.y = element_blank(),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        plot.margin = margin(7, 7, 3, 0))

p_aligned <- align_patches(p_health, p_marital)
ggdraw(p_aligned[[1]])

## ----health-vs-age-facets, fig.width = 8.5, fig.asp = 0.35, fig.cap='(ref:health-vs-age-facets)'----
ggplot(mutate(df_health, health = fct_rev(health)), aes(x = age, y = ..count..)) +
  geom_density_line(data = select(df_health, -health), aes(fill = "all people surveyed   "), color = "transparent") +
  geom_density_line(aes(fill = "highlighted group"), color = "transparent") +
  facet_wrap(~health, nrow = 1) +
  scale_x_continuous(limits = c(15, 98), expand = c(0, 0)) +
  scale_y_continuous(name = "count", expand = c(0, 0)) +
  scale_fill_manual(values = c("#b3b3b3a0", "#2b8cbed0"), name = "") +
  theme_dviz_hgrid(font_family = "Roboto Light") +
  theme(strip.text = element_text(margin = margin(0, 0, 0.2, 0, "cm")),
        legend.position = "bottom",
        legend.justification = "right",
        legend.margin = margin(0, 0, 0.2, 0, "cm"),
        legend.spacing.x = grid::unit(0.2, "cm"))

## ----marital-vs-age, fig.asp = 0.5, fig.cap='(ref:marital-vs-age)'-------
stamp_bad(p_aligned[[2]])

## ----marital-vs-age-facets, fig.width = 8.5, fig.asp = 0.35, fig.cap='(ref:marital-vs-age-facets)'----
ggplot(mutate(df_marital, marital = fct_rev(marital)), aes(x = age, y = ..count..)) +
  geom_density_line(data = select(df_marital, -marital), aes(fill = "all people surveyed  "), color = "transparent") +
  geom_density_line(aes(fill = "highlighted group"), color = "transparent") +
  facet_wrap(~marital, nrow = 1) +
  scale_x_continuous(limits = c(15, 98), expand = c(0, 0)) +
  scale_y_continuous(name = "count", expand = c(0, 0)) +
  scale_fill_manual(values = c("#b3b3b3a0", "#2b8cbed0"), name = "") +
  theme_dviz_hgrid(font_family = "Roboto Light") +
  theme(strip.text = element_text(margin = margin(0, 0, 0.2, 0, "cm")),
        legend.position = "bottom",
        legend.justification = "right",
        legend.margin = margin(0, 0, 0.2, 0, "cm"),
        legend.spacing.x = grid::unit(0.2, "cm"))

## ------------------------------------------------------------------------

# **Additional ideas, for a separate chapter on nested proportions: treemaps and Sankey diagrams.**

#Notes:
#  https://github.com/wilkox/treemapify
#  Also possibly use survival on Titanic, as.data.frame(Titanic)

