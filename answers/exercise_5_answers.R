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
                      tags$p(tags$em("In this exercise, you have learned how to create dynamic UI elements."))
             ),
             tabPanel("Demographics",
                      fileInput('dmFile', 'Choose Demographics File', accept = c('.xpt')),
                      selectInput('group', 'Select Group', ""),
                      tableOutput('dmTable')
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
  
  # Generate the list of available groups dynamically
  observe({
    updateSelectInput(session, 'group', choices = names(dm_data()))
  })
  
  # Render the table for the first 6 rows of uploaded data
  output$dmTable <- renderTable({
    head(dm_data())
  })
}

# Run the application
shinyApp(ui = ui, server = server)
