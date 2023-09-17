# Load the required packages
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(haven)

# Define the User Interface
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "cerulean"),
  navbarPage(title = "Shiny Workshop",
             tabPanel(title = "Welcome",
                      tags$h1("Welcome to the Shiny Workshop!"),
                      tags$hr(),
                      tags$p(tags$em("In this exercise, you will create a data visualization using ggplot2 based on the selected variable."))
             ),
             tabPanel("Demographics",
                      fileInput('dmFile', 'Choose Demographics File', accept = c('.xpt')),
                      selectInput('dm_var', 'Choose Variable to Plot:', ''),  # Dropdown for variable selection
                      plotOutput('dm_plot')  # Output plot for demographics
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
  
  # Create dynamic UI elements by populating the dropdown with the names of variables in the data
  observe({
    choices <- names(dm_data())
    updateSelectInput(session, "dm_var", choices = choices)
  })
  
  # Render the ggplot2 plot based on the selected variable
  output$dm_plot <- renderPlot({
    req(dm_data(), input$dm_var)
    var_type <- class(dm_data()[[input$dm_var]])
    if (var_type %in% c('integer', 'numeric')) {
      ggplot(dm_data(), aes_string(x = input$dm_var)) +
        geom_histogram(binwidth = 30) +
        labs(paste("Distribution of", input$dm_var)) +
        theme_minimal()
    } else {
      ggplot(dm_data(), aes_string(x = input$dm_var)) +
        geom_bar() +
        labs(paste("Frequency of", input$dm_var)) +
        theme_minimal()
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
