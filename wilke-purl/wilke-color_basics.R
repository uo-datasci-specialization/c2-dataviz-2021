## ----echo = FALSE, message = FALSE---------------------------------------
# run setup script
source(here::here("wilke-purl", "_common.R"))

## ----qualitative-scales, fig.width=6, fig.asp=3*.14, fig.cap = '(ref:qualitative-scales)'----
p1 <- gg_color_swatches(7, title_family = dviz_font_family) + 
  scale_fill_OkabeIto() + ggtitle("Okabe Ito")
p2 <- gg_color_swatches(7, title_family = dviz_font_family) + 
  scale_fill_brewer(type = "qual", palette = "Dark2") + ggtitle("ColorBrewer Dark2")
p3 <- gg_color_swatches(7, title_family = dviz_font_family) + 
  scale_fill_hue() + ggtitle("ggplot2 hue")
plot_grid(p1, p2, p3, ncol = 1)

## ----popgrowth-US, fig.width = 6, fig.asp = 1.2, fig.cap = '(ref:popgrowth-US)'----
popgrowth_df <- left_join(US_census, US_regions) %>%
    group_by(region, division, state) %>%
    summarize(pop2000 = sum(pop2000, na.rm = TRUE),
              pop2010 = sum(pop2010, na.rm = TRUE),
              popgrowth = (pop2010-pop2000)/pop2000,
              area = sum(area)) %>%
    arrange(popgrowth) %>%
    ungroup() %>%
    mutate(state = factor(state, levels = state),
           region = factor(region, levels = c("West", "South", "Midwest", "Northeast")))

# make color vector in order of the state
region_colors <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442")
region_colors_dark <- darken(region_colors, 0.4)
state_colors <- region_colors_dark[as.numeric(popgrowth_df$region[order(popgrowth_df$state)])]

ggplot(popgrowth_df, aes(x = state, y = 100*popgrowth, fill = region)) + 
  geom_col() + 
  scale_y_continuous(limits = c(-.6, 37.5), expand = c(0, 0),
                     name = "percent population growth, 2000 to 2010") +
  scale_fill_manual(values = region_colors) +
  coord_flip() + 
  theme_dviz_vgrid(12, rel_small = 1, font_family = "Roboto Light") +
  theme(axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.length = unit(0, "pt"),
        axis.text.y = element_text(size = 10, color = state_colors),
        legend.position = c(.56, .68),
        #legend.text = element_text(color = region_colors),
        legend.background = element_rect(fill = "#ffffffb0"))

## ----sequential-scales, fig.width=6, fig.asp=3*.14, fig.cap = '(ref:sequential-scales)'----
p1 <- gg_color_swatches(7, title_family = dviz_font_family) + 
  scale_fill_brewer(type = "seq", palette = "Blues", direction = -1) + ggtitle("ColorBrewer Blues")
p2 <- gg_color_swatches(7, title_family = dviz_font_family) + 
  scale_fill_discrete_sequential("Heat") + ggtitle("Heat")
p3 <- gg_color_swatches(7, title_family = dviz_font_family) + 
  scale_fill_viridis_d() + ggtitle("Viridis")
plot_grid(p1, p2, p3, ncol = 1)

## ----map-Texas-income, fig.width = 6, fig.asp = 0.75, fig.cap = '(ref:map-Texas-income)'----
library(sf)

# B19013_001: Median household income in the past 12 months (in 2015 Inflation-adjusted dollars)

# EPSG:3083
# NAD83 / Texas Centric Albers Equal Area
# http://spatialreference.org/ref/epsg/3083/
texas_crs <- "+proj=aea +lat_1=27.5 +lat_2=35 +lat_0=18 +lon_0=-100 +x_0=1500000 +y_0=6000000 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"

# -110, -93.5 transformed using texas_crs
texas_xlim <- c(558298.7, 2112587)

texas_income %>% st_transform(crs = texas_crs) %>%
  ggplot(aes(fill = estimate)) + 
  geom_sf(color = "white") + 
  coord_sf(xlim = texas_xlim, datum = NA) +
  theme_dviz_map(font_family = "Roboto Light") + 
  scale_fill_distiller(
    palette = "Blues", type = 'seq', na.value = "grey60", direction = 1,
    name = "annual median income",
    limits = c(18000, 90000),
    breaks = 20000*c(1:4),
    labels = c("$20,000", "$40,000", "$60,000", "$80,000"),
    guide = guide_colorbar(
      direction = "horizontal",
      label.position = "bottom",
      title.position = "top",
      ticks = FALSE,
      barwidth = grid::unit(3.0, "in"),
      barheight = grid::unit(0.2, "in")
    )
  ) +
  theme(
    legend.title.align = 0.5,
    legend.text.align = 0.5,
    legend.justification = c(0, 0),
    legend.position = c(0.02, 0.1)
  )

## ----diverging-scales, fig.width=6, fig.asp=3*.14, fig.cap = '(ref:diverging-scales)'----
p1 <- gg_color_swatches(7, title_family = dviz_font_family) + 
  scale_fill_discrete_divergingx(palette = "Earth") + ggtitle("CARTO Earth")
p2 <- gg_color_swatches(7, title_family = dviz_font_family) + 
  scale_fill_brewer(type = "div", palette = "PiYG") + ggtitle("ColorBrewer PiYG")
p3 <- gg_color_swatches(7, title_family = dviz_font_family) + 
  scale_fill_discrete_diverging("Blue-Red") + ggtitle("Blue-Red")
plot_grid(p1, p2, p3, ncol = 1)

