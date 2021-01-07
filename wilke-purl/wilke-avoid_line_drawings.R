## ----echo = FALSE, message = FALSE---------------------------------------
# run setup script
source(here::here("wilke-purl", "_common.R"))

library(forcats)
library(ggridges) # for geom_density_line

## ----titanic-ages-lines, fig.cap='(ref:titanic-ages-lines)'--------------
titanic <- titanic_all
age_hist_3 <- data.frame(age = as.character((1:25)*3-1.5), 
                         count = hist(titanic$age, breaks=(0:25)*3 + .01, plot = FALSE)$counts)

h3_bad <- ggplot(titanic, aes(x = age)) + 
  geom_histogram(fill = "transparent", color = "black")  + 
  scale_y_continuous(limits = c(0, 86), expand = c(0, 0), breaks = 25*(0:5)) +
  scale_x_continuous(limits = c(0, 75), expand = c(0, 0)) +
  theme_dviz_open(font_family = "Roboto Light") +
  background_grid(major = "y", minor = "none") +
  theme(plot.margin = margin(3, 7, 3, 1.5))

stamp_bad(h3_bad)

## ----titanic-ages-filled, fig.cap='(ref:titanic-ages-filled)'------------
h3_good <- ggplot(titanic, aes(x = age)) + 
  geom_histogram(fill = "#56B4E9", color = colorspace::lighten("#56B4E9", .5))  + 
  scale_y_continuous(limits = c(0, 86), expand = c(0, 0), breaks = 25*(0:5)) +
  scale_x_continuous(limits = c(0, 75), expand = c(0, 0)) +
  theme_dviz_open(font_family = "Roboto Light") +
  background_grid(major = "y", minor = "none") +
  theme(plot.margin = margin(3, 7, 3, 0))

h3_good

## ----iris-densities-lines, fig.cap='(ref:iris-densities-lines)'----------
# compute densities for sepal lengths
iris_dens <- group_by(iris, Species) %>%
  do(ggplot2:::compute_density(.$Sepal.Length, NULL)) %>%
  rename(Sepal.Length = x)

# get the maximum values
iris_max <- filter(iris_dens, density == max(density)) %>%
  ungroup() %>%
  mutate(
    hjust = c(0, 0.4, 0),
    vjust = c(1, 0, 1),
    nudge_x = c(0.11, 0, 0.24),
    nudge_y = c(-0.02, 0.03, -0.02) 
  )

iris_lines <- ggplot(iris_dens, aes(x = Sepal.Length, y = density, linetype = Species)) + 
  geom_density_line(stat = "identity", alpha = 0., size = 0.75) +
  geom_text(
    data = iris_max,
    aes(
      label = paste0("Iris ", Species),
      hjust = hjust, vjust = vjust,
      x = Sepal.Length + nudge_x, 
      y = density + nudge_y
    ),
    family = dviz_font_family,
    fontface = "italic",
    inherit.aes = FALSE, size = 12/.pt
  ) +
  scale_linetype_manual(
    values = c(1, 3, 4),
    breaks = c("virginica", "versicolor", "setosa"),
    guide = "none"
  ) +
  scale_x_continuous(expand = c(0, 0), name = "sepal length") +
  scale_y_continuous(limits = c(0, 1.5), expand = c(0, 0)) +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(plot.margin = margin(14, 7, 3, 0))

stamp_ugly(iris_lines)

## ----iris-densities-colored-lines, fig.cap='(ref:iris-densities-colored-lines)'----
iris_colored_lines <- ggplot(iris_dens, aes(x = Sepal.Length, y = density, color = Species)) + 
  geom_density_line(stat = "identity", alpha = 0., size = 1) +
  geom_text(
    data = iris_max,
    aes(
      label = paste0("Iris ", Species),
      hjust = hjust, vjust = vjust,
      x = Sepal.Length + nudge_x, 
      y = density + nudge_y
    ),
    family = dviz_font_family,
    fontface = "italic",
    inherit.aes = FALSE, size = 12/.pt
  ) +
  scale_color_manual(
    values = c("#56B4E9", "#E69F00", "#009E73"),
    breaks = c("virginica", "versicolor", "setosa"),
    guide = "none"
  ) +
  scale_x_continuous(expand = c(0, 0), name = "sepal length") +
  scale_y_continuous(limits = c(0, 1.5), expand = c(0, 0)) +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(plot.margin = margin(14, 7, 3, 0))

stamp_ugly(iris_colored_lines)

