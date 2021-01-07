## ----echo = FALSE, message = FALSE, warning = FALSE---------------------------------------------------------------------------------------------------------
# run setup script
source(here::here("wilke-purl", "_common.R")
library(forcats)
library(ggmap)
library(statebins)
library(sf)
library(lubridate)
library(geofacet)


## ----world-orthographic, fig.width = 5.5, fig.asp = 1, fig.cap = '(ref:world-orthographic)'-----------------------------------------------------------------
intersperse <- function(x1, x2) {
  x <- numeric(0)
  for (i in seq_along(x1)) {
    x <- c(x, x1[i], x2[i], NA)
  }
  x
}
cenlat <- 40
cenlong <- 15
ocean_col <- "#56B4E950"
land_col <- "#E69F00B0"
graticule_col <- "grey30"
line_col <- "black"
draw_ocean(cenlat, cenlong, col = ocean_col, line_col = graticule_col, lwd = 0.25)
draw_land(map_polys$world, cenlat, cenlong, col = land_col, line_col = line_col, lwd = 0.5)
p1 <- dviz.supp::orthproj(
  lat = c(0.5, 66, 63, 54, 30.5, 44.5, 59.5),
  long = c(-25, -29, 1, 31, -22, -22, -22),
  cenlat = cenlat,
  cenlong = cenlong
)
p2 <- dviz.supp::orthproj(
  lat = c(6, 65, 65, 65, 35, 35, 35),
  long = c(-28, 52, 52, 52, -35, -35, -35),
  cenlat = cenlat,
  cenlong = cenlong
)
lines(x = intersperse(p1$x, p2$x), y = intersperse(p1$y, p2$y))
par(family = dviz_font_family, ps = 12)
text(
  x = c(0.03, p2$x[1], p2$x[7], p2$x[2]),
  y = c(0.765, p2$y[1], p2$y[7], p2$y[2]),
  labels = c("north pole", "equator", "parallels", "meridians"),
  pos = c(3, 3, 2, 4),
  offset = .2
)


## ----world-mercator, fig.width = 5, fig.asp = 0.85, fig.cap = '(ref:world-mercator)'------------------------------------------------------------------------
world_sf <- sf::st_as_sf(rworldmap::getMap(resolution = "low"))
crs_longlat <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
crs_mercator <- "+proj=merc"
# calculate bounding box in transformed coordinates
mercator_bbox <- 
  rbind(c(-180, -85), c(180, 85)) %>%
  st_multipoint() %>%
  st_sfc(
    crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
  ) %>% 
  st_transform(crs = crs_mercator)
ggplot(world_sf) + 
  geom_sf(fill = "#E69F00B0", color = "black", size = 0.5/.pt) + 
  scale_x_continuous(name = "longitude", breaks = seq(-120, 120, by = 60)) +
  scale_y_continuous(name = "latitude", breaks = seq(-80, 80, by = 20)) +
  coord_sf(
    xlim = mercator_bbox[[1]][, 1],
    ylim = mercator_bbox[[1]][, 2],
    expand = FALSE,
    crs = crs_mercator
  ) + 
  theme_dviz_grid(font_size = 12, rel_small = 1, font_family = "Roboto Light") +
  theme(
    panel.background = element_rect(fill = "#56B4E950", color = "#56B4E950"),
    panel.grid.major = element_line(color = "gray30", size = 0.25),
    axis.ticks = element_line(color = "gray30", size = 0.5/.pt)
  )


## ----world-goode, fig.width = 5*6/4.2, fig.asp = 0.45, fig.cap = '(ref:world-goode)'------------------------------------------------------------------------
crs_goode <- "+proj=igh"
# projection outline in long-lat coordinates
lats <- c(
  90:-90, # right side down
  -90:0, 0:-90, # third cut bottom
  -90:0, 0:-90, # second cut bottom
  -90:0, 0:-90, # first cut bottom
  -90:90, # left side up
  90:0, 0:90, # cut top
  90 # close
)
longs <- c(
  rep(180, 181), # right side down
  rep(c(80.01, 79.99), each = 91), # third cut bottom
  rep(c(-19.99, -20.01), each = 91), # second cut bottom
  rep(c(-99.99, -100.01), each = 91), # first cut bottom
  rep(-180, 181), # left side up
  rep(c(-40.01, -39.99), each = 91), # cut top
  180 # close
)
goode_outline <- 
  list(cbind(longs, lats)) %>%
  st_polygon() %>%
  st_sfc(
    crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
  ) %>% 
  st_transform(crs = crs_goode)
# bounding box in transformed coordinates
xlim <- c(-21945470, 21963330)
ylim <- c(-9538022, 9266738)
goode_bbox <- 
  list(
    cbind(
      c(xlim[1], xlim[2], xlim[2], xlim[1], xlim[1]), 
      c(ylim[1], ylim[1], ylim[2], ylim[2], ylim[1])
    )
  ) %>%
  st_polygon() %>%
  st_sfc(crs = crs_goode)
# area outside the earth outline
goode_without <- st_difference(goode_bbox, goode_outline)
ggplot(world_sf) + 
  geom_sf(fill = "#E69F00B0", color = "black", size = 0.5/.pt) +
  geom_sf(data = goode_without, fill = "white", color = NA) +
  geom_sf(data = goode_outline, fill = NA, color = "grey30", size = 0.5/.pt) +
  scale_x_continuous(name = NULL, breaks = seq(-120, 120, by = 60)) +
  scale_y_continuous(name = NULL, breaks = seq(-60, 60, by = 30)) +
  coord_sf(xlim = 0.95*xlim, ylim = 0.95*ylim, expand = FALSE, crs = crs_goode, ndiscr = 1000) + 
  theme_dviz_grid(font_size = 12, rel_small = 1, font_family = "Roboto Light") +
  theme(
    panel.background = element_rect(fill = "#56B4E950", color = "white", size = 1),
    panel.grid.major = element_line(color = "gray30", size = 0.25),
    axis.ticks = element_line(color = "gray30", size = 0.5/.pt)
  )


## ----usa-orthographic, fig.width = 5.5, fig.asp = 1, fig.cap = '(ref:usa-orthographic)'---------------------------------------------------------------------
cenlat <- 35
cenlong <- -130
draw_ocean(cenlat, cenlong, lwd = 0.25)
draw_land(map_polys$usa, cenlat, cenlong, col = "#D00000D0") 
draw_land(map_polys$world_no_usa, cenlat, cenlong, col = "#C0C0C0B0")
par(family = "Roboto Light", ps = 12)
text(
#  x = c(0.38, 0.05, -0.4),
#  y = c(0.15, 0.49, -0.1),
  x = c(0.36, -0.17, -0.4),
  y = c(0.13, 0.49, -0.1),
  labels = c("lower 48", "Alaska", "Hawaii"),
  col = c("white", "white", "black")
)


## ----usa-true-albers, fig.asp = 0.72, fig.cap = '(ref:usa-true-albers)'-------------------------------------------------------------------------------------
longs <- -180:-20
lats <- rep(89.9, length(longs))
earth_boundary <- sf::st_sfc(
    sf::st_linestring(
      cbind(longs, lats)
    ),
    crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
  )
earth_boundary <- sf::st_transform(earth_boundary, crs = "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
whiteout <- data.frame(
  x = earth_boundary[[1]][, 1],
  y = earth_boundary[[1]][, 2]
)
p <- ggplot(US_states_geoms$true_albers) + 
  geom_sf(fill = "#E69F00B0", color = "black", size = 0.5/.pt) +
  geom_polygon(
    data = whiteout, aes(x, y),
    fill = "white", color = "gray30",
    size = 0.5/.pt
  ) +
  coord_sf(xlim = c(-6721002, 2685733), ylim = c(-1634610, 4888053), expand = FALSE, ndiscr = 1000) +
  scale_x_continuous(name = "longitude", breaks = -20*c(3:10)) +
  scale_y_continuous(name = "latitude", breaks = (1:9)*10) +
  theme_dviz_grid(font_size = 12, rel_small = 1, font_family = "Roboto Light") +
  theme(
    #plot.background = element_rect(fill = "cornsilk"),
    panel.background = element_rect(fill = "#56B4E950"),
    panel.grid.major = element_line(color = "gray30", size = 0.25),
    axis.ticks = element_line(color = "gray30", size = 0.5/.pt)
  )
## work around bug in sf graticule code
## not needed anymore since sf 0.7-3
#b <- ggplot_build(p)
#b$layout$panel_params[[1]]$graticule$x_start[11] <- 0
#b$layout$panel_params[[1]]$graticule$y_start[11] <- 0.849
#ggdraw(ggplot_gtable(b))
p


## ----usa-albers, fig.asp = 0.65, fig.cap = '(ref:usa-albers)'-----------------------------------------------------------------------------------------------
# standard US Albers map, with AK artificially small
# mimic color of transparent orange on top of transparent blue,
# as in previous maps drawn
# color was obtained by extraction from rendered png
brown <- "#deb664"
p <- ggplot(US_states_geoms$us_albers) + 
  geom_sf(fill = brown, color = "black", size = 0.5/.pt) +
  coord_sf(datum = NA, expand = FALSE) +
  theme_dviz_map(font_family = "Roboto Light") +
  theme(
    #plot.background = element_rect(fill = "cornsilk"),
    plot.margin = margin(6, 6, 1, 1.5) 
  )
stamp_bad(p)


## ----usa-albers-revised, fig.asp = 0.75, fig.cap = '(ref:usa-albers-revised)'-------------------------------------------------------------------------------
# revised US Albers map, with AK at its original size
ggplot(US_states_geoms$albers_revised) + 
  geom_sf(fill = brown, color = "black", size = 0.5/.pt) +
  coord_sf(datum = NA, expand = FALSE) +
  theme_dviz_map(font_family = "Roboto Light") +
  theme(
    #plot.background = element_rect(fill = "cornsilk")
  )


## ----sfbay-overview, fig.width = 5.5*6/4.2, fig.asp = 0.75, fig.cap = '(ref:sfbay-overview)'----------------------------------------------------------------
# From http://www.csgnetwork.com/degreelenllavcalc.html
# Length Of A Degree Of Longitude In Meters at 38deg lat
m_per_deg <- 87832.42967867786
sfbay_scale = data.frame(
  x = -122.83,
  xend = -122.83 + 10000/m_per_deg,
  y = 37.24,
  yend = 37.24,
  label = "10km"
)
sfbay_bbox <- c(left = -122.88, bottom = 37.20, right = -120.88, top = 38.31)
wind_sfbay <- wind_turbines %>%
  filter(
    xlong < sfbay_bbox["right"],
    xlong > sfbay_bbox["left"],
    ylat > sfbay_bbox["bottom"],
    ylat < sfbay_bbox["top"]
  )
shiloh_bbox <- c(left = -121.9, bottom = 38.06, right = -121.71, top = 38.20)
tracy_bbox <- c(left = -121.73, bottom = 37.66, right = -121.55, top = 37.81)
p1 <- ggmap(sfbay_maps$sfbay_bg)  + 
  inset_ggmap(sfbay_maps$sfbay_lines) +
  geom_point(
    data = wind_sfbay,
    aes(x = xlong, y = ylat),
    size = 0.1,
    color = "#A825A8",
    alpha = 1/3
  ) +
  geom_rect(
    data = data.frame(rbind(t(shiloh_bbox), t(tracy_bbox))),
    aes(xmin = left, xmax = right, ymin = bottom, ymax = top),
    size = 0.5,
    color = "black",
    fill = NA,
    inherit.aes = FALSE
  ) +
  geom_text(
    data = data.frame(x = 0.5*(shiloh_bbox['left'] + shiloh_bbox['right']), y = shiloh_bbox['top'], label = "Shiloh Wind Farm"),
    aes(x, y, label = label),
    hjust = 0.512,
    vjust = -0.51,
    family = dviz_font_family,
    color = "white",
    size = 11/.pt
  ) +
  geom_text(
    data = data.frame(x = 0.5*(shiloh_bbox['left'] + shiloh_bbox['right']),
                      y = shiloh_bbox['top'], label = "Shiloh Wind Farm"),
    aes(x, y, label = label),
    hjust = 0.5,
    vjust = -0.5,
    family = dviz_font_family,
    size = 11/.pt
  ) +
  inset_ggmap(sfbay_maps$sfbay_labels) +
  geom_segment(
    data = sfbay_scale,
    aes(x, y, xend = xend, yend = yend),
    size = 1
  ) +
  geom_text(
    data = sfbay_scale,
    aes(0.5*(x+xend), y, label = label),
    hjust = 0.5,
    vjust = -0.5,
    family = dviz_font_family,
    size = 10/.pt
  ) +
  ggspatial::annotation_north_arrow(
    width = grid::unit(1, "cm"),
    height = grid::unit(1, "cm"),
    pad_x = grid::unit(0.25, "cm"),
    pad_y = grid::unit(0.5, "cm"),
    style = ggspatial::north_arrow_fancy_orienteering(
      line_width = 1,
      text_size = 12,
      text_family = dviz_font_family
    ),
    location ="tr"
  ) +
  theme_dviz_map(font_family = "Roboto Light")
p1


## ----sfbay-layers, fig.width = 5.5*6/4.2, fig.asp = 0.75, fig.cap = '(ref:sfbay-layers) '-------------------------------------------------------------------
l1 <- ggmap(sfbay_maps$sfbay_bg) + labs(subtitle = "terrain") + 
  geom_rect(
    data = data.frame(t(sfbay_bbox)),
    aes(xmin = left, xmax = right, ymin = bottom, ymax = top),
    fill = NA, color = "black",
    size = 0.5,
    inherit.aes  = FALSE
  ) +
  theme_dviz_map(font_family = "Roboto Light") +
  theme(plot.subtitle = element_text(margin = margin(0, 0, 3, 0)))
l2 <- ggmap(sfbay_maps$sfbay_lines) + labs(subtitle = "roads") + 
  geom_rect(
    data = data.frame(t(sfbay_bbox)),
    aes(xmin = left, xmax = right, ymin = bottom, ymax = top),
    fill = NA, color = "black",
    size = 0.5,
    inherit.aes  = FALSE
  ) +
  theme_dviz_map(font_family = "Roboto Light") +
  theme(plot.subtitle = element_text(margin = margin(0, 0, 3, 0)))
l3 <- ggmap(sfbay_maps$sfbay_labels) + 
  geom_segment(
    data = sfbay_scale,
    aes(x, y, xend = xend, yend = yend),
    size = .5*1
  ) +
  geom_text(
    data = sfbay_scale,
    aes(0.5*(x+xend), y, label = label),
    hjust = 0.5,
    vjust = -0.5,
    family = dviz_font_family,
    size = .5*10/.pt
  ) +
  geom_rect(
    data = data.frame(t(sfbay_bbox)),
    aes(xmin = left, xmax = right, ymin = bottom, ymax = top),
    fill = NA, color = "black",
    size = 0.5,
    inherit.aes  = FALSE
  ) +
  ggspatial::annotation_north_arrow(
    width = grid::unit(.5*1, "cm"),
    height = grid::unit(.5*1, "cm"),
    pad_x = grid::unit(.5*0.25, "cm"),
    pad_y = grid::unit(.5*0.5, "cm"),
    style = ggspatial::north_arrow_fancy_orienteering(
      line_width = .5*1,
      text_size = .5*12,
      text_family = dviz_font_family
    ),
    location ="tr"
  ) +
 labs(subtitle = "city labels, scale bar") + 
 theme_dviz_map(font_family = "Roboto Light") +
 theme(plot.subtitle = element_text(margin = margin(0, 0, 3, 0)))
l4 <- ggmap(sfbay_maps$sfbay_bg) +
  geom_rect(
    data = data.frame(t(sfbay_bbox)),
    aes(xmin = left, xmax = right, ymin = bottom, ymax = top),
    fill = "white", color = "black",
    size = 0.5,
    inherit.aes  = FALSE
  ) + 
  geom_point(
    data = wind_sfbay,
    aes(x = xlong, y = ylat),
    size = .5*0.1,
    color = "#A825A8",
    alpha = 1/3
  ) +
  geom_rect(
    data = data.frame(rbind(t(shiloh_bbox), t(tracy_bbox))),
    aes(xmin = left, xmax = right, ymin = bottom, ymax = top),
    size = .5*0.5,
    color = "black",
    fill = NA,
    inherit.aes = FALSE
  ) +
  geom_text(
    data = data.frame(x = 0.5*(shiloh_bbox['left'] + shiloh_bbox['right']), y = shiloh_bbox['top'], label = "Shiloh Wind Farm"),
    aes(x, y, label = label),
    hjust = 0.5,
    vjust = -0.5,
    family = dviz_font_family,
    size = .5*11/.pt
  ) +
  labs(subtitle = "wind turbines") +
  theme_dviz_map(font_family = "Roboto Light") +
  theme(plot.subtitle = element_text(margin = margin(0, 0, 3, 0)))
plot_grid(
  l1, NULL, l2,
  l4, NULL, l3,
  rel_widths = c(1, .05, 1)
)
# fig asp: 418/519 ~= 0.805


## ----shiloh-map, fig.asp = 0.75, fig.cap = '(ref:shiloh-map)'-----------------------------------------------------------------------------------------------
# From http://www.csgnetwork.com/degreelenllavcalc.html
# Length Of A Degree Of Longitude In Meters at 38deg lat
m_per_deg <- 87832.42967867786
shiloh_scale = data.frame(
  x = -121.735,
  xend = -121.735 + 2000/m_per_deg,
  y = 38.064,
  yend = 38.064,
  label = "2000m"
)
#bbox <- c(left = -121.9, bottom = 38.06, right = -121.71, top = 38.20)
wind_shiloh <- wind_turbines %>%
  filter(
    xlong < shiloh_bbox["right"],
    xlong > shiloh_bbox["left"],
    ylat > shiloh_bbox["bottom"],
    ylat < shiloh_bbox["top"]
  ) %>%
  mutate(
    name = fct_relevel(fct_collapse(p_name,
      `EDF Renewables` = "EDF Renewable V",
      `High Winds` = "High Winds",
      `Shiloh` = c("Shiloh Wind Project", "Shiloh II", "Shiloh III", "Shiloh IV"),
      `Solano` = c("Solano Phase 3", "Solano Phase IIA", "Solano Wind Project", "Solano Wind Project, Phase I", "Solano Wind Project, Phase IA"),
      `other` = c("Montezuma", "Montezuma Winds II", "unknown Solano County")
    ), "EDF Renewables", "High Winds", "Shiloh", "Solano", "other"),
    year_range = cut(
      p_year,
      breaks = c(1980, 2000, 2005, 2010, 2015),
      labels = c("before 2000", "2000 to 2004", "2005 to 2009", "2010 to 2014"),
      right = FALSE
    )
  )
p2 <- ggmap(sfbay_maps$shiloh_terrain)  + 
  geom_point(
    data = wind_shiloh,
    aes(x = xlong, y = ylat, fill = year_range, shape = name),
    size = 1.5,
    color = "black", stroke = 0.2
  ) +
  geom_segment(
    data = shiloh_scale,
    aes(x, y, xend = xend, yend = yend),
    size = 1
  ) +
  geom_text(
    data = shiloh_scale,
    aes(0.5*(x+xend), y, label = label),
    hjust = 0.5,
    vjust = -0.5,
    family = dviz_font_family,
    size = 10/.pt
  ) +
  ggspatial::annotation_north_arrow(
    width = grid::unit(1, "cm"),
    height = grid::unit(1, "cm"),
    pad_x = grid::unit(0.2, "cm"),
    pad_y = grid::unit(0.2, "cm"),
    style = ggspatial::north_arrow_fancy_orienteering(
      line_width = 1,
      text_size = 12,
      text_family = dviz_font_family
    ),
    location ="bl"
  ) +
  xlab(label = NULL) +
  ylab(label = NULL) +
  scale_fill_viridis_d(
    name = "year built",
    option = "A", end = .95, begin = 0.3, direction = -1,
    guide = guide_legend(
      order = 2,
      reverse = FALSE,
      override.aes = list(shape = 22, size = 4, stroke = 0))
  ) +
  scale_shape_manual(
    name = "project name",
    values = 21:25,
    guide = guide_legend(
      order = 1,
      override.aes = list(
        fill = "grey70",
        size = 2
      )
    )
  ) +
  theme_dviz_map(12, font_family = "Roboto Light") +
  theme(
    legend.key.width = grid::unit(12, "pt")
  )
p2


## ----population-density-counties, fig.asp = 0.73, fig.cap = '(ref:population-density-counties)'-------------------------------------------------------------
# x range: -3683715  2258154
# y range: -2839538  1558935
US_counties_income <- mutate(US_counties_income, logdens = log(as.numeric(popdens)*1e6))
p <- ggplot(US_counties_income) + 
  geom_sf(aes(color = logdens, fill = logdens), size = 0.1) + 
  geom_sf(data = US_states_geoms$albers_revised, fill = NA, color = "grey30", size = 0.2) +
  coord_sf(datum = NA, expand = FALSE) +
  scale_x_continuous(limits = c(-4000000, 2300000)) +
  scale_fill_continuous_sequential(
    aesthetics = c("color", "fill"),
    palette = "YlGnBu", rev = TRUE, cmax = 20, c2 = 20, p2 = 1.75,
    name = "population density\n(persons / square km)",
    limits = log(c(0.01, 30000)),
    breaks = log(c(0.01, 1, 100, 10000)),
    labels = c("0.01", "1", "100", "10,000"),
    guide = guide_colorbar(
      frame.colour = "black",
      ticks.colour = "white",
      barwidth = grid::unit(15, "pt"),
      barheight = grid::unit(90, "pt")
    )
  ) +
  theme_dviz_map(12, rel_small = 1, font_family = "Roboto Light") +
  theme(
    #plot.background = element_rect(fill = "cornsilk"),
    legend.position = c(0, 1),
    legend.justification = c(0, 1),
    legend.spacing.x = grid::unit(3, "pt"),
    legend.title = element_text(hjust = 0.5),
    plot.margin = margin(3, 3, 3, 1.5)
  )
ggdraw(align_legend(p))


## ----population-density-counties2, fig.asp = 0.73, fig.cap = '(ref:population-density-counties2)'-----------------------------------------------------------
# x range: -3683715  2258154
# y range: -2839538  1558935
p <- ggplot(US_counties_income) + 
  geom_sf(aes(color = logdens, fill = logdens), size = 0.1) +
  # state boundaries don't look good with this color scale
  geom_sf(data = US_states_geoms$albers_revised, fill = NA, color = "black", size = 0.2) +
  coord_sf(datum = NA, expand = FALSE) +
  scale_x_continuous(limits = c(-4000000, 2300000)) +
  scale_fill_continuous_sequential(
    aesthetics = c("color", "fill"),
    palette = "Lajolla", rev = TRUE, p1 = 2, p2 = 1.3,
    name = "population density\n(persons / square km)",
    limits = log(c(0.01, 30000)),
    breaks = log(c(0.01, 1, 100, 10000)),
    labels = c("0.01", "1", "100", "10,000"),
    guide = guide_colorbar(
      frame.colour = "black",
      ticks.colour = "white",
      barwidth = grid::unit(15, "pt"),
      barheight = grid::unit(90, "pt")
    )
  ) +
  theme_dviz_map(12, rel_small = 1, font_family = "Roboto Light") +
  theme(
    #plot.background = element_rect(fill = "cornsilk"),
    legend.position = c(0, 1),
    legend.justification = c(0, 1),
    legend.spacing.x = grid::unit(3, "pt"),
    legend.title = element_text(hjust = 0.5),
    plot.margin = margin(3, 3, 3, 1.5)
  )
ggdraw(align_legend(p))


## ----median-income-counties, eval = FALSE, fig.asp = 0.73, fig.cap = '(ref:median-income-counties)'---------------------------------------------------------
## # x range: -3683715  2258154
## # y range: -2839538  1558935
## p <- ggplot(US_counties_income) +
##   geom_sf(aes(color = median_income, fill = median_income), size = 0.1) +
##   geom_sf(data = US_states_geoms$albers_revised, fill = NA, color = "grey30", size = 0.2) +
##   coord_sf(datum = NA, expand = FALSE) +
##   scale_x_continuous(limits = c(-4000000, 2300000)) +
##   scale_fill_continuous_sequential(
##     aesthetics = c("color", "fill"),
##     #palette = "Lajolla", rev = TRUE, p1 = 2, p2 = 1.3,
##     #palette = "BlueYellow", rev = TRUE, l1 = 15, p2 = 1.7,
##     h1 = -83, h2 = 20, c1 = 30, cmax = 40, c2 = 0, l1 = 20, l2 = 100, p1 = 1, p2 = 1.2, rev = TRUE,
##     name = "median income",
##     limits = c(0, 130000),
##     breaks = c(0, 50000, 100000),
##     labels = c("$0", "$50,000", "$100,000"),
##     guide = guide_colorbar(
##       frame.colour = "black",
##       ticks.colour = "white",
##       barwidth = grid::unit(15, "pt"),
##       barheight = grid::unit(90, "pt")
##     )
##   ) +
##   theme_dviz_map(12, rel_small = 1, font_family = "Roboto Light") +
##   theme(
##     #plot.background = element_rect(fill = "cornsilk"),
##     legend.position = c(0, 1),
##     legend.justification = c(0, 1),
##     legend.spacing.x = grid::unit(3, "pt"),
##     legend.title = element_text(hjust = 0.5),
##     plot.margin = margin(3, 3, 3, 1.5)
##   )
## ggdraw(align_legend(p))


## ----median-income-counties-binned, fig.asp = 0.73, fig.cap = '(ref:median-income-counties-binned)'---------------------------------------------------------
# x range: -3683715  2258154
# y range: -2839538  1558935
US_counties_income <- mutate(
  US_counties_income,
  income_bins = cut(
      ifelse(is.na(median_income), 35000, median_income), # hide missing value
      breaks = c(0, 30000, 55000, 80000, 105000, 150000),
      labels = c("< $30k", "$30k to $60k", "$60k to $85k", "$85k to $105k", "> $105k"),
      right = FALSE
    )
  )
p <- ggplot(US_counties_income) + 
  geom_sf(aes(color = income_bins, fill = income_bins), size = 0.1) + 
  geom_sf(data = US_states_geoms$albers_revised, fill = NA, color = "grey30", size = 0.2) +
  coord_sf(datum = NA, expand = FALSE) +
  scale_x_continuous(limits = c(-4000000, 2300000)) +
  scale_fill_discrete_sequential(
    aesthetics = c("color", "fill"),
    h1 = -83, h2 = 20, c1 = 30, cmax = 40, c2 = 0, l1 = 20, l2 = 100, p1 = 1, p2 = 1.2, rev = TRUE, 
    name = "median income",
    nmax = 6,
    order = 2:6,
    guide = guide_legend(
      override.aes = list(colour = "white", size = 1),
      reverse = TRUE
    )
  ) +
  theme_dviz_map(12, rel_small = 1, font_family = "Roboto Light") +
  theme(
    #plot.background = element_rect(fill = "cornsilk"),
    legend.position = c(0, 1),
    legend.justification = c(0, 1),
    legend.spacing.x = grid::unit(3, "pt"),
    legend.spacing.y = grid::unit(3, "pt"),
    legend.title = element_text(hjust = 0.5),
    legend.key.width = grid::unit(18, "pt"),
    legend.key.height = grid::unit(15, "pt"),
    plot.margin = margin(3, 3, 3, 1.5)
  )
p


## ----median-income-states, fig.asp = 0.73, fig.cap = '(ref:median-income-states)'---------------------------------------------------------------------------
# x range: -3683715  2258154
# y range: -2839538  1558935
US_income <- mutate(
  US_income,
  income_bins = cut(
      ifelse(is.na(median_income), 25000, median_income), # hide missing value
      breaks = c(0, 40000, 50000, 60000, 70000, 80000),
      labels = c("< $40k", "$40k to $50k", "$50k to $60k", "$60k to $70k", "> $70k"),
      right = FALSE
    )
  )
p <- ggplot(US_income, aes(fill = income_bins)) + 
  geom_sf(color = "grey30", size = 0.2) + 
  coord_sf(datum = NA, expand = FALSE) +
  scale_x_continuous(limits = c(-4000000, 2300000)) +
  scale_fill_discrete_sequential(
    h1 = -83, h2 = 20, c1 = 30, cmax = 40, c2 = 0, l1 = 20, l2 = 100, p1 = 1, p2 = 1.2, rev = TRUE, 
    name = "median income",
    nmax = 7,
    order = 2:6,
    guide = guide_legend(
      override.aes = list(colour = "white", size = 1),
      reverse = TRUE
    )
  ) +
  theme_dviz_map(12, rel_small = 1, font_family = "Roboto Light") +
  theme(
    #plot.background = element_rect(fill = "cornsilk"),
    legend.position = c(0, 1),
    legend.justification = c(0, 1),
    legend.spacing.x = grid::unit(3, "pt"),
    legend.spacing.y = grid::unit(3, "pt"),
    legend.title = element_text(hjust = 0.5),
    legend.key.width = grid::unit(18, "pt"),
    legend.key.height = grid::unit(15, "pt"),
    plot.margin = margin(3, 3, 3, 1.5)
  )
stamp_bad(p)


## ----median-income-cartogram, fig.asp = 0.73, fig.cap = '(ref:median-income-cartogram)'---------------------------------------------------------------------
# copy binned data over, order of both data frames is the same
US_income_cartogram$income_bins <- US_income$income_bins
p <- ggplot(US_income_cartogram, aes(fill = income_bins)) + 
  geom_sf(color = "grey30", size = 0.2) + coord_sf(datum = NA, expand = FALSE) +
  scale_x_continuous(limits = c(-3900000, 2500000)) +
  scale_fill_discrete_sequential(
    h1 = -83, h2 = 20, c1 = 30, cmax = 40, c2 = 0, l1 = 20, l2 = 100, p1 = 1, p2 = 1.2, rev = TRUE, 
    name = "median income",
    nmax = 7,
    order = 2:6,
    guide = guide_legend(
      override.aes = list(colour = "white", size = 1),
      reverse = TRUE
    )
  ) +
  theme_dviz_map(12, rel_small = 1, font_family = "Roboto Light") +
  theme(
    #plot.background = element_rect(fill = "cornsilk"),
    legend.position = c(0, 1),
    legend.justification = c(0, 1),
    legend.spacing.x = grid::unit(3, "pt"),
    legend.spacing.y = grid::unit(3, "pt"),
    legend.title = element_text(hjust = 0.5),
    legend.key.width = grid::unit(18, "pt"),
    legend.key.height = grid::unit(15, "pt"),
    plot.margin = margin(3, 3, 3, 1.5)
  )
p


## ----median-income-statebins, fig.asp = 0.62, fig.cap = '(ref:median-income-statebins)'---------------------------------------------------------------------
filter(US_income, name != "Puerto Rico", GEOID != "11") %>% # remove Puerto Rico and DC
  ggplot(aes(state = name, fill = income_bins)) +
  geom_statebins(family = "Roboto Light",
                 lbl_size = 14/.pt) +
  expand_limits(x = -1.3) + # make space for legend
  coord_equal(expand = FALSE) +
   scale_fill_discrete_sequential(
    h1 = -83, h2 = 20, c1 = 30, cmax = 40, c2 = 0, l1 = 20, l2 = 100, p1 = 1, p2 = 1.2, rev = TRUE, 
    name = "median income",
    nmax = 7,
    order = 2:6,
    guide = guide_legend(
      override.aes = list(colour = "white", size = 1),
      reverse = TRUE
    )
  ) +
  theme_dviz_map(12, rel_small = 1, font_family = "Roboto Light") +
  theme(
    #plot.background = element_rect(fill = "cornsilk"),
    legend.background = element_blank(),
    legend.position = c(0, 1),
    legend.justification = c(0, 1),
    legend.spacing.x = grid::unit(3, "pt"),
    legend.spacing.y = grid::unit(3, "pt"),
    legend.title = element_text(hjust = 0.5),
    legend.key.width = grid::unit(18, "pt"),
    legend.key.height = grid::unit(15, "pt")
  )


## ----unemployment-geofacet, fig.width = 5.5*6/4.2, fig.asp = 0.75, fig.cap = '(ref:unemployment-geofacet)'--------------------------------------------------
adjust_labels <- as_labeller(
  function(x) {
    case_when(
      x == "New Hampshire" ~ "N. Hampshire",
      x == "District of Columbia" ~ "DC",
      TRUE ~ x
    )
  }
)
house_prices %>% 
  filter(
    date >= ymd("2007-01-01"),
    date <= ymd("2013-05-31")
  ) %>%
  ggplot(aes(date, unemploy_perc)) + 
  geom_area(fill = "#56B4E9", alpha = 0.7) +
  geom_line() + 
  scale_y_continuous(
    name = "unemployment rate",
    limits = c(0, 16), expand = c(0, 0),
    breaks = c(0, 5, 10, 15),
    labels = c("0%", "5%", "10%", "15%")
  ) +
  scale_x_date(
    name = NULL,
    breaks = ymd(c("2008-01-01", "2010-01-01", "2012-01-01")),
    labels = c("'08", "'10", "'12"),
    expand = c(0, 0)
  ) +
  coord_cartesian(clip = "off") +
  facet_geo(~state, grid = "us_state_grid1", labeller = adjust_labels) +
  theme_dviz_grid(12, font_family = "Roboto Light", rel_small = 10/12) +
  theme(
    strip.text = element_text(
      family = "Roboto Light",
      margin = margin(3, 3, 3, 3)
    ),
    axis.line.x = element_blank(),
    panel.spacing.x = grid::unit(5, "pt"),
    panel.spacing.y = grid::unit(5, "pt"),
    panel.grid.major = element_line(color = "gray80"),
    panel.background = element_rect(fill = "gray90")
  ) -> p
p

