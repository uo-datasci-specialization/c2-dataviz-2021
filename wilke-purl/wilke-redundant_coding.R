## ----echo = FALSE, message = FALSE---------------------------------------
# run setup script
source(here::here("wilke-purl", "_common.R"))

library(lubridate)
library(ggridges)

## ----iris-scatter-one-shape, fig.cap = '(ref:iris-scatter-one-shape)'----

breaks = c("setosa", "virginica", "versicolor")
labels = paste0("Iris ", breaks)

iris_scatter_base <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, fill = Species, color = Species)) + 
    scale_color_manual(values = darken(c("#E69F00", "#56B4E9", "#009E73"), 0.3),
                       breaks = breaks,
                       labels = labels,
                       name = NULL) +
    scale_fill_manual(values = c("#E69F0080", "#56B4E980", "#009E7380"),
                      breaks = breaks,
                      labels = labels,
                      name = NULL) +
    scale_x_continuous(limits = c(3.95, 8.2), expand = c(0, 0),
                       labels = c("4.0", "5.0", "6.0", "7.0", "8.0"),
                       name = "sepal length") +
    scale_y_continuous(limits = c(1.9, 4.6), expand = c(0, 0),
                       name = "sepal width")

iris_scatter <- iris_scatter_base +
  geom_point(shape=21,
             position = position_jitter(width = 0.01 * diff(range(iris$Sepal.Length)),
                                        height = 0.01 * diff(range(iris$Sepal.Width)),
                                        seed = 3942)) +
  theme_dviz_grid(25, font_family = "Roboto Light") + 
  theme(legend.title.align = 0.5,
        legend.text = element_text(face = "italic"),
        legend.spacing.y = unit(3.5, "pt"),
        plot.margin = margin(7, 7, 3, 0))

stamp_bad(iris_scatter)

## ----iris-scatter-one-shape-cvd, fig.width = 8.5, fig.asp = 0.65, fig.cap = '(ref:iris-scatter-one-shape-cvd)'----
iris_scatter_small <- iris_scatter_base +
  geom_point(shape=21,
             position = position_jitter(width = 0.01 * diff(range(iris$Sepal.Length)),
                                        height = 0.01 * diff(range(iris$Sepal.Width)),
                                        seed = 3942)) +
  theme_dviz_grid(12, font_family = "Roboto Light") + 
  theme(legend.title.align = 0.5,
        legend.text = element_text(face = "italic"),
        legend.spacing.y = grid::unit(3, "pt"),
        plot.margin = margin(24, 6, 6, 0))

cvd_sim2(iris_scatter_small,
         scale = 1, label_x = 0.)
## ----iris-scatter-three-shapes, fig.cap = '(ref:iris-scatter-three-shapes)'----
iris_scatter2_base <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, shape = Species, fill = Species, color = Species)) +     
    scale_shape_manual(values = c(21, 22, 23),
                       breaks = breaks,
                       labels = labels,
                       name = NULL) +
    scale_color_manual(values = darken(c("#56B4E9", "#E69F00", "#009E73"), 0.3),
                       breaks = breaks,
                       labels = labels,
                       name = NULL) +
    scale_fill_manual(values = c("#56B4E980", "#E69F0080", "#009E7380"),
                       breaks = breaks,
                       labels = labels,
                       name = NULL) +
    scale_x_continuous(limits = c(3.95, 8.2), expand = c(0, 0),
                       labels = c("4.0", "5.0", "6.0", "7.0", "8.0"),
                       name = "sepal length") +
    scale_y_continuous(limits = c(1.9, 4.6), expand = c(0, 0),
                       name = "sepal width")

iris_scatter2 <- iris_scatter2_base +
  geom_point(position = position_jitter(width = 0.01 * diff(range(iris$Sepal.Length)),
                                        height = 0.01 * diff(range(iris$Sepal.Width)),
                                        seed = 3942)) +
  theme_dviz_grid(25, font_family = "Roboto Light") +
  theme(legend.title.align = 0.5,
        legend.text = element_text(face = "italic"),
        legend.spacing.y = unit(3.5, "pt"),
        plot.margin = margin(7, 7, 3, 0))

iris_scatter2

