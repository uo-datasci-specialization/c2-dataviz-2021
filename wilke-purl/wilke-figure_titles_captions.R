## ----echo = FALSE, message = FALSE---------------------------------------
# run setup script
source(here::here("wilke-purl", "_common.R"))
library(ggrepel)
library(grid)
library(gridExtra)
library(gtable)
library(tibble)
library(lubridate)

## ----corruption-development, fig.width = 7, fig.asp = 0.7, fig.cap = '(ref:corruption-development)'----
country_highlight <- c("Germany", "Norway", "United States", "Greece", "Singapore", "Rwanda", "Russia", "Venezuela", "Sudan", "Iraq", "Ghana", "Niger", "Chad", "Kuwait", "Qatar", "Myanmar", "Nepal", "Chile", "Argentina", "Japan", "China")


corruption %>% filter(year == 2015) %>% na.omit() %>%
  mutate(region = case_when(
    region == "Middle East and North Africa" ~ "Middle East\nand North Africa",
    region == "Europe and Central Asia" ~ "Europe and\nCentral Asia",
    region == "Sub Saharan Africa" ~ "Sub Saharan\nAfrica",
    TRUE ~ region),
    label = ifelse(country %in% country_highlight, country, "")
    ) %>%
  ggplot(aes(cpi, hdi)) + 
    geom_smooth(aes(color = "y ~ log(x)", fill = "y ~ log(x)"),
                method = 'lm', formula = y~log(x), se = FALSE, fullrange = TRUE) +
    geom_point(aes(color = region, fill = region),
               size = 2.5, alpha = 0.5) + 
    geom_text_repel(aes(label = label), color = "black", size = 10/.pt,
                    point.padding = 0.1, box.padding = .6, force = 1.,
                    min.segment.length = 0, seed = 7654,
                    family = dviz_font_family) +
    scale_color_OkabeIto(name = NULL, order = c(1:5, 8)) +
    scale_fill_OkabeIto(name = NULL, order = c(1:5, 8)) +
    scale_y_continuous(limits = c(0.3, 1.05), breaks = c(0.2, 0.4, 0.6, 0.8, 1.0),
                       expand = c(0, 0),
                       name = "Human Development Index, 2015\n(1.0 = most developed)") +
    scale_x_continuous(limits = c(10, 95),
                       breaks = c(20, 40, 60, 80, 100),
                       expand = c(0, 0),
                       name = "Corruption Perceptions Index, 2015 (100 = least corrupt)") +
    guides(color = guide_legend(nrow = 1,
      override.aes = list(linetype = c(rep("blank", 5), "solid"),
                          shape = c(rep(21, 5), NA)))) +
    theme_dviz_hgrid(12, rel_small = 1, font_family = "Roboto Light") +
    theme(legend.position = "top",
          legend.justification = "right",
          legend.text = element_text(size = 10)) -> plot_corrupt_base

## for some reason grid::forceGrob creates an empty plot, not sure why
#cur_dev <- grDevices::dev.cur()
#cowplot::png_null_device(width = 7, height = 4.9)
#null_dev <- dev.cur()
#grob_corrupt_base <- grid::forceGrob(ggplotGrob(plot_corrupt_base))
#null <- grDevices::dev.off(null_dev)
#if (cur_dev > 1 ) null <- grDevices::dev.set(cur_dev)
#ggdraw(grob_corrupt_base)


ggsave(here::here("wilke-purl", "figures", "corruption_plot_base.png"), 
       plot_corrupt_base, 
       width = 7, 
       height = 4.9,
       dpi = 600)

ggdraw() + draw_image(here::here("wilke-purl", "figures", "corruption_plot_base.png"))

## ----corruption-development-infographic, fig.width = 7, fig.asp = 4.9*(0.12+1+.07)/7, fig.cap = '(ref:corruption-development-infographic)'----
plot_corrupt_title <- ggdraw() +
  labs(title = "Corruption and human development",
       subtitle = "The most developed countries experience the least corruption") +
  theme_dviz_map(12, rel_small = 1, font_family = "Roboto Light") +
  theme(plot.margin = margin(6, 0, 0, 0))

plot_corrupt_caption <- ggplot() +
  labs(caption = "Data sources: Transparency International & UN Human Development Report") +
  theme_dviz_map(12, font_family = "Roboto Light") +
  theme(plot.margin = margin(0, 0, 6, 0))


plot_grid(plot_corrupt_title,
          ggdraw() + draw_image(here::here("wilke-purl", "figures", "corruption_plot_base.png")),
          plot_corrupt_caption,
          ncol = 1, rel_heights = c(.12, 1, .07))

## If your document layout uses caption blocks underneath each figure, then place the figure titles as the first element of each caption block, not on top of the figures.

