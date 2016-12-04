
shinyUI(fluidPage(theme = "bootstrap.css", 
                  
  navbarPage("Spark-Lin Word Cloud", 
    tabPanel("Plot",
              sidebarPanel(selectInput("selection", "Pick up a book:",
                           choices = books, icon("arrows-v"), selectize = TRUE),
              actionButton("update", "Read another book", icon("book"), 
                           style = "color: #fff; font-color: #2e6da4;  background-color: #337ab7;border-color: #2e6da4"),
              hr(),
              sliderInput("freq", "Minimum word Frequency:", min = 10,  max = 200, value = 60),
              sliderInput("max", "Maximum Words slected:", min = 1,  max = 300,  value = 250)),
                                                
    mainPanel(tabsetPanel(
        tabPanel("Color Word Cloud", plotOutput("plot")),
        helpText('If may take a moment to retrieve the text and create the Word Cloud, Please be patient!')
        #tabPanel("About", mainPanel(includeMarkdown("ReadMe.md")))
  ))
  ),
  tabPanel("About", mainPanel(includeMarkdown("ReadMe.md")))     
  )
)
)