## ----iris-scatter-three-shapes-cvd, fig.width = 8.5, fig.asp = 0.65, fig.cap = '(ref:iris-scatter-three-shapes-cvd)'----
iris_scatter2_small <- iris_scatter2_base +
  geom_point(size=2.,
             position = position_jitter(width = 0.01 * diff(range(iris$Sepal.Length)),
                                        height = 0.01 * diff(range(iris$Sepal.Width)),
                                        seed = 3942)) +
  theme_dviz_grid(12, font_family = "Roboto Light") + 
  theme(legend.title.align = 0.5,
        legend.text = element_text(face = "italic"),
        legend.spacing.y = grid::unit(3, "pt"),
        plot.margin = margin(24, 6, 6, 0))

cvd_sim2(iris_scatter2_small,
         scale = 1, label_x = 0.)

## ----tech-stocks-bad-legend, fig.cap = '(ref:tech-stocks-bad-legend)'----
tech_stocks <- ungroup(tech_stocks)
price_plot_base <- ggplot(tech_stocks, aes(x = date, y = price_indexed, color = ticker)) +
  geom_line(na.rm = TRUE) +
  scale_color_manual(values = c("#000000", "#E69F00", "#56B4E9", "#009E73"),
                     name = "",
                     breaks = c("GOOG", "AAPL", "FB", "MSFT"),
                     labels = c("Alphabet", "Apple", "Facebook", "Microsoft")) +
  scale_x_date(name = "year",
               limits = c(ymd("2012-06-01"), ymd("2017-05-31")),
               expand = c(0,0)) + 
  scale_y_continuous(name = "stock price, indexed",
                     limits = c(0, 560),
                     expand = c(0,0))

stamp_bad(price_plot_base + 
            theme_dviz_hgrid(font_family = "Roboto Light") + 
            theme(plot.margin = margin(3, 7, 3, 0)))

## ----tech-stocks-good-legend, fig.cap = '(ref:tech-stocks-good-legend)'----
price_plot_base_good <- ggplot(tech_stocks, aes(x = date, y = price_indexed, color = ticker)) +
  geom_line(na.rm = TRUE) +
  scale_color_manual(values = c("#000000", "#E69F00", "#56B4E9", "#009E73"),
                     name = "",
                     breaks = c("FB", "GOOG", "MSFT", "AAPL"),
                     labels = c("Facebook", "Alphabet", "Microsoft", "Apple")) +
  scale_x_date(name = "year",
               limits = c(ymd("2012-06-01"), ymd("2017-05-31")),
               expand = c(0,0)) + 
  scale_y_continuous(name = "stock price, indexed",
                     limits = c(0, 560),
                     expand = c(0,0))

price_plot_base_good +
  theme_dviz_hgrid(font_family = "Roboto Light") + 
  theme(plot.margin = margin(3, 7, 3, 0))

## If there is a clear visual ordering in your data, make sure to match it in the legend.

## ----tech-stocks-good-legend-cvd, fig.width = 8.5, fig.asp = 0.6, fig.cap = '(ref:tech-stocks-good-legend-cvd)'----
cvd_sim2(price_plot_base_good + theme_dviz_hgrid(12, font_family = "Roboto Light") + theme(plot.margin = margin(18, 6, 6, 0)),
         scale = 1, label_x = 0.)

## ----tech-stocks-good-no-legend, fig.cap = '(ref:tech-stocks-good-no-legend)'----
price_plot <- price_plot_base_good + theme_dviz_hgrid(font_family = "Roboto Light")

yann <- axis_canvas(price_plot, axis = "y") +
  geom_text(data = filter(tech_stocks, date == "2017-06-02"),
            aes(y = price_indexed, label = paste0(" ", company)),
            family = dviz_font_family,
            x = 0, hjust = 0, size = 12/.pt)

price_plot_ann <- insert_yaxis_grob(price_plot + theme(legend.position = "none"), yann,
                                    width = grid::unit(0.3, "null"))
ggdraw(price_plot_ann)

## Whenever possible, design your figures so they don't need a legend.

## ----iris-scatter-with-ellipses, fig.width = 4.6, fig.asp = 0.8, fig.cap = '(ref:iris-scatter-with-ellipses)'----
label_df <- data.frame(
  Species = c("setosa", "virginica", "versicolor"),
  label = c("Iris setosa", "Iris virginica", "Iris versicolor"),
  Sepal.Width = c(4.2, 3.76, 2.08),
  Sepal.Length = c(5.7, 7, 5.1),
  hjust = c(0, 0.5, 0),
  vjust = c(0, 0.5, 1))

