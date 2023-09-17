# Load the required packages
library(shiny)
library(bslib)
library(dplyr)
library(haven)

# Define the User Interface
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "cerulean"),
  navbarPage(title = "Shiny Workshop",
             tabPanel(title = "Welcome",
                      tags$h1("Welcome to the Shiny Workshop!"),
                      tags$hr(),
                      tags$p(tags$em("In this exercise, you have learned how to manipulate the Demographics data."))
             ),
             tabPanel("Demographics",
                      fileInput('dmFile', 'Choose Demographics File', accept = c('.xpt')),
                      tableOutput('dmTable')  # Table output for the first 6 rows
             )
  )
)

# Define the server logic
server <- function(input, output, session) {
  # Read the uploaded demographics data reactively
  dm_data <- reactive({
    req(input$dmFile)
    read_xpt(input$dmFile$datapath)
  })
  
  # Manipulate the data to get the mean age of each group
  mean_age_data <- reactive({
    dm_data() %>%
      group_by(ACTARM) %>%
      summarise(mean_age = mean(AGE))
  })
  
  # Render the table for the first 6 rows of manipulated data
  output$dmTable <- renderTable({
    head(mean_age_data())
  })
}

# Run the application
shinyApp(ui = ui, server = server)
