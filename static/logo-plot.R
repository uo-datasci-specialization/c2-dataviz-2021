library(tidyverse)

samps <- rerun(100,
               sample(seq_len(nrow(mtcars)), nrow(mtcars), replace = TRUE))
d_samps <- map_df(samps, ~mtcars[., ], .id = "sample")

ggplot(mtcars, aes(disp, mpg)) +
  geom_point(color = "#21252A") +
  geom_smooth(aes(group = sample), 
              data = d_samps, 
              se = FALSE,
              color = "#C9CEFF",
              fullrange = TRUE,
              size = 0.1) +
  theme_minimal() +
  labs(x = "", y = "") +
  theme(
    axis.text = element_blank(),
    panel.background = element_rect(fill = "transparent", color = NA), # bg of the panel
    plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
    legend.background = element_rect(fill = "transparent"), # get rid of legend bg
    legend.box.background = element_rect(fill = "transparent") # get rid of legend panel bg
  )
ggsave(filename = "logo.png",  bg = "transparent", dpi = 700)
