---
title: 'Lab 2'
author: Daniel Anderson
date: '2021-01-20'
assigned: '2020-01-27'
due: '2020-02-03'
slug: lab-2
categories:
  - Assignment
tags: [Lab, Assignments]
toc: true
---




## Overview
The purpose of this lab is to get you to try different methods of visualizing the same data to explore what seems to work better.

## Data
We'll work with  [fivethirtyeight](https://fivethirtyeight.com) data. via the [R package](https://github.com/rudeboybert/fivethirtyeight) of the same name.

To get started, please run the following lines of code. The GitHub install in particular will take a minute or two.


```r
install.packages("fivethirtyeight")
remotes::install_github("fivethirtyeightdata/fivethirtyeightdata")
library(fivethirtyeight)
library(fivethirtyeightdata)
```

One you've loaded the packages, you will have access to a variety of datasets. The datasets we will work with are *google_trends*, *tv_states*, and *comic_characters*.

## Assignment
Start a new R Markdown document - you can choose to house this lab on 
   GitHub or not. Either way is fine. If you choose to work together with a partner or in a small group a GitHub repo is required.

Both the *google_trends* and *tv_states* datasets come from a [fivethirtyeight story](https://fivethirtyeight.com/features/the-media-really-started-paying-attention-to-puerto-rico-when-trump-did/) about how the media covered hurricanes and Trump.

1. Start with the google trends data. 
  + Visualize the change in trends for each hurricane over time in one plot with three scales. Map color to a discrete scale.
  + Visualize the trends again, this time with solid shapes (if your first plot was already solid shapes, use lines). Hint, `geom_area` can be difficult to work with if you have a grouping factor. Try `geom_ribbon` instead.
  + Visualize the same relation, but change the scales so color is mapped to a *continuous* scale.
  + Create a data frame (using `tibble()` or `data.frame()`) that includes the dates that each hurricane made landfall. Annotate one of your first two plots to include these reference points with vertical lines (*Hint*: use `geom_vline()`, specifying the data source for this layer as as this new dataset). You do not have to include text annotations - just the vertical lines, but if you would like to try, look into `geom_text()` or `geom_label()`. The hurricanes made landfall on (approximately) the following days:
    - Harvey: August 25, 2017
    - Irma: September 10, 2017
    - Jose: Did not make landfall
    - Maria: September 20, 2017
  + Make any final modifications to the plot you'd like to communicate the information as effectively as possible

2. Replicate the "National cable news networks" plot from the story using the *tv_states* data. Don't worry about all the labels. Try to match the colors but don't worry about getting them exact.

3. Use the *comic_characters* dataset to visualize the proportion of different genders using at least three different methods. With your final visualization, make any additional modifications you think would help reduce the cognitive load necessary to comprehend the figure.




# Finishing up
When you have finished the above, upload your rendered (knit) HTML file to canvas.
