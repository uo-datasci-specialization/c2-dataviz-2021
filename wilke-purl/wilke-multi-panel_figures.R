## ----echo = FALSE, message = FALSE, warning = FALSE----------------------
# run setup script
source(here::here("wilke-purl", "_common.R"))

library(forcats)
library(stringr)
library(ggridges)

## ----titanic-passenger-breakdown, fig.width = 5, fig.asp = 3/4, fig.cap = '(ref:titanic-passenger-breakdown)'----
titanic %>% mutate(surv = ifelse(survived == 0, "died", "survived")) %>%
  ggplot(aes(sex, fill = sex)) + geom_bar() +
    facet_grid(class ~ surv, scales = "free_x") +
    scale_x_discrete(name = NULL) + 
    scale_y_continuous(limits = c(0, 195), expand = c(0, 0)) +
    scale_fill_manual(values = c("#D55E00D0", "#0072B2D0"), guide = "none") +
    theme_dviz_hgrid(rel_small = 1, font_family = "Roboto Light") +
    theme(axis.line = element_blank(),
          axis.ticks.length = grid::unit(0, "pt"),
          axis.ticks = element_blank(),
          axis.text.x = element_text(margin = margin(7, 0, 0, 0)),
          strip.text = element_text(margin = margin(3.5, 3.5, 3.5, 3.5)),
          strip.background  = element_rect(fill = "grey80", colour = "grey80",
                                            linetype = 1, size = 0.25),
          panel.border = element_rect(colour = "grey80", fill = NA, linetype = 1,
                                      size = 1.))

## ----movie-rankings, fig.width = 8.5, fig.asp = 1, fig.cap = '(ref:movie-rankings)'----
library(ggplot2movies)

ggplot(filter(movies, year > 1905), aes(y = rating, x = votes)) + 
  geom_point(color = "#0072B250", size = 0.1) + 
  geom_smooth(method = 'lm', se = FALSE, size = 1.25, color = '#D55E00',
              fullrange = TRUE) + 
  scale_x_log10(labels = label_log10, name = "number of votes") + 
  scale_y_continuous(limits = c(0, 10), expand = c(0, 0),
                     breaks = c(0, 5, 10), name = "average rating") + 
  facet_wrap(~year, ncol = 10) +
  theme_dviz_grid(10, rel_small = 1, line_size = 0.25, font_family = "Roboto Light") +
  theme(strip.text = element_text(margin = margin(3.5, 3.5, 3.5, 3.5)),
        panel.border = element_rect(colour = "grey80", fill = NA, linetype = 1,
                                    size = 1.))

## ----BA-degrees-variable-y-lims, fig.width = 8.5, fig.asp = 0.8, fig.cap = '(ref:BA-degrees-variable-y-lims)'----
BA_degrees %>% 
  mutate(field = ifelse(field == "Communication, journalism, and related programs",
                        "Communication, journalism, and related", field)) -> BA_df

BA_df %>% group_by(field) %>%
  summarize(mean_perc = mean(perc)) %>%
  arrange(desc(mean_perc)) -> BA_top

top_fields <- filter(BA_top, mean_perc>0.04)$field

BA_top_degrees <- filter(BA_df, field %in% top_fields) %>%
  mutate(field = factor(field, levels = top_fields)) %>%
  arrange(field)

p <- ggplot(BA_top_degrees, aes(year, perc)) + 
  geom_line(color = "#0072B2") + 
  facet_wrap(~field, labeller = label_wrap_gen(width = 25), ncol = 3,
             scales = "free") +
  ylab("percent") +
  theme_dviz_hgrid(font_family = "Roboto Light") +
  theme(strip.text = element_text(margin = margin(7, 7, 3, 7)),
        panel.spacing.x = grid::unit(14, "pt"),
        plot.margin = margin(3.5, 14, 3.5, 0)) 

stamp_bad(p)

## ----BA-degrees-fixed-y-lims, fig.width = 8.5, fig.asp = 0.8, fig.cap = '(ref:BA-degrees-fixed-y-lims)'----
ggplot(BA_top_degrees, aes(year, perc)) + 
  geom_line(color = "#0072B2") + 
  facet_wrap(~field, labeller = label_wrap_gen(width = 25), ncol = 3,
             scales = "free") +
  scale_y_continuous(limits = c(0, 0.241), expand = c(0, 0),
                     name = "percent") +
  theme_dviz_hgrid(font_family = "Roboto Light") +
  theme(strip.text = element_text(margin = margin(7, 7, 3, 7)),
        panel.spacing.x = grid::unit(14, "pt"),
        plot.margin = margin(3.5, 14, 3.5, 0)) 