## ----blue-jays-scatter-bubbles2, fig.asp = 3/4, fig.cap='(ref:blue-jays-scatter-bubbles2)'----
blue_jays$sex <- ifelse(blue_jays$KnownSex == "F", "female birds", "male birds")
blue_jays$sex <- factor(blue_jays$sex, levels = c("male birds", "female birds"))
ggplot(blue_jays, aes(Mass, Head, size = Skull, fill = KnownSex)) + 
  geom_point(pch = 21, color = "white") +
  scale_x_continuous(name = "body mass (g)") +
  scale_y_continuous(name = "head length (mm)", breaks = c(52, 54, 56, 58, 60)) +
  scale_fill_manual(
    values = c(F = "#D55E00", M = "#0072B2"),
    labels = c("female   ", "male"),
    name = "sex",
    guide = guide_legend(
      direction = "horizontal",
      title.position = "top",
      title.hjust = 0.5,
      label.position = "right",
      keyheight = grid::unit(19, "pt"),
      order = 1,
      override.aes = list(size = 4)
    )
  ) +
  scale_radius(
    name = "skull size (mm)",
    range = c(2, 7),
    limits = c(28, 34),
    breaks = c(28, 30, 32, 34),
    labels = c("28   ", "30   ", "32   ", "34"),
    guide = guide_legend(
      direction = "horizontal",
      title.position = "top",
      title.hjust = 0.5,
      label.position = "right",
      order = 2,
      override.aes = list(fill = "gray40")
    )
  ) +
  theme_dviz_grid(font_family = "Roboto Light") +
  theme(
    legend.margin = margin(0, 0, 0, 20),
    legend.position = "top",
    legend.box = "horizontal",
    legend.box.spacing = grid::unit(0, "pt"),
    legend.justification = c(1, 0),
    legend.spacing.x = unit(2, "pt"),
    legend.spacing.y = unit(2, "pt"),
    legend.background = element_rect(fill = "white", color = NA),
    legend.key.width = unit(10, "pt")
  )

## ----tech-stocks-minimal-labeling, fig.cap = '(ref:tech-stocks-minimal-labeling)'----
price_plot_base <- ggplot(tech_stocks, aes(x = date, y = price_indexed, color = ticker)) +
  geom_line(na.rm = TRUE) +
  scale_color_manual(
    values = c("#000000", "#E69F00", "#56B4E9", "#009E73"),
    name = "",
    breaks = c("FB", "GOOG", "MSFT", "AAPL"),
    labels = c("Facebook", "Alphabet", "Microsoft", "Apple")
  ) +
  scale_x_date(
    limits = c(ymd("2012-06-01"), ymd("2017-05-31")),
    expand = c(0,0)
  ) + 
  scale_y_continuous(
    limits = c(0, 560),
    expand = c(0,0)
  ) +
  theme_dviz_hgrid(25, font_family = "Roboto Light") + 
  theme(plot.margin = margin(3, 7, 3, 0))
