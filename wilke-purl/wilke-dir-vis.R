# Code modified from Wilke https://github.com/clauswilke/dataviz/blob/master/directory_of_visualizations.Rmd
library(dplyr)
library(tidyr)
library(ggforce)
library(ggridges)
library(treemapify)
library(forcats)
library(dviz.supp)

theme_set(theme_minimal(base_size = 25))
theme_update(axis.text.x = element_blank(),
             axis.text.y = element_blank(),
             axis.title.x = element_blank(),
             axis.title.y = element_blank(),
             legend.position = "none")

# data sets
set.seed(5142)

n <- 15
x <- rnorm(n)
y <- .4*x + .6*rnorm(n)
df_scatter_xy <- data.frame(x, y)

df_one_dist <- data.frame(x = c(rnorm(1000, 1., 1.6), rnorm(300, 4, .4)))

df_one_normal <- data.frame(x = rnorm(20))

df_fractions <- data.frame(y = c(.3, .39, .48, .6, .25, .13, .22, .24, .45, .48, .3, .16),
                 x = factor(rep(1:4, 3)),
                 type = rep(c("A", "B", "C"), each = 4))


set.seed(2474)

n <- 8
x <- rnorm(n)
y <- .4*x + .6*rnorm(n)
z <- .5*x + .3*rnorm(n)
z <- (z - min(z) + 0.1)^2
df_scatter_xyz <- data.frame(x, y, z)


set.seed(5012)
df_multi_amounts <- mutate(df_fractions,
                           y = c(1.0, 1.1, 1.4, 1.2)[x]*y)

n <- 70
df_multi_dist <- data.frame(y = c(rnorm(n, 1, .8), rnorm(n, 2, .7), rnorm(n, 0, .5)),
                 type = rep(c("A", "B", "C"), each = n),
                 number = rep(c(2, 1, 3), each = n))


df_props = data.frame(value = c(55, 30, 15),
                      group = c("A", "B", "C"))

df_multi_props <- data.frame(
  var1 = rep(c("C", "B", "A"), 3),
  var2 = rep(c("A", "B", "C"), each = 3),
  count = c(4, 1, 2, 12, 9, 5, 4, 5, 4)
) %>% group_by(var2) %>%
  mutate(group_count = sum(count))

df_multi_props2 <- data.frame(
  var1 = rep(c("A", "B"), 9),
  var2 = rep(c("A", "A", "B", "B", "C", "C"), 3),
  var3 = rep(c("A", "B", "C"), each = 6),
  count = c(5, 8, 0, 0, 0, 0, 0, 3, 2, 7, 0, 0, 4, 0, 4, 2, 7, 4)
)


df_one_line <- data.frame(
  x = 1:5,
  y = c(3.1, 3.3, 4.0, 3.8, 4.4)
)

set.seed(9681)
n1 <- 1500/5
n2 <- 800/5
x1 <- rnorm(n1, 0, .7)
y1 <- 2 * x1 + rnorm(n1, 0, .8)

x2 <- rnorm(n2, 0, 0.4)
y2 <- 1.5 * x2 + rnorm(n2, .5, .8)

df_dense_scatter <- na.omit(
  data.frame(
    x = scales::censor(c(x1, x2 + 2.2), c(-2, 4)),
    y = scales::censor(c(y1, y2 + 1.5), c(-3.5, 4.5))
  )
)

df_dense_scatter_sample <- df_dense_scatter[sample(1:nrow(df_dense_scatter), 100),]

df_connected_scatter <- data.frame(
  x = c(1.9, 1.5, 2.2, 3, 3.3, 2.7, 1.7, 1),
  y = c(0.3, -1, -2.0, -0.9, .6, 1.8, 2, 0.7),
  t = 1:8
)

df_paired <- data.frame(
  y = c(6, 5.3, 3.8, 2.8, 2,
        4.3, 6.1, 5.1, 3.3, 2.4),
  x = rep(c("A", "B"), each = 5),
  group = rep(1:5, 2)
)

df_uncertain <- data.frame(
  type = c("A", "B", "C"),
  x = c(1.5, 2.2, 3.4),
  y = c(3.2, 5.1, 3.9),
  dx = c(.25, .3, .35),
  dy = c(.5, .4, .6)
)


# palettes

npal <- 5
# earth-brown
pal_earth_brown <- sequential_hcl(n = npal, h1 = 71, c1 = 80, c2 = 10, l1 = 18, l2 = 97, p1 = 1.5)