## Always arrange the panels in a small multiples plot in a meaningful and logical order.

## ----BA-degrees-compound, fig.asp = 0.4, fig.width = 8.5, fig.cap = '(ref:BA-degrees-compound)'----
BA_degrees %>% 
  mutate(field = ifelse(field == "Communication, journalism, and related programs",
                        "Communication, journalism, and related", field)) -> BA_df

BA_df %>% group_by(year) %>%
  summarize(total = sum(count)) -> BA_totals

textcol <- "gray30"

p1 <- ggplot(BA_totals, aes(year, total/1e6)) + 
  geom_density_line(stat = "identity", color = "#0072B2",
                    fill = desaturate(lighten("#0072B280", .3), .4)) + 
  scale_y_continuous(limits = c(0, 2.05), expand = c(0, 0),
                     name = "degrees awarded (millions)") +
  scale_x_continuous(limits = c(1970, 2016), expand = c(0, 0), name = NULL) +
  theme_dviz_hgrid(font_family = "Roboto Light") +
  theme(axis.title = element_text(color = textcol),
        axis.text = element_text(color = textcol),
        plot.margin = margin(3, 7, 3, 0))

BA_df %>% group_by(field) %>%
  summarize(mean_perc = mean(perc)) %>%
  arrange(desc(mean_perc)) -> BA_top

top_fields <- filter(BA_top, mean_perc>0.055)$field

BA_top_pairs <- filter(BA_df, field %in% top_fields,
                       year %in% c(1971, 2015)) %>%
  mutate(field_wrapped = str_wrap(field, 25))

p2 <- ggplot(BA_top_pairs, aes(x = year, y = perc)) +
  geom_line(aes(group = field), color = "gray60") +
  geom_point(fill = "#0072B2", color = "white", shape = 21, size = 3, stroke = 1.5) +
  scale_x_continuous(limits = c(1971, 2015), breaks = c(1971, 2015),
                     labels = c("1970-71", "2014-15"),
                     expand = expand_scale(mult = c(0.1, 0.04)),
                     name = NULL,
                     position = "top") +
  scale_y_continuous(limits = c(0.02, 0.22), expand = c(0, 0), name = "percent of degrees",
                     sec.axis = dup_axis(breaks = filter(BA_top_pairs, year == 2015)$perc + 0.0001,
                                         labels = filter(BA_top_pairs, year == 2015)$field_wrapped,
                                         name = NULL)) +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.y = element_text(color = textcol),
        axis.text.y = element_text(color = textcol),
        axis.line.y.left = element_line(color = textcol),
        axis.text.y.right = element_text(hjust = 0, vjust = .5,
                                         margin = margin(0, 0, 0, 0),
                                         color = "black",
                                         lineheight = 0.8
                                         ),
        axis.line.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        plot.margin = margin(3, 7, 3, 0))

plot_grid(p1, p2, labels = "auto", rel_widths = c(1.2, 1), align = 'h')

## ----BA-degrees-compound-bad, fig.asp = 0.4, fig.width = 8.5, fig.cap = '(ref:BA-degrees-compound-bad)'----
stamp_ugly(plot_grid(p1, p2, labels = "AUTO", rel_widths = c(1.2, 1), align = 'h',
                     label_fontfamily = "Palatino", label_fontface = "bold",
                     label_x = 0.8,
                     label_y = 0.2,
                     label_size = 23))

## ----athletes-composite-inconsistent, fig.asp = 0.75, fig.cap = '(ref:athletes-composite-inconsistent)'----
male_sport <- unique(filter(Aus_athletes, sex=="m")$sport)
female_sport <- unique(filter(Aus_athletes, sex=="f")$sport)
both_sport <- male_sport[male_sport %in% female_sport]
athletes_df <- filter(Aus_athletes, sport %in% both_sport) %>%
  mutate(sport = case_when(sport == "track (400m)" ~ "track",
                           sport == "track (sprint)" ~ "track",
                           TRUE ~ sport),
         sex = factor(sex, levels = c("f", "m")))

