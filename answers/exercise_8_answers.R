# Load the required packages
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(plotly)

# Increase the size of the files that can be loaded
options(shiny.maxRequestSize = 35*1024^2)  # 30 MB


# Define the User Interface
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "cerulean"),  # Using bslib for better styling
  navbarPage(title = "Welcome to the GMDS RShiny Workshop by BMS!",
             tabPanel(title = "Welcome",
                      tags$h1("Welcome to the Shiny Workshop!"),
                      tags$hr(),
                      tags$p(tags$em("This workshop is designed to introduce you to building interactive web apps using Shiny.")),
                      tags$ul(
                        tags$li(tags$strong("Learn:"), " Data manipulation with dplyr"),
                        tags$li(tags$strong("Explore:"), " Data visualization with ggplot2"),
                        tags$li(tags$strong("Build:"), " Interactive web apps with Shiny")
                      ),
                      tags$hr(),
                      tags$footer(tags$i("We hope you enjoy this hands-on experience!"))
             ),
             tabPanel("Demographics",
                      fileInput('dmFile', 'Choose Demographics File', accept = c('.xpt')),  # File input for demographics
                      selectInput('dm_var', 'Choose Variable to Plot:', ''),  # Dropdown for variable selection
                      plotOutput('dm_plot')  # Output plot for demographics
             ),
             tabPanel("Labs",
                      fileInput('lbFile', 'Choose Labs File', accept = c('.xpt')),  # File input for labs
                      selectInput('lb_test', 'Choose Test to Plot:', ''),  # Dropdown for test selection
                      plotlyOutput('lb_plot')  # Output plot for labs
             )
  )
)


# Define the server logic
server <- function(input, output, session) {
  
  # Reactive value for demographics data
  dm_data <- reactiveVal()
  
  lb_data <- reactiveVal()
  
  
  # File validation and reading for demographics
  observeEvent(input$dmFile, {
    if (is.null(input$dmFile)) {
      return(NULL)
    }
    if (tools::file_path_sans_ext(basename(input$dmFile$name)) != "dm") {
      showModal(modalDialog(
        title = "Invalid file name",
        "Please upload a file named dm.xpt for demographics."
      ))
    } else {
      dm_data(haven::read_xpt(input$dmFile$datapath))
      # Update variable choices based on the uploaded dataset
      updateSelectInput(session, 'dm_var', choices = names(dm_data()))
    }
  })
  
  # File validation and reading for labs
  observeEvent(input$lbFile, {
    if (is.null(input$lbFile)) {
      return(NULL)
    }
    if (tools::file_path_sans_ext(basename(input$lbFile$name)) != "lb") {
      showModal(modalDialog(
        title = "Invalid file name",
        "Please upload a file named lb.xpt for labs."
      ))
    } else {
      lb_data(haven::read_xpt(input$lbFile$datapath))
      # Update test choices based on the uploaded dataset
      updateSelectInput(session, 'lb_test', choices = unique(lb_data()$LBTEST))
    }
  })
  
  # Plot for demographics
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
  
  output$lb_plot <- renderPlotly({
    req(lb_data())
    req(dm_data())
    req(input$lb_test)
    
    merged_data <- lb_data() %>%
      inner_join(dm_data(), by = c('STUDYID', 'USUBJID'))  # Perform inner join on STUDYID and USUBJID
    
    # Use the lb_data reactive value and filter based on selected LBTEST
    selected_data <- merged_data %>%
      filter(LBTEST == input$lb_test) %>%
      filter(startsWith(VISIT,"SCREENING") | startsWith(VISIT,"WEEK") ) %>%
      arrange(VISITNUM) %>%
      mutate(VISIT = factor(VISIT, levels = unique(VISIT), ordered = TRUE))
    
    # Summary statistics
    summary_data <- selected_data %>%
      group_by(VISIT, ACTARM) %>%
      summarise(
        Mean = mean(LBSTRESN, na.rm = TRUE),
        SE = sd(LBSTRESN, na.rm = TRUE) / sqrt(n()),
        .groups = 'drop'
      )
    
    # Generate ggplot
    p <- ggplot(summary_data, aes(x = VISIT, y = Mean)) +
      geom_point(aes(color = ACTARM, shape = ACTARM), size = 3,  position=position_dodge(width=0.2)) +
      geom_errorbar(aes(ymin = Mean - SE, ymax = Mean + SE, color = ACTARM), width = 0.2,  position=position_dodge(width=0.2)) +
      geom_line(aes(group = ACTARM, color = ACTARM)) +
      labs(
        title = 'Mean and SE of Selected Test by Visit',
        x = 'Visit Label',
        y = 'Test Result'
      ) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.title = element_text(face = 'bold'),
        legend.position = 'bottom'
      ) +
      scale_color_brewer(name = 'Treatment Group', palette = 'Set1') +
      scale_shape_manual(name = 'Treatment Group', values = c(16, 17, 18, 19, 20)) 
    ggplotly(p)
  })
  
  
}

# Run the application
shinyApp(ui = ui, server = server)