# brown-green
pal_brown_green <- sequential_hcl(n = npal, h1 = 86, c1 = 80, c2 = 10, l1 = 18, l2 = 97, p1 = 1.5)

# green-brown
pal_green_brown <- sequential_hcl(n = npal, h1 = -265, c1 = 80, c2 = 10, l1 = 18, l2 = 97, p1 = 1.5)

# burgundy-red
pal_red_brown <- sequential_hcl(n = npal, h1 = 28, c1 = 80, c2 = 10, l1 = 18, l2 = 97, p1 = 1.5)

# brown-red
pal_brown_red <- sequential_hcl(n = npal, h1 = 41, c1 = 80, c2 = 10, l1 = 18, l2 = 97, p1 = 1.5)

# ocean-blue
pal_ocean_blue <- sequential_hcl(n = npal, h1 = 241, c1 = 80, c2 = 10, l1 = 18, l2 = 97, p1 = 1.5)

# steel-blue
pal_steel_blue <- sequential_hcl(n = npal, h1 = 257, c1 = 80, c2 = 10, l1 = 18, l2 = 97, p1 = 1.5)
pal_steel_blue_inv <- sequential_hcl(n = npal, h1 = 257-180, c1 = 80, c2 = 10, l1 = 18, l2 = 97, p1 = 1.5)


## Amounts

palette <- pal_earth_brown

bars <- ggplot(df_props, aes(x = group, y = value)) + 
  geom_col(
    position="identity", color = palette[npal],
    fill = palette[3], width = 0.8
  ) +
  scale_y_continuous(limits = c(0, 66), expand = c(0, 0)) +
  scale_fill_manual(values = palette[2:4]) 

flipped_bars <- ggplot(df_props, aes(x = fct_rev(group), y = value)) + 
  geom_col(position="identity", color = palette[npal], fill = palette[3],
           width = .8) +
  scale_y_continuous(limits = c(0, 66), expand = c(0, 0)) +
  scale_fill_manual(values = palette[2:4]) +
  coord_flip() 

grouped_bars <- ggplot(filter(df_multi_amounts, x!=4), aes(x, y,
                                   fill=factor(type, levels = c("A", "C", "B")))) + 
  geom_col(position="dodge", color = palette[npal],
           width = .7) +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(0, .7)) +
  scale_fill_manual(values = palette[2:4]) 

grouped_bars_flipped <- ggplot(filter(df_multi_amounts, x!=4), aes(x, y,
                                   fill=factor(type, levels = c("B", "C", "A")))) + 
  geom_col(position="dodge", color = palette[npal],
           width = .7) +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(0, .7)) +
  scale_fill_manual(values = rev(palette[2:4])) +
  coord_flip() 

stacked_bars <- ggplot(df_multi_amounts, aes(x, y, fill=factor(type, levels = c("B", "C", "A")))) + 
  geom_col(position="stack", color = palette[npal]) +
  scale_y_continuous(limits = c(0, 1.55),
                     expand = c(0, 0)) +
  scale_fill_manual(values = rev(palette[2:4])) 

stacked_bars_flipped <- stacked_bars + coord_flip()

dots <- ggplot(df_props, aes(x = fct_rev(group), y = value)) + 
  geom_point(color = palette[2]) +
  scale_y_continuous(limits = c(0, 66), expand = c(0, 0)) +
  coord_flip()  

heatmap <- ggplot(filter(df_multi_amounts, x != 1), aes(x, y = factor(type, levels = c("A", "C", "B")), fill = y)) + 
  geom_tile(color = palette[5], size = 1.5) +
  scale_fill_continuous_sequential(h1 = 71, c1 = 80, c2 = 10, l1 = 18, l2 = 97, p1 = 1.5,
                                   begin = 0.2, end = 0.75) 



## Distributions

palette <- pal_ocean_blue

histo <- ggplot(df_one_dist, aes(x)) +
  geom_histogram(fill = palette[3], color = palette[npal], binwidth = 1, center = 0) +
  scale_x_continuous(limits = c(-4.8, 6.8), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 350), 
                     expand = c(0, 0)) 


dens <- ggplot(df_one_dist, aes(x)) +
  geom_density(fill = palette[3], color = palette[npal], bw = .35) +
  scale_x_continuous(limits = c(-4.8, 6.8), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, .27), expand = c(0, 0)) 