# 
# price_plot_base + xlab(NULL) + ylab("stock price, indexed")
# 
# ## ----tech-stocks-minimal-labeling-bad, fig.cap = '(ref:tech-stocks-minimal-labeling-bad)'----
# stamp_bad(
#   price_plot_base + xlab(NULL) + ylab(NULL)
# )
# 
# ## ----tech-stocks-labeling-ugly, fig.cap = '(ref:tech-stocks-labeling-ugly)'----
# stamp_ugly(
#   price_plot_base + xlab("time (years AD)") + ylab("stock price, indexed\n(100/share price on Jun 1, 2012)") +
#     scale_color_manual(
#       values = c("#000000", "#E69F00", "#56B4E9", "#009E73"),
#       name = "company",
#       breaks = c("FB", "GOOG", "MSFT", "AAPL"),
#       labels = c("Facebook", "Alphabet", "Microsoft", "Apple")
#     ) +
#     theme(legend.title.align = 0.5)
# 
# )
# 
# ## ----table-examples, fig.asp = 0.65, fig.cap = '(ref:table-examples)'----
# boxoffice <- tibble(
#   Rank = 1:5,
#   Title = c("Star Wars", "Jumanji", "Pitch Perfect 3", "Greatest Showman", "Ferdinand"),
#   Amount = c("$71,565,498", "$36,169,328", "$19,928,525", "$8,805,843", "$7,316,746")
# )
# 
# table_base_size = 11
# zgrob <- function(...) ggplot2::zeroGrob()
# 
# tt1 <- ttheme_minimal(
#   base_size = table_base_size,
#   base_family = dviz_font_family,
#   core = list(
#     bg_params = list(
#       col = "black",
#       lwd = 1
#     )
#   ),
#   colhead = list(
#     fg_params = list(
#       fontface = 1L,
#       fontfamily = dviz_font_family_bold
#     ),
#     bg_params = list(
#       col = "black",
#       lwd = 1
#     )
#   ),
#   rowhead = list(fg_fun = zgrob, bg_fun = zgrob)
# )
# 
# tt2 <- ttheme_default(
#   base_size = table_base_size,
#   base_family = dviz_font_family,
#   core = list(
#     fg_params = list(
#       col = c("white", "black")
#     ),
#     bg_params = list(
#       col = "black",
#       lwd = 0.5,
#       fill = c("grey45", "grey85")
#     )
#   ),
#   colhead = list(
#     fg_params = list(
#       fontface = 1L,
#       fontfamily = dviz_font_family_bold
#     ),
#     bg_params = list(
#       col = "black",
#       lwd = 0.5,
#       fill = "grey85"
#     )
#   ),
#   rowhead = list(fg_fun = zgrob, bg_fun = zgrob)
# )
# 
# tt3 <- ttheme_minimal(
#   base_size = table_base_size,
#   base_family = dviz_font_family,
#   padding = unit(c(4, 3.2), "mm"),
#   core = list(
#     fg_params = list(
#       hjust = rep(c(0.5, 0, 1), each = 5),
#       x = rep(c(0.5, 0.1, 0.9), each = 5)
#     ),
#     bg_params = list(
#       col = NA
#     )
#   ),
#   colhead = list(
#     fg_params = list(
#       hjust = c(0.5, 0, 1),
#       x = c(0.5, 0.1, 0.9),
#       fontface = 1L,
#       fontfamily = dviz_font_family_bold
#     ),
#     bg_params = list(
#       col = NA
#     )
#   ),
#   rowhead = list(fg_fun = zgrob, bg_fun = zgrob)
# )
# 
# tt4 <- ttheme_default(
#   base_size = table_base_size,
#   base_family = dviz_font_family,
#   core = list(
#     fg_params = list(
#       col = "black",
#       hjust = rep(c(0.5, 0, 1), each = 5),
#       x = rep(c(0.5, 0.1, 0.9), each = 5)
#     ),
#     bg_params = list(
#       col = NA,
#       fill = c('#D9E0EF', '#C2CCE3') #c("grey95", "grey85")
#     )
#   ),
#   colhead = list(
#     fg_params = list(
#       col = "white",
#       hjust = c(0.5, 0, 1),
#       x = c(0.5, 0.1, 0.9),
#       fontface = 1L,
#       fontfamily = dviz_font_family_bold
#     ),
#     bg_params = list(
#       col = NA,
#       fill = "#4069A6"#"grey65"
#     )
#   ),
#   rowhead = list(fg_fun = zgrob, bg_fun = zgrob)
# )
# 
# # horizontal line to be used as separator
# hline_top <- segmentsGrob(
#   x0 = unit(0,"npc"),
#   y0 = unit(1,"npc"),
#   x1 = unit(1,"npc"),
#   y1 = unit(1,"npc"),
#   gp = gpar(lwd = 0.75, col = "black")
# )
# hline_bottom <- segmentsGrob(
#   x0 = unit(0,"npc"),
#   y0 = unit(0,"npc"),
#   x1 = unit(1,"npc"),
#   y1 = unit(0,"npc"),
#   gp = gpar(lwd = 0.75, col = "black")
# )
# 
# t1 <- tableGrob(boxoffice, rows = rep("", nrow(boxoffice)), theme = tt1)
# t1$layout$clip <- "off"
# t1 <- gtable_add_padding(t1, margin(14, 16, 0, -2))
# 
# t2 <- tableGrob(boxoffice, rows = rep("", nrow(boxoffice)), theme = tt2)
# t2$layout$clip <- "off"
# t2 <- gtable_add_padding(t2, margin(14, 16, 0, -2))
# 
# t3 <- tableGrob(boxoffice, rows = rep("", nrow(boxoffice)), theme = tt3)
# t3 <- gtable_add_grob(t3,
#   grobs = grobTree(hline_top, hline_bottom),
#   t = 1, b = 1, l = 2, r = 4)
# t3 <- gtable_add_grob(t3,
#   grobs = hline_bottom,
#   t = 6, b = 6, l = 2, r = 4)
# t3$layout$clip <- "off"
# t3 <- gtable_add_padding(t3, margin(14, 14, 0, -7))
# 
# t4 <- tableGrob(boxoffice, rows = rep("", nrow(boxoffice)), theme = tt4)
# t4$layout$clip <- "off"
# t4 <- gtable_add_padding(t4, margin(14, 16, 0, -2))
# 
# plot_grid(
#   stamp_ugly(t1), NULL, stamp_ugly(t2),
#   NULL, NULL, NULL,
#   t3, NULL, t4,
#   rel_widths = c(1, 0.06, 1),
#   rel_heights = c(1, 0.08, 1),
#   labels = c("a", "", "b", "", "", "", "c", "", "d")
# )
# 

