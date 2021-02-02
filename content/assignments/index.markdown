---
title: Assignments
toc: true
---


We will have a mix of labs and homeworks. The two will be very similar with two primary differences: (a) The labs will include designated time in class, and (b) all labs will be scored on a ["best honest effort"](../syllabus/#labs) basis, while homework will be scored based on accuracy.

#### A note on deadlines
I would like to, as much a possible, stick to the deadlines below so we can go over them together as a group *after* everyone has submitted their assignment. However, **if you need additional time for any reason** please just send me a note letting me know. You do not need to justify why. I would just ask that you not attend class during the time we are going over the assignment (but please attend the rest of the class if you are able).

## Labs

Each lab is worth 10 points. Please do not turn in partial work. Instead, please ask for help and, if needed, an extension on the deadline. 

{{< bootstrap-table "table table-hover" >}}

| Lab|Date Assigned    |Date Due         |Topic                                                      |
|---:|:----------------|:----------------|:----------------------------------------------------------|
|   1|Wed, January 13  |Wed, January 20  |[Distributions, git, and basic plot refinements](../lab-1) |
|   2|Wed, January 27  |Wed, February 03 |[Visual perception & reproducing plots](../lab-2)          |
|   3|Wed, February 03 |Wed, February 10 |[Uses of color to enhance interpretability](../lab-3)      |

{{< /bootstrap-table >}}

## Homework

There are two homework assignments in the class, each worth 20 points. These assignments will be graded on accuracy.

{{< bootstrap-table "table table-hover" >}}

| Homework|Date Assigned    |Date Due         |Topic                                                       |
|--------:|:----------------|:----------------|:-----------------------------------------------------------|
|        1|Wed, January 20  |Wed, February 03 |[Producing new visualizations through joins](../homework-1) |
|        2|Wed, February 10 |Wed, February 24 |[Uncertainty, tables, and plot refinement](../homework-2)   |

{{< /bootstrap-table >}}

## Final Project

The final project includes multiple components, culminating in a data visualization portfolio. The portfolio must include at least three data visualizations, communicate the history of each visualization, and be deployed to the web. The due dates for each component are as follows:

{{< bootstrap-table "table table-hover" >}}

|Component    |Date Due         |
|:------------|:----------------|
|Proposal     |Wed, January 27  |
|Draft        |Wed, February 24 |
|Peer Review  |Wed, March 03    |
|Presentation |Mon, March 08    |
|Product      |Wed, March 17    |

{{< /bootstrap-table >}}

The due date for the proposal can be (somewhat) flexible. However, unlike the labs and homework, the remaining aspects of the final project cannot be changed and you will lose points if your work is submitted late without prior approval. This is mostly because of concerns related peer-review and completing the project by the end of the term.

### Proposal
The proposal process is a chance for you to get feedback  from me on your plans for the final project. The more information you provide me, the better feedback I will be able to provide you. The proposal is scored on a best honest effort basis. For full credit, please include each of the following:

* Description of the data source (must be publicly available)
* Preliminary ideas (even hand sketches) of different visualizations
* Identification of the intended audience for each visualization 
  + Note, you might consider displaying the same data/relations more than 
    once, with each plot displayed for a different audience.
* The intended message to be communicated for each plot. 

### Draft
By the end of Week 8, you should have a fairly complete draft of the data 
visualizations you will be sharing in your portfolio. These should be housed on GitHub and ready to receive feedback from your peers. 

To receive credit, you must submit a link to your GitHub repo.

### Peer Review
You will be assigned to review code from three of your peers. The purpose of this exercise is to learn from each other. Programming is an immensely open-ended enterprise and there are lots of winding paths that all ultimately end up at the same destination. In terms of visualization, there is certainly plenty of room for artistic license, but certain design decisions (as we will learn) can lead to more interpretable and better data communication. Peer review is a chance to learn from your peers both by reviewing their work and by having your work reviewed.

During your peer review, you must (at minimum) note the following:

* At least three areas of strength
* At least one thing you learned from reviewing their script
* at least one and no more than three areas for improvement **for each visualization**. 
* Comments on both the code leading up to (and including) the visualization, and the visualization itself (aesthetics, best practices, etc.).

Making your code publicly available can feel daunting. The purpose of this portion of the final project is to help us all learn from each other, not to denigrate. **Under no circumstances will negative comments be tolerated**. Any comments that could be perceived as negative, and outside the scope of the code, will result in an immediate score of zero. 
Be constructive in your feedback. Be kind. We are all learning.


### Presentation
Week 10 will include each student sharing their portfolio with the class.

I encourage you to present using HTML slides produced via R Markdown 
(specifically [xaringan](https://bookdown.org/yihui/rmarkdown/xaringan.html)), but this is not required. If you are interested in doing so but feel uncertain about the process, please get in touch with me and I can meet with you individually (or with a small group if there is sufficient interest) to help get you started.

**Prior to the start of Week 10** please send me a link to your 
**published** presentation. 

You will have approximately seven minutes to share your portfolio, which provides one minute for transitions. Please cover the following during your presentation:

* Briefly show each visualization
* Pick 1-2 to go more in-depth, and discuss
  + Intended audience
  + Design choices, e.g. 
    - Colors
    - Layout
    - Choice of specific type of plot
  + Prior version(s) and how the changes helped clarity, communication, beauty,
    etc.
  + At least 1 major challenge encountered along the way
  + At least 1 major victory

Note that your final project is expected to be a work in progress during your presentation. You may still be working on the final output format, for example, or getting the portfolio published.

### Product

The final project must include

* A web-deployed portfolio showcasing your [#dataviz](https://twitter.com/search?q=%23DataViz&src=tyah)
  skills using one of the following:
  + Website with [distill](https://rstudio.github.io/distill/),  
    [R Markdown](https://bookdown.org/yihui/rmarkdown/rmarkdown-site.html), or
    [blogdown](https://bookdown.org/yihui/blogdown/)
  + Technical document with [pagedown](https://github.com/rstudio/pagedown) or
    [bookdown](https://bookdown.org/yihui/bookdown/)
  + Scientific poster with [pagedown](https://github.com/rstudio/pagedown) or [posterdown](https://github.com/brentthorne/posterdown)
  + Data dashboard with [flexdashboard](https://rmarkdown.rstudio.com/flexdashboard/)
* At least three finalized data displays, with each accompanied by a strong narrative/story, **as well as the history** of how the visualization changed over time.

You must show iterations of your data displays, highlighting how 
they evolved over time and why you made the specific changes you did. If you go the website route, a blog post showing your visualizations and their evolution would work great. Dashboards similarly have built in mechanisms to help show the history of plot.

The final project is required to be housed on GitHub and be fully reproducible. 
It will be graded on the following three criteria:

* At least three different visualizations (30 points; 10 points each)
  + Design choices (nothing violating the principles discussed in class)
  + Plot appropriate for given audience
  + Evolution of the plot is clear
* Reproducibility (20 points)
  + Should be housed on GitHub
  + I'll clone and try to reproduce - any differences between my local version and the published version will result in lost points
* Deployment (10 points)
  + Should be shareable via a link
  + No errors in the specific chosen format
  + Clear, clean, easy to follow/understand

## Extra Credit
There is one opportunity for extra credit, which is worth up to 10 
points. This includes an in-depth self-study of a topic not explicitly covered in the class. Students opting into the extra credit option will provide an (approximately) 10 minute presentation on their chosen topic to the class (presentations are likely to occur on lab days). For example, interactive and animated graphics are not explicitly covered, but packages like [gganimate](https://gganimate.com/index.html) are powerful and fun. Network visualizations and applications with textual data are examples of other topics that will not be covered but are nonetheless important. You could choose one of these areas, explore a different topic, or provide greater detail on a topic that *is* covered in class (e.g., geographic data). 

If you are interested in giving a 10 minute talk on a topic of your choice, please contact me as soon as possible to obtain approval on the topic and set a date for the presentation.