iris_scatter3 <- ggplot(iris, 
      aes(
        x = Sepal.Length,
        y = Sepal.Width,
        color = Species
      )
    ) + 
    geom_point(
      aes(shape = Species, fill = Species),
      size = 2.5,
      position = position_jitter(
        width = 0.01 * diff(range(iris$Sepal.Length)),
        height = 0.01 * diff(range(iris$Sepal.Width)),
        seed = 3942)
    ) +
    stat_ellipse(size = 0.5) +
    geom_text(
      data = label_df,
      aes(
        x = Sepal.Length, y = Sepal.Width, label = label, color = Species,
        hjust = hjust, vjust = vjust
      ),
      family = dviz_font_family, size = 12/.pt,
      fontface = "italic",
      inherit.aes = FALSE
    ) +
    scale_shape_manual(
      values = c(21, 22, 23),
      breaks = breaks,
      name = NULL
    ) +
    scale_fill_manual(
      values = c("#56B4E980", "#E69F0080", "#009E7380"),
      breaks = breaks,
      name = NULL
    ) +
    scale_color_manual(
      values = darken(c("#56B4E9", "#E69F00", "#009E73"), 0.3),
      breaks = breaks,
      name = NULL
    ) +
    guides(fill = "none", color = "none", shape = "none") +
    scale_x_continuous(
      limits = c(3.95, 8.2), expand = c(0, 0),
      labels = c("4.0", "5.0", "6.0", "7.0", "8.0"),
      name = "sepal length"
    ) +
    scale_y_continuous(
      limits = c(1.9, 4.6), expand = c(0, 0),
      name = "sepal width"
    ) +
    theme_dviz_open(font_family = "Roboto Light")

iris_scatter3

## ----iris-densities-direct-label, fig.cap = '(ref:iris-densities-direct-label)'----
# compute densities for sepal lengths
iris_dens <- group_by(iris, Species) %>%
  do(ggplot2:::compute_density(.$Sepal.Length, NULL)) %>%
  rename(Sepal.Length = x)

# get the maximum values
iris_max <- filter(iris_dens, density == max(density)) %>%
  ungroup() %>%
  mutate(hjust = c(0, 0.4, 0),
         vjust = c(1, 0, 1),
         nudge_x = c(0.11, 0, 0.24),
         nudge_y = c(-0.02, 0.02, -0.02),
         label = paste0("Iris ", Species)
        )

iris_p <- ggplot(iris_dens, aes(x = Sepal.Length, y = density, fill = Species, color = Species)) + 
  geom_density_line(stat = "identity") +
  geom_text(data = iris_max, aes(label = label, hjust = hjust, vjust = vjust, color = Species,
                                 x = Sepal.Length + nudge_x, 
                                 y = density + nudge_y), 
            family = dviz_font_family, size = 12/.pt,
            inherit.aes = FALSE,
            fontface = "italic") +
  scale_color_manual(values = darken(c("#56B4E9", "#E69F00", "#009E73"), 0.3),
                    breaks = c("virginica", "versicolor", "setosa"),
                    guide = "none") +
  scale_fill_manual(values = c("#56B4E980", "#E69F0080", "#009E7380"),
                    breaks = c("virginica", "versicolor", "setosa"),
                    guide = "none") +
  scale_x_continuous(expand = c(0, 0), name = "sepal length") +
  scale_y_continuous(limits = c(0, 1.5), expand = c(0, 0)) +
  theme_dviz_hgrid(font_family = "Roboto Light")
  
iris_p

## ----iris-scatter-dens, fig.asp=0.85, fig.cap = '(ref:iris-scatter-dens)'----
# compute densities for sepal lengths
iris_dens2 <- group_by(iris, Species) %>%
  do(ggplot2:::compute_density(.$Sepal.Width, NULL)) %>%
  rename(Sepal.Width = x)

dens_limit <- max(iris_dens$density, iris_dens2$density) * 1.05 # upper limit of density curves

# we need different hjust and nudge values here
iris_max <- mutate(iris_max,
         hjust = c(1, 0.4, 0),
         vjust = c(1, 0, 1),
         nudge_x = c(-0.18, 0, 0.47),
         nudge_y = c(-0.01, 0.06, 0.03),
         label = paste0("Iris ", Species)
        )