cum_dens <- ggplot(df_one_normal, aes(x)) +
  stat_ecdf(color = palette[2], size = 2) +
  scale_x_continuous(expand = c(0.05, 0)) +
  scale_y_continuous(limits = c(0, 1.08), expand = c(0, 0)) 

qq <- ggplot(df_one_normal, aes(sample = x)) +
  geom_abline(intercept = 0, slope = 1, color = palette[3],
              size = 2) +
  geom_qq(color = palette[2],
          size = 5) 

palette <- pal_ocean_blue

# Multiple distributions

boxplots <- ggplot(df_multi_dist, aes(x = type, y = y)) + 
  geom_boxplot(color = palette[1], fill = palette[4]) 

violin <- ggplot(df_multi_dist, aes(x = type, y = y)) + 
  geom_violin(color = palette[npal], fill = palette[2], size = 0) 

jittered <- ggplot(df_multi_dist, aes(x = type, y = y)) + 
  geom_jitter(color = palette[1], width = 0.3) 

sina <- ggplot(df_multi_dist, aes(x = type, y = y)) + 
  dviz.supp::stat_sina(color = palette[1]) 

stacked_histo <- ggplot(df_multi_dist, aes(x = y, fill = factor(type, levels = c("C", "A", "B")))) + 
  geom_histogram(color = palette[npal], binwidth = 0.5, center = 0) +
  scale_fill_manual(values = palette[2:4]) +
  scale_x_continuous() +
  scale_y_continuous(limits = c(0, 49), expand = c(0, 0)) 

overlap_dens <- ggplot(df_multi_dist, aes(x = y, fill = factor(type, levels = c("C", "A", "B")))) + 
  geom_density(alpha = 0.7, color = palette[npal]) +
  scale_fill_manual(values = palette[1:3]) +
  scale_x_continuous() +
  scale_y_continuous(limits = c(0, 1.1), expand = c(0, 0)) 

ridgeline <- ggplot(df_multi_dist, aes(x = y, y = number, group = number)) + 
  geom_density_ridges(alpha = 0.7, color = palette[npal], fill = palette[2], scale = 2.5) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(limits = c(1, 6.5), expand = c(0, 0))


## Proportions

palette <- pal_brown_green

pie <- ggplot(df_props, aes(x = 1, y = value, fill = group)) + 
  geom_col(position = "stack", color = palette[npal]) + 
  coord_polar(theta = "y") +
  scale_y_continuous(breaks = NULL, name = "") +
  scale_x_continuous(breaks = NULL, name = "") +
  scale_fill_manual(values = palette[2:4]) 


stacked_bars_prop <- ggplot(df_props, aes(x = factor(1), y = value, fill = group)) + 
  geom_col(position = position_stack(reverse = TRUE), width = .45, color = palette[npal]) + 
  scale_y_continuous(limits = c(0, 108), expand = c(0, 0)) +
  scale_fill_manual(values = palette[2:4]) 

stacked_bars_prop_flipped <- ggplot(df_props, aes(x = factor(1), y = value, fill = group)) + 
  geom_col(position = position_stack(reverse = TRUE), width = .45, color = palette[npal]) + 
  scale_y_continuous(limits = c(0, 110), expand = c(0, 0)) +
  coord_flip() +
  scale_fill_manual(values = palette[2:4]) 

bars_prop <- ggplot(df_props, aes(x = group, y = value, fill = group)) + 
  geom_col(position="identity", color = palette[npal],
           width = .8) +
  scale_y_continuous(limits = c(0, 66), expand = c(0, 0)) +
  scale_fill_manual(values = palette[2:4]) 

bars_prop_flipped <- ggplot(df_props, aes(x = fct_rev(group), y = value, fill = group)) + 
  geom_col(position="identity", color = palette[npal],
           width = .8) +
  scale_y_continuous(limits = c(0, 66), expand = c(0, 0)) +
  scale_fill_manual(values = palette[2:4]) +
  coord_flip() 

grouped_bars_prop <- ggplot(filter(df_fractions, x!=4), aes(x, y,
                                   fill=factor(type, levels = c("A", "C", "B")))) + 
  geom_col(position="dodge", color = palette[npal],
           width = .7) +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(0, .58)) +
  scale_fill_manual(values = palette[2:4]) 

stacked_bars_prop <- ggplot(df_fractions, aes(x, y, fill=type)) + 
  geom_col(position="stack", color = palette[npal]) +
  scale_y_continuous(limits = c(0, 1.08), expand = c(0, 0)) +
  scale_fill_manual(values = palette[2:4]) 

