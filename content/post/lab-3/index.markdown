---
title: 'Lab 3'
author: Daniel Anderson
date: '2021-01-28'
assigned: '2021-02-03'
due: '2021-02-10'
slug: lab-3
categories:
  - Assignment
tags: [Lab, Assignments]
toc: true
---

## Overview
The purpose of this lab is to use color to your advantage. You will be asked to
use a variety of color palettes, and use color for its three main purposes: 
(a) distinguish groups from each other, (b) represent data values, and (c)
highlight particular data points.

## Data
We'll be working with the honey production data from #tidytuesday. [The #tidytuesday repo](https://github.com/rfordatascience/tidytuesday/tree/master/data/2018/2018-05-21) 
contains the full data, but we'll work with just the cleaned up version, using
the *honeyproduction.csv* file, which is posted [in the data folder in the course repo](https://github.com/uo-datasci-specialization/c2-dataviz-2021/tree/main/data) (i.e., if you pull for the most recent changes, you should have the data).

## Assignment
1. Visualize the total production of honey across years by state  Use color to
highlight the west coast (Washington, Oregon, and California) with a different color used for each west coast state.
  + **Hint 2**: I'm not asking for a specific kind of plot, just one that does the preceding. But if you're trying to visualize change over time, a bar chart is likely not going to be the best choice.
  + **Hint 2**: To get each state to be a different color you should either map state to color (for your layer that adds the west coast colors) or use the [gghighlight](https://yutannihilation.github.io/gghighlight/index.html) package.
2. Reproduce the plot according to three different kinds of color blindness, as
well as a desaturated version. 
3. Reproduce the plot using a color blind safe palette. 
4. Download the file [here](https://github.com/cphalpert/census-regions/raw/master/us%20census%20bureau%20regions%20and%20divisions.csv) denoting the region and division of each state. 
  + Join the file with your honey file. 
  + Produce a bar plot displaying the average honey for each state (collapsing across years). 
  + Use color to highlight the region of the country the state is from. 
  + Note patterns you notice. 
5. Create a heatmap displaying the average honey production across years by *region* (averaging across states within region).
6. Create at least one more plot of your choosing using color to distinguish,
represent data values, or highlight. If you are interested in producing maps, I
suggest grabbing a simple features data frame of the US using the Albers projection
by doing the following:


```r
remotes::install_github("hrbrmstr/albersusa")
library(albersusa)
us <- usa_sf()
```

You can then join your honey data with this dataset. We'll talk about geographic
data more later in the course, but it is pretty easy to work with. For example,
you could use the data frame above to create a map of the US with:


```r
library(ggplot2)
ggplot(us) +
  geom_sf()
```

You could, of course, theme it more from there, but if you join it with your
honey data, you should be able to `fill` and/or `facet` by specific variables.

Note - this is a little trickier than it initially seems because you can "lose"
states in your map if they don't have any data (there are only 44 states
represented in your honey dataset). You should still plot all states, but just 
have them not be filled according to your fill scale if there is no data.




# Finishing up
When you have finished the above, upload your rendered (knit) HTML file to canvas.
