---
title: "EDLD 652: Data visualization for EDS"
toc: true
---

Below are the meeting times for our class

* **Term:** Winter 2020
* **Time:** M/W, 10-11:20
* **Classroom:** Lokey 115
* **Instructor:** Daniel Anderson, PhD
	+ *email:* (preferred contact method) [daniela@uoregon.edu](mailto:daniela@uoregon.edu)
	+ *phone:* 541-346-3317
	+ *office:* 175 Lokey
	+ *office hours*: By appointment
	+ *pronouns:* he/him/his

## Course Overview
This is the second course in a sequence of courses that will eventually lead to an *educational data science* specialization. This course will be taught through [R](https://cran.r-project.org), a free and open-source statistical computing environment. This course will give students a foundation in the principles and practice of data visualization, particularly as applied to scientific and technical data. We will have weekly lectures, covering a wide variety of topics including human perception, color theory, principles of visual design, etc. We will also have weekly hands-on laboratory sessions in which students will have the opportunity to put the lecture material into practice. Often when creating effective data visualizations, it is necessary to combine and transform different data sources, and this will be a considerable focus of the course as well.


## Student Learning objectives
By the end of this course, students should be able to:

* Transform data in a variety of ways to create effective data visualizations
* Understand and fluently apply different types of data joins
* Customize graphics in a variety of ways (e.g., color choices, text annotations, categorical axis ordering)
* Create an online data visualization portfolio 

# Course Readings 
All course readings are freely available online or will be provided by the
instructor. 

## Books (required)

* Jenny Bryan, [Happy git with R](http://happygitwithr.com).
* Kieran Healy, [Data Visualization: A Practical Introduction.](http://socviz.co/) Forthcoming. Princeton University Press.
* Claus Wilke, [Fundamentals of Data Visualization.](https://serialmentor.com/dataviz/) Forthcoming. O'Reilly.

We will also have select readings from
* Hadley Wickham & Garrett Grolemund, [R for Data Science: Import, Tidy, Transform, Visualize, and Model Data](https://r4ds.had.co.nz)

# Assignments and Grading
Your final grade will be composed of five components: 

* 5 labs at 6 points each (30 points; 15%) 
* 2 homework assignments at 20 points each (40 points; 10%) 
* five-minute data visualization "in the wild" presentation (10 points; 5%) 
* Final Project (120 points; 60%)
  + Proposal (10 points; 5%)
  + Draft (15 points; 7.5%)
  + Peer review (15 points; 7.5%)
  + Presentation (20 points; 10%)
  + Product (60 points; 30%)

## Labs (30 points; 15%)
There are 5 labs during the course, scored at 6 points each, which must be
submitted within one week of being assigned. Labs will include designated
in-class time, but any work not completed during class must be completed
on your own. Labs will be scored on a "best honest effort" basis, which
generally implies zero or full credit (i.e.,the assignment was or was not fully 
completed). However, many of the labs require students complete specific
portions before moving on to the next sections. If you find yourself stuck and
unable to proceed, **please contact the instructor for help rather than
submitting incomplete work**. Contacting the instructor is part of the "best 
honest effort", and can result in full credit for an assignment even if the the 
work is not fully complete. **If the assignment is not complete, and the student 
has not contacted the instructor for help, it is likely to result is a score of 
zero**.

## Homework (40 points; 20%)
Homework assignments are essentially extended labs, with two exceptions: (1) No
time will be designated during class to homework completion, and (2) homework
will be scored on a correct/incorrect basis. Two homework will be assigned, each
worth up to 20 points.

## Data visualizations "in the wild" presentation (10 points; 5%)
On the first day of the class you will be randomly assigned a date for a 
presentation. 

Presentations will start with the second meeting of class. The assignment requires:

* Identifying two data visualizations intended for different audiences (e.g.,
	scientific community, popular culture, data users [teachers/educators, etc.])
* Sharing the data visualizations with the class, and discussing the following:
	+ What is trying to be communicated?
	+ How effective do you judge the visualization at communicating the content? Why?
	+ At least one area of strength.
	+ At least one potential area for improvement.

Note that this project is aimed at identifying a range of data visualizations.
It would be ideal if both model data visualizations and poor data visualizations
were presented from a variety of sources. Your two visualizations **must** be
aimed at separate audiences. 

## Final Project (120 points; 60%)
The final project will include a portfolio of your data visualizations. At least
**three** different data visualizations must be included, as well as the 
history of how the visualization changed over time. Among these three 
visualizations, at least one continuous variable and one categorical variable
must be included. The portfolios must be housed on *GitHub* and be 
reproducible. In occasional situations, it can be helpful to make final 
modifications to your plot through systems outside of R (e.g., Adobe 
Illustrator, Inkscape). If you choose to make these modifications (not required)
they are the one (and only) acceptable exception to full reproducibility. 

### Proposal (10 points; 5%; **Due February 5**)
At the end of Week 5, you must include a proposal of your data visualization
portfolio that includes the following:

* Description of the data source (must be publicly available)
* Preliminary ideas (even hand sketches) of different visualizations
* Identification of the intended audience for each visualization 
	+ Note, you might consider displaying the same data/relations more than 
		once, with each plot displayed for a different audience.
* The intended message to be communicated for each plot. 


### Portfolio draft (15 points; 7.5%; **Due February 26**)
By the end of Week 8, you should have a fairly complete draft of the data 
visualizations you will be sharing in your portfolio. These should be housed
on GitHub and ready to receive feedback from your peers.

### Peer review (15 points; 7.5%; **Due March 4**)
You will be assigned to three of your peers code for their data visualizations. 
The purpose of this exercise is to learn from each other. Programming is an 
immensely open-ended enterprise and there are lots of winding paths that all 
ultimately end up at the same destination. In terms of visualization, there
is certainly plenty of room for artistic license, but certain design decisions
(as we will learn) can lead to more interpretable and better data 
communication. Thus, peer review is a chance to not only learn from others, but
get feedback on your (expected to be in-progress) design decisions.

During your peer review, you must note (a) at least three areas of strength, 
(b) at least one thing you learned from reviewing their script, and (c) at least 
one and no more than three areas for improvement for each visualization. **The
peer review should include comments on both the code leading up to the 
visualization, and the visualization itself**.

Making your code publicly available can feel daunting. The purpose of this 
portion of the final project is to help us all learn from each other, not to 
denigrate. **Under no circumstances will negative comments be tolerated**. Any 
comments that could be perceived as negative, and outside the scope of the 
code, will result in an immediate score of zero. Be constructive in your 
feedback. Be kind. We are all learning.

### Presentation (20 points; 10%)
Week 10 will include each student sharing their portfolio with the class.

I encourage you to present using HTML slides produced via R Markdown 
(specifically [xaringan](https://bookdown.org/yihui/rmarkdown/xaringan.html)),
but this is not required.

**Prior to the start of Week 10** please send me a link to your 
published presentation. I will then pre-load all the presentations in different 
tabs on my computer.

You will have approximately five minutes to share your portfolio (the amount of 
time will vary depending on the enrollment of the class). Please cover the 
following:

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

### Product (60 points; 30%)

The final project must include

* A web-deployed portfolio showcasing your [#dataviz](https://twitter.com/search?q=%23DataViz&src=tyah)
  skills.
  + [radix](https://rstudio.github.io/radix/) 
    [R Markdown](https://bookdown.org/yihui/rmarkdown/rmarkdown-site.html) or
    [blogdown](https://bookdown.org/yihui/blogdown/) website
  + Technical document with [pagedown](https://github.com/rstudio/pagedown) or
    [bookdown](https://bookdown.org/yihui/bookdown/)
  + Scientific poster with [pagedown](https://github.com/rstudio/pagedown)
  + [flexdashboard](https://rmarkdown.rstudio.com/flexdashboard/)
* At least three finalized data displays, with each accompanied by a strong 
	narrative/story, as well as the history of how the visualization changed over 
	time.

You must show iterations of your data displays, highlighting how 
they evolved over time and why you made the specific changes you did. If you go 
the website route, a blog post showing your visualizations and their evolution 
would work great. Dashboards similarly have built in mechanisms to help show
the history of plot.

The final project is required to be housed on GitHub and be fully reproducible. 
It will be graded on the following three criteria:

* At least three different visualizations (30 points; 10 points each)
	+ Design choices
	+ Plot appropriate for given audience
	+ Evolution of the plot is clear
* Reproducibility (20 points)
	+ Should be housed on GitHub
	+ I'll clone and try to reproduce
* Deployment (10 points)
	+ Should be shareable via a link
	+ No errors in the specific chosen format
	+ Clear, clean, easy to follow/understand

## Extra Credit
There is one opportunity for extra credit, which is s worth up to 10 
points, and is an in-depth self-study of a topic not explicitly covered 
in the class. Students opting into the extra credit option will provide a 10 
minute presentation on their chosen topic to the 
class (presentations are likely to occur on lab days). For example, 
interactive and animated graphics are not explicitly covered, but newer packages 
like [gganimate](https://gganimate.com/index.html) are powerful and fun. We also 
will only have a quick introduction to geographic mapping, and network data will
not be covered at all. Any of these topics 
would be excellent choices for a presentation. You could also choose an area
that is covered in the class, but provide greater depth (e.g., color). It is
also important to keep in mind that this course is about communicating **and** 
transforming data, and so topics on data transformations would also be 
appropriate. For example, you may choose to present on integrating R with SQL
databases. If you are interested in giving a 10 minute talk on a topic of your
choice, please contact the instructor as soon as possible to obtain approval on
the topic and set a date for the presentation.


# Grading Components (200 points possible)
|  **Lower percent** |**Lower point range**  | **Grade** | **Upper point range**  | **Upper percent**|
|  :------: | :------   | :-:| :-------: | ----:|
|  0.97     | (194 pts) | A+ |           |      |
|  0.93     | (186 pts) | A  | (194 pts) | 0.97 |
|  0.90     | (180 pts) | A- | (186 pts) | 0.93 |
|  0.87     | (174 pts) | B+ | (180 pts) | 0.90 |
|  0.83     | (166 pts) | B  | (174 pts) | 0.87 |
|  0.80     | (160 pts) | B- | (166 pts) | 0.83 |
|  0.77     | (154 pts) | C+ | (160 pts) | 0.80 |
|  0.73     | (146 pts) | C  | (154 pts) | 0.77 |
|  0.70     | (140 pts) | C- | (146 pts) | 0.73 |
|           |           | F  | (140 pts) | 0.70 |

# Student Engagement Inventory
Graduate: 1 credit hour = 40 hours of student engagement (3 credit hours = 120 hours of student engagement) 

| **Educational activity** | **Hours student engaged** | **Explanatory comments (if any):**                                                                               |
| :----------------------- | :-----------------------: | :--------------------------------------------------------------------------------------------------------------- |
| Course attendance        |            26.5           | 20 meetings, at 80 minutes per meeting                                                                           |
| Assigned readings        |            26.5           | Weekly readings are assigned, and are expected to take roughly as long to complete as the in-seat time per week. |
| Projects                 |            30             | Final project, as described above                                                                                |
| Homework                 |            37             | 6 Labs, at approximately one hour per lab spent out of class (6 hours), plus 4 DataCamp modules at approximately 5 hours per module, plus two homework assignments at approximately 5 hours each |
| Total hours:             |            120            |                                                                                                                  |

# Attendance and Absence Guidelines
Attendance at all class and discussion groups is expected and required, as described above.

Students must contact the instructor in case of illness or emergencies that preclude attending class sessions. Messages can be left on the instructor's voice mail or e-mail at any time of the day or night, prior to class. If no prior arrangements have been made before class time, the absence will be unexcused. Excused absences will involve make-up assignments, with make-up assignment procedures to be discussed in class on the first day. 

If you are unable to complete an assignment due to a personal and/or family emergency, you should contact your instructor or discussion leader as soon as possible. On a case-by-case basis, the instructor will determine whether the emergency qualifies as an excused absence. 

# Expected Classroom Behavior
Students are expected to participate in classroom activities. If use of digital devices or engagement in other non-class activities during class for purposes not regarding classroom activities is critically necessary, the student should engage in these activities while on break, or check with the instructor to arrange for a 10-minute break for unusual circumstances, but only if critically necessary. 

# Course Policies 
## Diversity, Equity and Inclusion
It is the policy of the University of Oregon to support and value equity and diversity and to provide inclusive learning environments for all students.  To do so requires that we: 

* respect the dignity and essential worth of all individuals. 
* promote a culture of respect throughout the University community. 
* respect the privacy, property, and freedom of others. 
* reject bigotry, discrimination, violence, or intimidation of any kind. 
* practice personal and academic integrity and expect it from others. 
* promote the diversity of opinions, ideas and backgrounds which is the lifeblood of the university.

In this course, class discussions, projects/activities and assignments will challenge students to think critically about and be sensitive to the influence, and intersections, of race, ethnicity, nationality, documentation status, language, religion, gender, socioeconomic background, physical and cognitive ability, sexual orientation, and other cultural identities and experiences. Students will be encouraged to develop or expand their respect and understanding of such differences.

Maintaining an inclusive classroom environment where all students feel able to talk about their cultural identities and experiences, ideas, beliefs, and values will not only be my responsibility, but the responsibility of each class member as well. Behavior that disregards or diminishes another student will not be permitted for any reason. This means that no racist, ableist, transphobic, xenophobic, chauvinistic or otherwise derogatory comments will be allowed. It also means that students must pay attention and listen respectfully to each other’s comments.

## Indigenous Recognition Statement
The University of Oregon is located on Kalapuya Ilihi, the traditional indigenous homeland of the Kalapuya people. Today, descendants are citizens of the Confederated Tribes of the Grand Ronde Community of Oregon and the Confederated Tribes of the Siletz Indians of Oregon, and they continue to make important contributions in their communities, at UO, and across the land we now refer to as Oregon.

## Using Pronouns and Personal Preference
The College of Education is always working to include and engage everyone. One way we can do this is to share our pronouns, or the words we want to be called when people aren’t using our name. Like names, pronouns are an important part of how we identify ourselves. Because we recognize that assuming someone’s gender can be hurtful, especially to members of our community who are transgender, genderqueer, or non-binary. This practice can assist in promoting respectful communication. As a community, we are all learning together about the importance of pronouns and being better allies to the trans community on campus. If you would like to ensure clarity around pronouns, please feel free to share any pronouns you would prefer me to use when referring to you to help me be aware of how to address you respectfully. Please visit this university website for more information. https://studentlife.uoregon.edu/pronouns

## Children in class

I applaud all of you who go to graduate school with children! I had both of my girls while a doctoral student, and I understand the difficulty in balancing academic, work, and family commitments. I want you to succeed. Here are my policies regarding children in class:

1. All breastfeeding babies are welcome in class as often as necessary.
2. Non-nursing babies and older children are welcome whenever alternate arrangements cannot be made. As a parent of two young children, I understand that babysitters fall through, partners have conflicting schedules, children get sick, and other issues arise that leave parents with few other options.
3. In cases where children come to class, I invite parents/caregivers to sit close to the door so as to more easily excuse yourself to attend to your child's needs. Non-parents in the class: please reserve seats near the door for your parenting classmates.
4. All students are expected to join with me in creating a welcoming environment that is respectful of your classmates who bring children to class.

I understand that sleep deprivation and exhaustion are among the most difficult aspects of parenting young children. The struggle of balancing school, work, childcare, and graduate school is tiring, and I will do my best to accommodate any such issues while maintaining the same high expectations for all students enrolled in the class. ***Please do not hesitate to contact me with any questions or concerns.***


## Documented Disability
Appropriate accommodations will be provided for students with documented disabilities. If you have a documented disability and require accommodation, arrange to meet with the course instructor within the first two weeks of the term. The documentation of your disability must come in writing from the Accessible Education Center in the Office of Academic Advising and Student Services.  Disabilities may include (but are not limited to) neurological impairment, orthopedic impairment, traumatic brain injury, visual impairment, chronic medical conditions, emotional/psychological disabilities, hearing impairment, and learning disabilities. For more information on Accessible Education Center, please see http://aec.uoregon.edu 

## Mandatory Reporting of Child Abuse
UO employees, including faculty, staff, and GEs, are mandatory reporters of child abuse. This statement is to advise you that that your disclosure of information about child abuse to a UO employee may trigger the UO employee’s duty to report that information to the designated authorities. Please refer to the following links for detailed information about mandatory reporting:
http://hr.uoregon.edu/policies-leaves/general-information/mandatory-reporting-child-abuse-and-neglect

## Reporting Title IX Experiences
Any student who has experienced sexual assault, relationship violence, sex or gender-based bullying, stalking, and/or sexual harassment may seek resources and help at safe.uoregon.edu. To get help by phone, a student can also call either the UO’s 24-hour hotline at 541-346-7244 [SAFE], or the non-confidential Title IX Coordinator at 541-346-8136. From the SAFE website, students may also connect to Callisto, a confidential, third-party reporting site that is not a part of the university. 

Students experiencing any other form of prohibited discrimination or harassment can find information at aaeo.uoregon.edu or contact the non-confidential AAEO office at 541-346-3123 or the Dean of Students Office at 541-346-3216 for help. As UO policy has different reporting requirements based on the nature of the reported harassment or discrimination, additional information about reporting requirements for discrimination or harassment unrelated to sexual assault, relationship violence, sex or gender based bullying, stalking, and/or sexual harassment is available at http://aaeo.uoregon.edu/content/discrimination-harassment 

Specific details about confidentiality of information and reporting obligations of employees can be found at https://titleix.uoregon.edu. 

## Academic Misconduct Policy
All students are subject to the regulations stipulated in the UO Student Conduct Code http://conduct.uoregon.edu). This code represents a compilation of important regulations, policies, and procedures pertaining to student life. It is intended to inform students of their rights and responsibilities during their association with this institution, and to provide general guidance for enforcing those regulations and policies essential to the educational and research missions of the University.  

## Conflict Resolution 
Several options, both informal and formal, are available to resolve conflicts for students who believe they have been subjected to or have witnessed bias, unfairness, or other improper treatment. 

It is important to exhaust the administrative remedies available to you including discussing the conflict with the specific individual, contacting the Department Head, or within the College of Education, you can contact the Associate Dean for Academic Affairs and Equity (Krista Chronister, 346-2415, kmg@uoregon.edu). Outside the College, you can contact: 

* UO Bias Response Team: 346-3216 http://bias.uoregon.edu/whatbrt.htm 
* Affirmative Action and Equal Opportunity: 346-3123 http://aaeo.uoregon.edu/

## Grievance Policy
A student or group of students of the College of Education may appeal decisions or actions pertaining to admissions, programs, evaluation of performance and program retention and completion. Students who decide to file a grievance should follow the student grievance procedure, or alternative ways to file a grievance outlined in the Student Grievance Policy (https://education.uoregon.edu/academics/student-grievance) or enter search: student grievance.

## In Case of Inclement Weather 
In the event the University operates on a curtailed schedule or closes, UO media relations will notify the Eugene-Springfield area radio and television stations as quickly as possible. In addition, a notice regarding the university’s schedule will be posted on the UO main home page (in the “News” section) at http://www.uoregon.edu. Additional information is available at http://hr.uoregon.edu/policy/weather.html.

If an individual class must be canceled due to inclement weather, illness, or other reason, a notice will be posted on Canvas or via email. During periods of inclement weather, please check Canvas and your email rather than contact department personnel. Due to unsafe travel conditions, departmental staff may be limited and unable to handle the volume of calls from you and others.

## Course Incomplete Policy
Students are expected to be familiar with university policy regarding grades of “incomplete” and the time line for completion. For details on the policy and procedures regarding incompletes, Please see: https://education.uoregon.edu/academics/incompletes-courses