p1 <- ggplot(athletes_df, aes(x = sex)) + 
  geom_bar(fill = "#56B4E9E0") +
  scale_y_continuous(limits = c(0, 95), expand = c(0, 0), name = "number") +
  scale_x_discrete(name = NULL, labels = c("female", "male")) +
  theme_dviz_hgrid(12, rel_small = 1, font_family = "Roboto Light") + 
  theme(axis.ticks.x = element_blank(),
        #axis.ticks.length = grid::unit(0, "pt"),
        plot.margin = margin(3, 6, 0, 0))

p2 <- ggplot(athletes_df, aes(x = rcc, y = wcc, shape = sex, color = sex, fill = sex)) + 
  geom_point(size = 2.5) +
  scale_x_continuous(limits = c(3.8, 6.75), name = NULL) +
  scale_y_continuous(limits = c(2.2, 11.), expand = c(0, 0), name = "WBC count") +
  scale_shape_manual(values = c(21, 22),
                     labels = c("female   ", "male"), name = NULL,
                     guide = guide_legend(direction = "horizontal")) +
  scale_color_manual(values = c("#CC79A7", "#56B4E9"), name = NULL,
                     labels = c("female   ", "male"),
                     guide = guide_legend(direction = "horizontal")) +
  scale_fill_manual(values = c("#CC79A780", "#56B4E980"), name = NULL,
                     labels = c("female   ", "male"),
                     guide = guide_legend(direction = "horizontal")) +
  theme_dviz_hgrid(12, rel_small = 1, font_family = "Roboto Light") +
  theme(legend.position = c(1, .1),
        legend.justification = "right",
        legend.box.background = element_rect(fill = "white", color = "white"),
        plot.margin = margin(3, 0, 0, 0))

p_row <- plot_grid(p1, p2, labels = "auto", align = 'h', rel_widths = c(0.7, 1)) +
  draw_text("RBC count", x = 1, y = 0, size = 12, hjust = 1, vjust = -0.02,
            family = dviz_font_family) + 
  theme(plot.margin = margin(0, 0, 6, 0))

p3 <- ggplot(athletes_df, aes(x = sport, y = pcBfat, color = fct_relevel(sex, "m"),
                              fill = fct_relevel(sex, "m"))) + 
  geom_boxplot(width = 0.5) +
  scale_color_manual(values = c("#009E73", "#56B4E9"), name = NULL,
                     labels = c("male", "female")) +
  scale_fill_manual(values = c("#009E7340", "#56B4E940"), name = NULL,
                     labels = c("male", "female")) +
  scale_x_discrete(name = NULL) +
  scale_y_continuous(name = "% body fat") +
  theme_dviz_hgrid(12, rel_small = 1, font_family = "Roboto Light") +
  theme(axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),
        #axis.ticks.length = grid::unit(0, "pt")
        )

stamp_bad(plot_grid(p_row, p3, ncol = 1, labels = c("", "c")) +
            theme(plot.margin = margin(6, 12, 0, 0)))

## ----athletes-composite-good, fig.asp = 0.75, fig.cap = '(ref:athletes-composite-good)'----
p1 <- ggplot(athletes_df, aes(x = sex, fill = sex)) + 
  geom_bar() +
  scale_y_continuous(limits = c(0, 95), expand = c(0, 0), name = "number") +
  scale_x_discrete(name = NULL, labels = c("female", "male")) +
  scale_fill_manual(values = c("#D55E00D0", "#0072B2D0"), guide = "none") +
  theme_dviz_hgrid(12, rel_small = 1, font_family = "Roboto Light") + 
  theme(#axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),
        #axis.ticks.length = grid::unit(0, "pt"),
        plot.margin = margin(3, 6, 0, 0))

p2 <- ggplot(athletes_df, aes(x = rcc, y = wcc, fill = sex)) + 
  geom_point(pch = 21, color = "white", size = 2.5) +
  scale_x_continuous(limits = c(3.8, 6.75), name = NULL) +
  scale_y_continuous(limits = c(2.2, 11.), expand = c(0, 0), name = "WBC count") +
  scale_fill_manual(values = c("#D55E00D0", "#0072B2D0"), guide = "none") +
  theme_dviz_hgrid(12, rel_small = 1, font_family = "Roboto Light") +
  theme(plot.margin = margin(3, 0, 0, 0))

