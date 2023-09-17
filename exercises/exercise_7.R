# Load the required packages
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(haven)
library(plotly)  # Load the Plotly library

# Define the User Interface
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "cerulean"),
  navbarPage(title = "Shiny Workshop",
             tabPanel(title = "Welcome",
                      tags$h1("Welcome to the Shiny Workshop!"),
                      tags$hr(),
                      tags$p(tags$em("In this exercise, you will make your ggplot2 plot interactive using Plotly."))
             ),
             tabPanel("Demographics",
                      fileInput('dmFile', 'Choose Demographics File', accept = c('.xpt')),
                      selectInput('dm_var', 'Choose Variable to Plot:', ''),  # Dropdown for variable selection
                      plotlyOutput('dm_plot')  # Output plot for demographics
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
  output$dm_plot <- renderPlotly({  # Use renderPlotly for interactive Plotly plot
    
    # Render the ggplot2 plot based on the selected variable
    
    # Step 1: Check if dm_data() and input$dm_var are available using req() function
    
    # Step 2: Determine the variable type (numeric or categorical) and create the appropriate ggplot2 plot.
    # - If it's numeric, create a histogram using geom_histogram().
    # - If it's categorical, create a bar plot using geom_bar().
    
    # Step 3: Customize the Plotly plot:
    # - Use plotly::ggplotly() to convert the ggplot2 plot to Plotly.
.
    
    return(plotly_p)  # Return the Plotly plot
  })
}

# Run the application
shinyApp(ui = ui, server = server)
