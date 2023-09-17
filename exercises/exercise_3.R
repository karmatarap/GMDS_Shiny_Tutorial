# Load the required packages
library(shiny)
library(bslib)

# Define the User Interface
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "cerulean"),
  navbarPage(title = "Shiny Workshop",
             tabPanel(title = "Welcome",
                      tags$h1("Welcome to the Shiny Workshop!"),
                      tags$hr(),
                      tags$p(tags$em("In this exercise, you will add reactive data reading for Demographics."))
             ),
             tabPanel("Demographics",
                      fileInput('dmFile', 'Choose Demographics File', accept = c('.xpt'))
                      # TODO: Add a table output to display the first 6 rows of uploaded data
             )
  )
)

# Define the server logic
server <- function(input, output, session) {
  # TODO: Read the uploaded demographics data reactively
  # TODO: Render the table for the first 6 rows of uploaded data
}

# Run the application
shinyApp(ui = ui, server = server)
