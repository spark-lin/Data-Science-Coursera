#library(tm.plugin.europresse)
library(wordcloud)
library(memoise)
library(tm)
library(Rcpp)
library(NLP)
library(RColorBrewer)
library(shiny)
library(shinyapps)

# I was unable to installed "slam" package for "NLP" and other pacakages
# R studio keep displying the Error, package is not found for RStuido 3.30

# The list of selected books
# Books need to be downloaded and saveed in the same folder of ui.R and server.R 
books <<- list("Pride and Prejudice" = "Pride",
               "A Tale of Two Cities" = "Tale",
               "The Adventures of Sherlock Holmes" = "Adventures" )

# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(book) {

  if (!(book %in% books))
    stop("Unknown book")
  
# Downlaod the books in txt format. I tied to use pdf files, but the size of ebook are too big.
# If not, you would be reading 1-Fifty Shades of Grey, 2-A Game of Thrones, 3-Harry Potter And the Goblet of Fire and 4-Harry Potter And the Goblet of Fire now. :P
  text <- readLines(sprintf("./%s.txt", book), encoding="UTF-8")  
  # 'txt'change according to file's format
  
  # Use tm for text mining to retrieve words and map then together
  tm_Corpus = Corpus(VectorSource(text))
  tm_Corpus = tm_map(tm_Corpus, content_transformer(tolower))
  tm_Corpus = tm_map(tm_Corpus, removePunctuation)
  tm_Corpus = tm_map(tm_Corpus, removeNumbers)
  tm_Corpus = tm_map(tm_Corpus, removeWords,
                    c(stopwords("SMART"), "to", "why", "of", "the", "and", "but"))
  
  TD_Matrix = TermDocumentMatrix(tm_Corpus,
                             control = list(minWordLength = 1))
  
  tm_Matrix = as.matrix(TD_Matrix)
  
  sort(rowSums(tm_Matrix), decreasing = TRUE)
  
})
