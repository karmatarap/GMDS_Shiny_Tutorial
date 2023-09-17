# Load the required packages
library(shiny)
library(bslib)

# Define the User Interface
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "cerulean"),  # Using bslib for better styling
  navbarPage(title = "Shiny Workshop",
             tabPanel(title = "Welcome",
                      tags$h1("Welcome to the Shiny Workshop!"),
                      tags$hr(),
                      tags$p(tags$em("In this exercise, you have added File Input for Demographics."))
             ),
             tabPanel("Demographics",
                      fileInput('dmFile', 'Choose Demographics File', accept = c('.xpt'))  # File input for demographics
             )
  )
)

# Define the server logic
server <- function(input, output, session) {
  # TODO: We will add server logic in future exercises
}

# Run the application
shinyApp(ui = ui, server = server)