## ----map-Texas-race, fig.width = 6, fig.asp = 0.75, fig.cap = '(ref:map-Texas-race)'----
texas_race %>% st_sf() %>%
  st_transform(crs = texas_crs) %>%
  filter(variable == "White") %>%
  ggplot(aes(fill = pct)) +
  geom_sf(color = "white") +
  coord_sf(xlim = texas_xlim, datum = NA) + 
  theme_dviz_map(font_family = "Roboto Light") +
  scale_fill_continuous_divergingx(
    palette = "Earth",
    mid = 50,
    limits = c(0, 100),
    breaks = 25*(0:4),
    labels = c("0% ", "25%", "50%", "75%", " 100%"),
    name = "percent identifying as white",
    guide = guide_colorbar(
      direction = "horizontal",
      label.position = "bottom",
      title.position = "top",
      ticks = FALSE,
      barwidth = grid::unit(3.0, "in"),
      barheight = grid::unit(0.2, "in"))) +
  theme(
    legend.title.align = 0.5,
    legend.text.align = 0.5,
    legend.justification = c(0, 0),
    legend.position = c(0.02, 0.1)
  )

## ----accent-scales, fig.width=6, fig.asp=3*.14, fig.cap = '(ref:accent-scales)'----
accent_OkabeIto <- palette_OkabeIto[c(1, 2, 7, 4, 5, 3, 6)]
accent_OkabeIto[1:4] <- desaturate(lighten(accent_OkabeIto[1:4], .4), .8)
accent_OkabeIto[5:7] <- darken(accent_OkabeIto[5:7], .3)


p1 <- gg_color_swatches(7, title_family = dviz_font_family) + 
  scale_fill_manual(values = accent_OkabeIto) + ggtitle("Okabe Ito Accent")
p2 <- gg_color_swatches(7, title_family = dviz_font_family) + 
  scale_fill_manual(values = c("gray60", "gray70","gray80", "gray90", "#C95C4F",   '#83A121', '#6B8AD5')) + ggtitle("Grays with accents")
p3 <- gg_color_swatches(7, title_family = dviz_font_family) + 
  scale_fill_brewer(type = "qual", palette = "Accent") + ggtitle("ColorBrewer Accent")
plot_grid(p1, p2, p3, ncol = 1)

## ----popgrowth-US-highlight, fig.width = 6, fig.asp = 1.2, fig.cap = '(ref:popgrowth-US-highlight)'----
popgrowth_hilight <- left_join(US_census, US_regions) %>%
    group_by(region, division, state) %>%
    summarize(pop2000 = sum(pop2000, na.rm = TRUE),
              pop2010 = sum(pop2010, na.rm = TRUE),
              popgrowth = (pop2010-pop2000)/pop2000,
              area = sum(area)) %>%
    arrange(popgrowth) %>%
    ungroup() %>%
    mutate(state = factor(state, levels = state))
    # mutate(region = ifelse(state %in% c("Texas", "Louisiana"), "highlight", region)) %>%
    # mutate(state = factor(state, levels = state),
    #        region = factor(region, levels = c("West", "South", "Midwest", "Northeast", "highlight")))

reg_colors <- desaturate(lighten(c("#E69F00", "#56B4E9", "#009E73", "#F0E442"), .4), .8)

region_col_df <- tibble(region = c("West", "South", "Midwest", "Northeast"),
                        fill_col = reg_colors)

popgrowth_hilight <- popgrowth_hilight %>% 
  left_join(region_col_df) %>% 
  mutate(fill_col = ifelse(state == "Texas" | state == "Louisiana", 
                           darken("#56B4E9", .3),
                           fill_col))

# make color and fontface vector in order of the states
state_colors <- ifelse(
  popgrowth_hilight$state %in% c("Texas", "Louisiana"), 
  darken("#56B4E9", .4),
  "gray30"
)
state_font <- ifelse(
  popgrowth_hilight$state %in% c("Texas", "Louisiana"), 
  "Roboto Black", 
  "Roboto Light"
)

ggplot(popgrowth_hilight, aes(x = state, y = 100*popgrowth, fill = fill_col)) + 
  geom_col() + 
  scale_y_continuous(limits = c(-.6, 37.5), expand = c(0, 0),
                     name = "percent population growth, 2000 to 2010") +
  scale_fill_identity() +
  coord_flip() + 
  theme_dviz_vgrid(12, rel_small = 1, font_family = "Roboto Light") +
  theme(text = element_text(color = "gray30"),
        axis.text.x = element_text(color = "gray30"),
        axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.length = unit(0, "pt"),
        axis.text.y = element_text(size = 10, color = state_colors,
                                   family = state_font),
        legend.position = c(.56, .68),
        legend.background = element_rect(fill = "#ffffffb0"))

## ----Aus-athletes-track, fig.width = 6, fig.cap='(ref:Aus-athletes-track)'----
male_Aus <- filter(Aus_athletes, sex=="m") %>%
  filter(sport %in% c("basketball", "field", "swimming", "track (400m)",
                      "track (sprint)", "water polo")) %>%
  mutate(sport = case_when(sport == "track (400m)" ~ "track",
                           sport == "track (sprint)" ~ "track",
                           TRUE ~ sport))

male_Aus$sport <- factor(male_Aus$sport,
                         levels = c("track", "field", "water polo", "basketball", "swimming"))

colors <- c("#BD3828", rep("#808080", 4))
fills <- c("#BD3828D0", rep("#80808080", 4))

ggplot(male_Aus, aes(x=height, y=pcBfat, shape=sport, color = sport, fill = sport)) +
  geom_point(size = 3) +
  scale_shape_manual(values = 21:25) +
  scale_color_manual(values = colors) +
  scale_fill_manual(values = fills) +
  xlab("height (cm)") +
  ylab("% body fat") +
  theme_dviz_grid(font_family = "Roboto Light")