stacked_dens <- ggplot(df_multi_dist, aes(x = y, fill = factor(type, levels = c("C", "A", "B")))) + 
  geom_density(color = palette[npal], position = "fill") +
  scale_fill_manual(values = palette[2:4]) +
  scale_x_continuous(expand = c(0.04, 0)) +
  scale_y_continuous(limits = c(0, 1.08), expand = c(0, 0)) 

mosaic <- ggplot(df_multi_props, aes(x = var2, y = count, fill = var1, width = group_count)) +
  geom_bar(stat = "identity", position = "fill", colour = palette[npal], size = 0.5) +
  facet_grid(~var2, scales = "free_x", space = "free_x") +
  scale_x_discrete(name = NULL, breaks = NULL) +
  scale_y_continuous(name = NULL, breaks = NULL, expand = c(0, 0)) +
  scale_fill_manual(values = palette[4:2], guide = "none") +
  coord_cartesian(clip = "off") +
  theme(
    strip.text = element_blank(),
    panel.spacing.x = unit(0, "pt")
  )
  
treemap <- ggplot(df_multi_props, aes(area = count, subgroup = var2, fill = var2)) +
  geom_treemap(color = palette[npal], size = 0.6*.pt, alpha = NA) + 
  geom_treemap_subgroup_border(color = palette[npal], size = 1.5*.pt) +
  scale_fill_manual(values = palette[4:2], guide = "none") +
  coord_cartesian(clip = "off") 

df_sets <- gather_set_data(df_multi_props2, 1:3)

par_sets <- ggplot(df_sets, aes(x, id = id, split = y, value = count)) +
  geom_parallel_sets(aes(fill = var1), alpha = 0.7, axis.width = 0.15) +
  geom_parallel_sets_axes(axis.width = 0.09, fill = palette[2], color = palette[2]) +
  scale_x_discrete(
    name = NULL,
    breaks = NULL,
    expand = c(0, 0.15/2)
  ) +
  scale_y_continuous(breaks = NULL, expand = c(0, 0)) +
  scale_fill_manual(values = c(palette[2], palette[3]), guide = "none") 

## *x*--*y* relationships

palette <- pal_steel_blue

scatter <- ggplot(df_scatter_xy, aes(x, y)) + 
  geom_point(fill = palette[2], color = palette[npal], pch = 21, size = 2.4) + 
  scale_x_continuous(expand = c(.2, 0)) +
  scale_y_continuous(expand = c(.2, 0)) 

bubble <- ggplot(df_scatter_xyz, aes(x, y, size = z)) + 
  geom_point(fill = palette[2], color = palette[npal], pch = 21, alpha = 0.7) + 
  scale_x_continuous(expand = c(.2, 0)) +
  scale_y_continuous(expand = c(.2, 0)) +
  scale_radius(range = c(3, 10)) 

paired_scatter <- ggplot(spread(df_paired, x, y), aes(A, B)) + 
  geom_abline(slope = 1, intercept = 0, color = palette[3], size = 0.3) + 
  geom_point(
    shape = 21, size = 2.4, stroke = 1,
    fill = palette[2], color = palette[npal]
  ) +
  scale_x_continuous(limits = c(1.5, 6.5)) +
  scale_y_continuous(limits = c(1.5, 6.5)) 

slopegraph <- ggplot(df_paired, aes(x, y, group = group)) + 
  geom_line(color = palette[1]) + 
  geom_point(
    shape = 21, size = 2.4, stroke = 1,
    fill = palette[2], color = palette[npal]
  ) +
  scale_x_discrete(expand = c(0, 0.4)) +
  scale_y_continuous(limits = c(1.5, 6.5)) 

density_contours <- ggplot(df_dense_scatter, aes(x, y)) + 
  geom_density2d(binwidth = 0.02, color = palette[1]) +
  scale_x_continuous(limits = c(-2, 3.6), expand = c(0, 0)) +
  scale_y_continuous(limits = c(-4, 5), expand = c(0, 0)) 

bins_2d <- ggplot(df_dense_scatter, aes(x, y)) + 
  geom_bin2d(bins = 12, color = palette[npal], size = 0.75) +
  scale_x_continuous(limits = c(-2, 3.6), expand = c(0, 0)) +
  scale_y_continuous(limits = c(-4, 5), expand = c(0, 0)) +
  scale_fill_gradientn(colors = palette[1:(npal-1)]) 

