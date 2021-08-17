#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(connectapi)
library(shiny)

client <- connect()

ui <- fluidPage(
    textInput("contentId", "Enter Content ID"),
    verbatimTextOutput("branch"),
    verbatimTextOutput("commit")
    
)

server <- function(input, output, session) {
    observe({
        content <- input$contentId
        branch <- NA
        commit <- NA
        tryCatch(
            {
                bundle_meta <- client %>% content_item(content) %>% get_bundles() %>% .$metadata
                branch <- bundle_meta[[1]]$source_branch
                commit <- bundle_meta[[1]]$source_commit
            },
            error = function(cond){
                branch <- "content not found"
                commit <- "content not found"
            },
            finally = {
                #pass
            })
        
        output$branch <- renderText({ branch })
        output$commit <- renderText({ commit })
    })
}

shinyApp(ui, server)