xdens <- axis_canvas(iris_scatter2, axis = "x") +
  geom_density_line(data=iris_dens, aes(x = Sepal.Length, y = density, fill = Species, color = Species),
                    stat = "identity", size = .2) +
  geom_text(data = iris_max, aes(label = label, hjust = hjust, vjust = vjust, color = Species,
                                 x = Sepal.Length + nudge_x, 
                                 y = density + nudge_y),
            family = dviz_font_family, size = 11/.pt, 
            #color = "black", inherit.aes = FALSE,
            fontface = "italic") +
  scale_color_manual(values = darken(c("#56B4E9", "#E69F00", "#009E73"), 0.3),
                    breaks = c("virginica", "versicolor", "setosa"),
                    guide = "none") +
  scale_fill_manual(values = c("#56B4E980", "#E69F0080", "#009E7380"),
                    breaks = c("virginica", "versicolor", "setosa"),
                    guide = "none") +
  scale_y_continuous(limits = c(0, dens_limit), expand = c(0, 0))

ydens <- axis_canvas(iris_scatter2, axis = "y", coord_flip = TRUE) +
  geom_density_line(data = iris_dens2, aes(x = Sepal.Width, y = density, fill = Species, color = Species),
                    stat = "identity", alpha = 0.5, size = .2)  +
  scale_color_manual(values = darken(c("#56B4E9", "#E69F00", "#009E73"), 0.3),
                    breaks = c("virginica", "versicolor", "setosa"),
                    guide = "none") +
  scale_fill_manual(values = c("#56B4E980", "#E69F0080", "#009E7380"),
                    breaks = c("virginica", "versicolor", "setosa"),
                    guide = "none") +
  scale_y_continuous(limits = c(0, dens_limit), expand = c(0, 0)) +
  coord_flip()

p1 <- insert_xaxis_grob(iris_scatter2 + 
                          theme(legend.position = "none"),
                        xdens, grid::unit(3*14, "pt"), position = "top")
p2 <- insert_yaxis_grob(p1, ydens, grid::unit(3*14, "pt"), position = "right")

ggdraw(p2)

## ----temp-ridgeline-colorbar, fig.asp = 0.652, fig.cap = '(ref:temp-ridgeline-colorbar)'----
bandwidth <- 3.4

lincoln_base <- ggplot(lincoln_weather, aes(x = `Mean Temperature [F]`, y = `Month`, fill = ..x..)) +
  geom_density_ridges_gradient(
    scale = 3, rel_min_height = 0.01, bandwidth = bandwidth,
    color = "black", size = 0.25
  ) +
  scale_x_continuous(
    name = "mean temperature (°F)",
    expand = c(0, 0), breaks = c(0, 25, 50, 75), labels = NULL
  ) +
  scale_y_discrete(name = NULL, expand = c(0, .2, 0, 2.6)) +
  scale_fill_continuous_sequential(palette = "Heat", l1 = 20, l2 = 100, c2 = 0) +
  guides(fill = "none") +
  theme_dviz_grid(font_family = "Roboto Light") +
  theme(
    axis.text.y = element_text(vjust = 0),
    plot.margin = margin(3, 7, 3, 0)
  )

# x axis labels
temps <- data.frame(temp = c(0, 25, 50, 75))

# calculate corrected color ranges
# stat_joy uses the +/- 3*bandwidth calculation internally
tmin <- min(lincoln_weather$`Mean Temperature [F]`) - 3*bandwidth
tmax <- max(lincoln_weather$`Mean Temperature [F]`) + 3*bandwidth

xax <- axis_canvas(lincoln_base, axis = "x", ylim = c(0, 2)) +
  geom_ridgeline_gradient(data = data.frame(temp = seq(tmin, tmax, length.out = 100)),
                          aes(x = temp, y = 1.1, height = .9, fill = temp),
                          color = "transparent") +
  geom_text(data = temps, aes(x = temp, label = temp),
            color = "black", family = dviz_font_family,
            y = 0.9, hjust = 0.5, vjust = 1, size = 14/.pt) +
  scale_fill_continuous_sequential(palette = "Heat", l1 = 20, l2 = 100, c2 = 0)

lincoln_final <- insert_xaxis_grob(lincoln_base, xax, position = "bottom", height = unit(0.1, "null"))

ggdraw(lincoln_final)