p_row <- plot_grid(p1, p2, labels = "auto", align = 'h', rel_widths = c(0.7, 1)) +
  draw_text("RBC count", x = 1, y = 0, size = 12, hjust = 1, vjust = -0.02,
            family = dviz_font_family) + 
  theme(plot.margin = margin(0, 0, 6, 0))

GeomBP <- GeomBoxplot
GeomBP$draw_key <- draw_key_polygon

p3 <- ggplot(athletes_df, aes(x = sport, y = pcBfat, color = sex, fill = sex)) + 
  stat_boxplot(width = 0.5, geom = GeomBP) +
  scale_color_manual(values = c("#D55E00", "#0072B2"), name = NULL,
                     labels = c("female   ", "male")) +
  scale_fill_manual(values = c("#D55E0040", "#0072B240"), guide = "none") +
  scale_x_discrete(name = NULL) +
  scale_y_continuous(name = "% body fat") +
  guides(color = guide_legend(override.aes = list(fill = c("#D55E00D0", "#0072B2D0"),
                                                  color = "white", size = 2),
                              direction = "horizontal")) +
  theme_dviz_hgrid(12, rel_small = 1, font_family = "Roboto Light") +
  theme(axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),
        #axis.ticks.length = grid::unit(0, "pt"),
        legend.position = c(1., 0.9),
        legend.justification = "right")

plot_grid(p_row, p3, ncol = 1, labels = c("", "c")) +
            theme(plot.margin = margin(6, 12, 0, 0))

## ----athletes-composite-misaligned, fig.asp = 0.75, fig.cap = '(ref:athletes-composite-misaligned)'----
p1 <- ggplot(athletes_df, aes(x = sex, fill = sex)) + 
  geom_bar() +
  scale_y_continuous(limits = c(0, 95), expand = c(0, 0), name = "number") +
  scale_x_discrete(name = NULL, labels = c("female", "male")) +
  scale_fill_manual(values = c("#D55E00D0", "#0072B2D0"), guide = "none") +
  theme_dviz_open(12, rel_small = 1, font_family = "Roboto Light") +
  background_grid(major = "y") +
  theme(#axis.line.x = element_blank(),
        #axis.ticks.x = element_blank(),
        #axis.ticks.length = grid::unit(0, "pt"),
        plot.margin = margin(3, 6, 6, 0))

p2 <- ggplot(athletes_df, aes(x = rcc, y = wcc, fill = sex)) + 
  geom_point(pch = 21, color = "white", size = 2.5) +
  scale_x_continuous(limits = c(3.8, 6.75), name = "RBC count") +
  scale_y_continuous(limits = c(2.2, 11.), expand = c(0, 0), name = "WBC count") +
  scale_fill_manual(values = c("#D55E00D0", "#0072B2D0"), guide = "none") +
  theme_dviz_open(12, rel_small = 1, font_family = "Roboto Light") +
  background_grid(major = "y") +
  theme(plot.margin = margin(3, 18, 0, 0))

p_row <- plot_grid(NULL, p1, p2, labels = c("", "a", "b"), nrow = 1,
                   rel_widths = c(0.03, 0.7, 1))

GeomBP <- GeomBoxplot
GeomBP$draw_key <- draw_key_polygon

p3 <- ggplot(athletes_df, aes(x = sport, y = pcBfat, color = sex, fill = sex)) + 
  stat_boxplot(width = 0.5, geom = GeomBP) +
  scale_color_manual(values = c("#D55E00", "#0072B2"), name = NULL,
                     labels = c("female   ", "male")) +
  scale_fill_manual(values = c("#D55E0040", "#0072B240"), guide = "none") +
  scale_x_discrete(name = NULL) +
  scale_y_continuous(name = "% body fat") +
  guides(color = guide_legend(override.aes = list(fill = c("#D55E00D0", "#0072B2D0"),
                                                  color = "white", size = 2),
                              direction = "horizontal")) +
  theme_dviz_open(12, rel_small = 1, font_family = "Roboto Light") +
  background_grid(major = "y") +
  theme(#axis.line.x = element_blank(),
        #axis.ticks.x = element_blank(),
        #axis.ticks.length = grid::unit(0, "pt"),
        legend.position = c(1., 0.9),
        legend.justification = "right")

stamp_ugly(plot_grid(p_row, p3, ncol = 1, labels = c("", "c")) +
            theme(plot.margin = margin(6, 12, 0, 0)))

