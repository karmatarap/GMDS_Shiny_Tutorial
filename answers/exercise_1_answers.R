# Exercise 1: Understanding the Structure of a Shiny App with navbarPage

ui <- navbarPage(
  "Data Visualization App",
  # Create a tabPanel for the first plot
  tabPanel("First Plot", "Content for First Plot here"),
  
  # Create a tabPanel for the second plot
  tabPanel("Second Plot", "Content for Second Plot here")
)

server <- function(input, output, session) {
  # Server logic will be added later
}

shinyApp(ui, server)