hex_bins <- ggplot(df_dense_scatter, aes(x, y)) + 
  geom_hex(bins = 12, color = palette[npal], size = 0.75) +
  scale_x_continuous(limits = c(-2, 3.6), expand = c(0, 0)) +
  scale_y_continuous(limits = c(-4, 5), expand = c(0, 0)) +
  scale_fill_gradientn(colors = palette[1:(npal-1)]) 

cm <- cor(select(mtcars, mpg, hp, drat, wt, qsec))
df_wide <- as.data.frame(cm)
df_long <- stack(df_wide)
names(df_long) <- c("cor", "var1")
df_long <- cbind(df_long, var2 = rep(rownames(cm), length(rownames(cm))))
clust <- hclust(as.dist(1-cm), method="average") 
levels <- clust$labels[clust$order]
df_long$var1 <- factor(df_long$var1, levels = levels)
df_long$var2 <- factor(df_long$var2, levels = levels)
correlogram <- ggplot(filter(df_long, as.integer(var1) < as.integer(var2)),
       aes(var1, var2, fill=cor, size = abs(cor))) + 
  geom_point(shape = 21, stroke = 0) + 
  scale_x_discrete(position = "top", name = NULL, expand = c(0, 0.5)) +
  scale_y_discrete(name = NULL, expand = c(0, 0.5)) +
  scale_size_area(max_size = 9, limits = c(0, 0.9), guide = "none") +
  scale_fill_gradient2(high = palette[2], mid = palette[npal], low = pal_steel_blue_inv[2], guide = "none") 


lineplot <- ggplot(df_one_line, aes(x, y)) +
  geom_line(color = palette[1]) + 
  geom_point(
    shape = 21, size = 2.4, stroke = 1,
    fill = palette[2], color = palette[npal]
  ) +
  scale_x_continuous(limits = c(0.5, 5.5), breaks = c(1, 3, 5)) +
  scale_y_continuous(limits = c(2.8, 4.8)) 

connected_scatter <- ggplot(df_connected_scatter, aes(x, y, color = t, fill = t)) +
  geom_path() +
  geom_point(
    shape = 21, size = 2.4, stroke = 1,
    color = palette[npal]
  ) +
  scale_color_gradientn(
    aesthetics = c("colour", "fill"),
    colors = palette[(npal-2):1]
  ) +
  scale_x_continuous(limits = c(0.3, 3.7)) +
  scale_y_continuous(limits = c(-2.5, 2.5)) 

smoothed <- ggplot(df_dense_scatter_sample, aes(x, y)) +
  geom_smooth(
    color = palette[1],
    fill = palette[npal-2],
    size = 0.5,
    level = 0.999
  ) +
  scale_y_continuous(limits = c(-5, 5)) 


## Uncertainty

palette <- pal_red_brown

error_bars <- ggplot(df_uncertain, aes(type, y)) +
  geom_col(fill = palette[3], width = 0.8) +
  geom_segment(
    aes(xend = type, y = y-dy, yend = y+dy),
    color = palette[1],
    size = 0.7
  ) +
  scale_y_continuous(limits = c(0, 6), expand = c(0, 0)) 

error_bars_2d <- ggplot(df_uncertain, aes(x, y)) +
  geom_point(color = palette[2], size = 2) +
  geom_segment(
    aes(xend = x, y = y-dy, yend = y+dy),
    color = palette[2],
    size = 0.7
  ) +
  geom_segment(
    aes(yend = y, x = x-dx, xend = x+dx),
    color = palette[2],
    size = 0.7
  ) +
  scale_x_continuous(limits = c(1, 4)) +
  scale_y_continuous(limits = c(2, 6)) 
  

ci <- ggplot(df_dense_scatter_sample, aes(x, y)) +
  geom_smooth(
    color = palette[1],
    fill = palette[npal-2],
    size = 0.5,
    level = 0.999
  ) +
  scale_y_continuous(limits = c(-5, 5)) 

ci_graded <- ggplot(df_dense_scatter_sample, aes(x, y)) +
  geom_smooth(color = NA, fill = palette[npal-1], level = 0.999) +
  geom_smooth(color = NA, fill = palette[npal-2], level = 0.99) +
  geom_smooth(
    color = palette[1],
    fill = palette[npal-3],
    size = 0.5,
    level = 0.9
  ) +
  scale_y_continuous(limits = c(-5, 5)) 
