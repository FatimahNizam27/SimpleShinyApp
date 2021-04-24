#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for dataset viewer app ----
ui <- fluidPage(

    
    # App title ----
    titlePanel("17218825"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Select a dataset ----
            selectInput("dataset", "Choose a dataset:",
                        choices = c("AirPassengers", "WorldPhones", "Seatbelts")),
            
            # Input: Specify the number of observations to view ----
            numericInput("obs", "Number of observations to view:", 10),
            
            # Include clarifying text ----
            helpText("the summary will still be based",
                     "on the full dataset."),
            
            # Input: actionButton() to defer the rendering of output ----
            # until the user explicitly clicks the button (rather than
            # doing it immediately when inputs change). This is useful if
            # the computations required to render output are inordinately
            # time-consuming.
            actionButton("update", "Update View")
            
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            
            # Output: Header + summary of distribution ----
            h4("Summary"),
            verbatimTextOutput("summary"),
            
            # Output: Header + table of distribution ----
            h4("Observations"),
            tableOutput("view")
        )
        
    )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
    
    # Return the requested dataset ----
    # Note that we use eventReactive() here, which depends on
    # input$update (the action button), so that the output is only
    # updated when the user clicks the button
    datasetInput <- eventReactive(input$update, {
        switch(input$dataset,
               "AirPassengers" = AirPassengers,
               "WorldPhones" = WorldPhones,
               "Seatbelts" = Seatbelts)
    }, ignoreNULL = FALSE)
    
    # Generate a summary of the dataset ----
    output$summary <- renderPrint({
        dataset <- datasetInput()
        summary(dataset)
    })
    
    # Show the first "n" observations ----
    # The use of isolate() is necessary because we don't want the table
    # to update whenever input$obs changes (only when the user clicks
    # the action button)
    output$view <- renderTable({
        head(datasetInput(), n = isolate(input$obs))
    })
    
}

# Create Shiny app ----
shinyApp(ui, server)

