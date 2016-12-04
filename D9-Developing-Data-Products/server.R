# Books selected on https://www.gutenberg.org/
# Books can be read and download from the above link
# Pride and Prejudice, by Jane Austen
# https://www.gutenberg.org/files/1342/1342-0.txt
# A Tale of Two Cities, by Charles Dickens
# https://www.gutenberg.org/files/98/98-0.txt

# The Adventures of Sherlock Holmes, by Arthur Conan Doyle
# http://www.gutenberg.org/cache/epub/1661/pg1661.txt

library(shiny)

shinyServer(function(input, output, session) {
  # Define a reactive expression for the document term matrix
  terms <- reactive({
    # Change book among selected books when click the "update" button.
    input$update
    
    isolate({
      withProgress({
        setProgress(message = "Retrieving corpus...Please be patient")
        getTermMatrix(input$selection)
      })
    })
  })
  
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    tm_value <- terms()
    wordcloud_rep(names(tm_value), tm_value, scale=c(4,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
    # Among the ColorBrewer palette(Accent,Dark2, Paired, Pastel etc), personally, I prefer Dark2.
  })
}
)