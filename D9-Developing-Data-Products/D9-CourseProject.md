Coursera-JHU-Developing Data Products-CourseProject
========================================================
author: Spark-Lin
date:  3 Dec 2016
autosize: true

Word Cloud Generator
========================================================

This presentation is created as part of the Course Project for the Developing Data Products course. It is used for the peer assessment. Which contains 2 parts:

- Use **Shiny** to build an data App using real-time or historical data
- Use **R-Presentation or Slidify** to create a supportive file to explain the general idea about the creation of Shiny App.


About the Shiny Word Cloud App
========================================================
- The goal of this assignment is to demonstrate the understanding of Shiny and use it to create a simple data product interactive application, this shiny App is called Spark-Lin Word Cloud, it's deployed on: https://spark-lin.shinyapps.io/DevDataProduct-FinalProject/

The small simple App allows user to:

- Select the inputs, such like Minimum Word Frequency, Maximum Number of Word Selected of book you are reading.
-  Change amongs three books seleted to generate the Word Cloud

Data for this App
========================================================
Books use for generate Word Could are from [Gutenberg](https://www.gutenberg.org/).

  - [Pride and Prejudice, by Jane Austen](https://www.gutenberg.org/files/1342/1342-0.txt)
  
  - [A Tale of Two Cities, by Charles Dickens](https://www.gutenberg.org/files/98/98-0.txt)
  
  - [The Adventures of Sherlock Holmes, by Arthur Conan Doyle](http://www.gutenberg.org/cache/epub/1661/pg1661.txt)
  
Source code and download books txt-format files are available on [Github](https://github.com/spark-lin/Data-Science-Coursera/tree/master/D9-Developing-Data-Products).

 R Code (Extract) used in this App 
========================================================


```r
library(wordcloud)
library(memoise)
library(tm)

# The list of selected books
# Books need to be downloaded and saveed in the same folder of ui.R and server.R 
books <<- list("Pride and Prejudice" = "Pride",
               "A Tale of Two Cities" = "Tale",
               "The Adventures of Sherlock Holmes" = "Adventures" )...
```