## ----iris-densities-filled, fig.cap='(ref:iris-densities-filled)'--------
iris_filled <- ggplot(iris_dens, aes(x = Sepal.Length, y = density, fill = Species, color = Species)) + 
  geom_density_line(stat = "identity") +
  geom_text(
    data = iris_max,
    aes(
      label = paste0("Iris ", Species),
      hjust = hjust, vjust = vjust,
      x = Sepal.Length + nudge_x, 
      y = density + nudge_y
    ),
    family = dviz_font_family,
    fontface = "italic",
    inherit.aes = FALSE, 
    size = 8
  ) +
  scale_color_manual(
    values = darken(c("#56B4E9", "#E69F00", "#009E73"), 0.3),
    breaks = c("virginica", "versicolor", "setosa"),
    guide = "none"
  ) +
  scale_fill_manual(
    values = c("#56B4E980", "#E69F0080", "#009E7380"),
    breaks = c("virginica", "versicolor", "setosa"),
    guide = "none"
  ) +
  scale_x_continuous(expand = c(0, 0), name = "sepal length") +
  scale_y_continuous(limits = c(0, 1.5), expand = c(0, 0)) +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(plot.margin = margin(14, 7, 3, 0),
        axis.text = element_text(size = 25),
        text = element_text(size = 25))

iris_filled

## ----mpg-linespoints, fig.width=5.5, fig.asp=.7416, fig.cap='(ref:mpg-linespoints)'----
mpg_linespoints <- ggplot(mpg, aes(y=cty, x=displ, shape=drv)) +
  geom_point(
    size = 2,
    position = position_jitter(
      width = 0.01 * diff(range(mpg$displ)),
      height = 0.01 * diff(range(mpg$cty)),
      seed = 7384
    )
  ) + 
  ylab("fuel economy (mpg)") +
  xlab("displacement (l)") +
  scale_shape_manual(
    values=c(4, 1, 2), 
    name="drive train",
    breaks=c("f", "r", "4"),
    labels=c("FWD", "RWD", "4WD")
  ) +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(
    legend.position = c(.7, .8),
    plot.margin = margin(3, 7, 3, 0)
  )

stamp_ugly(mpg_linespoints)

## ----mpg-filledpoints, fig.width=5.5, fig.asp=.7416, fig.cap='(ref:mpg-filledpoints)'----
mpg_filledpoints <- ggplot(mpg, aes(y = cty, x = displ, color = drv, fill = drv, shape = drv)) +
  geom_point(
    size = 3,
    position = position_jitter(
      width = 0.01 * diff(range(mpg$displ)),
      height = 0.01 * diff(range(mpg$cty)),
      seed = 7384
    )
  ) + 
  ylab("fuel economy (mpg)") +
  xlab("displacement (l)") +
  scale_color_manual(
    values = c("#202020", "#E69F00", "#56B4E9"), 
    name = "drive train",
    breaks = c("f", "r", "4"),
    labels = c("FWD", "RWD", "4WD")
  ) +
  scale_fill_manual(
    values = c("#20202080", "#E69F0080", "#56B4E980"), 
    name = "drive train",
    breaks = c("f", "r", "4"),
    labels = c("FWD", "RWD", "4WD")
  ) +
  scale_shape_manual(
    values = c(22, 21, 25), 
    name = "drive train",
    breaks = c("f", "r", "4"),
    labels = c("FWD", "RWD", "4WD")
  ) +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(
    legend.position = c(.7, .8),
    plot.margin = margin(3, 7, 3, 0)
  )
        
mpg_filledpoints

## ----lincoln-weather-box-empty, fig.cap='(ref:lincoln-weather-box-empty)'----
lincoln_weather %>% 
  mutate(
    month_short = fct_recode(
      Month,
      Jan = "January",
      Feb = "February",
      Mar = "March",
      Apr = "April",
      May = "May",
      Jun = "June",
      Jul = "July",
      Aug = "August",
      Sep = "September",
      Oct = "October",
      Nov = "November",
      Dec = "December"
    )
  ) %>%
  mutate(month_short = fct_rev(month_short)) -> lincoln_df

lincoln_box_empty <- ggplot(lincoln_df, aes(x = month_short, y = `Mean Temperature [F]`)) +
  geom_boxplot() + xlab("Month") +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(plot.margin = margin(3, 7, 3, 0))

lincoln_box_empty

## ----lincoln-weather-box-filled, fig.cap='(ref:lincoln-weather-box-filled)'----
lincoln_box_filled <- ggplot(lincoln_df, aes(x = month_short, y = `Mean Temperature [F]`)) +
  geom_boxplot(fill = 'grey90') + xlab("Month") +
  theme_dviz_open(font_family = "Roboto Light") +
  theme(plot.margin = margin(3, 7, 3, 0))

lincoln_box_filled

