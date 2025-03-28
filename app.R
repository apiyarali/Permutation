#Permutation
library(shiny)
library(shinydashboard)
library(shinyWidgets)
source("jaxmat.R")

header <- dashboardHeader(title = "Permutations")
sidebar <- dashboardSidebar(disable = TRUE)
body <- dashboardBody(
  fluidRow(
    column(
      width = 4,
      box(
          width = NULL, height = 220,
          h3("Input"),
          textInput("atext","a","(12)"),
          textInput("btext","b","(13)")
      ),
      box(
          width = NULL, height = 150,
          h3("Products"),
          h4(uiOutput("prodab")),
          h4(uiOutput("prodba"))
      ),
      box(
          width = NULL, height = 150,
          h3("Inverses"),
          h4(uiOutput("inva")),
          h4(uiOutput("invb"))
      ),
      box(
          width = NULL, height = 150,
          h3("Conjugates"),
          h4(uiOutput("conja")),
          h4(uiOutput("conjb"))
      ),

    ),
    column(
        width = 4,
        box(
            width = NULL, height = 350,
            h3("Powers of a"),
            uiOutput("powersa"),
            tags$head(tags$style("#powersa{color:red; font-size:20px;
            font-style:italic;
            overflow-y:scroll; max-height:250px;}"))
        ),
        
        box(
          width = NULL, height = 350,
          h3("Powers of ab"),
          uiOutput("powersab"),
          tags$head(tags$style("#powersab{color:red; font-size:20px;
            font-style:italic;
            overflow-y:scroll; max-height:250px;}"))
        ),


    ),
    column(
      width = 4,
      box(
        width = NULL, height = 350,
        h3("Powers of b"),
        uiOutput("powersb"),
        tags$head(tags$style("#powersb{color:red; font-size:20px;
            font-style:italic;
            overflow-y:scroll; max-height:250px;}"))
      ),
      
      box(
        width = NULL, height = 350,
        h3("Powers of ba"),
        uiOutput("powersba"),
        tags$head(tags$style("#powersba{color:red; font-size:20px;
            font-style:italic;
            overflow-y:scroll; max-height:250px;}"))
      ),  
      
        actionBttn("btncalc","Calculate",
            color = "primary", size = "lg") #an awesome button from shinyWidgets
    )
  )    
)

ui <- dashboardPage(header, sidebar, body)


source("permutecalc.R")    


server <- function(input, output) {
  output$prodab <- renderUI("ab = (132)")
  output$prodba <- renderUI("ba = (123)")
  output$powersa <- renderUI(HTML(paste("(12)","I",sep = "<br/>")))
  observeEvent(input$btncalc, {
    ab <- Perm.multiply(input$atext,input$btext)
    output$prodab <- renderUI(paste("ab =  ",ab))
    
    ba <- Perm.multiply(input$btext,input$atext)
    output$prodba <- renderUI(paste("ba =  ",ba))
    
    pa <- Perm.powerString(input$atext)
    output$powersa <- renderUI(HTML(pa))
    
    pb <- Perm.powerString(input$btext)
    output$powersb <- renderUI(HTML(pb))
    
    pab <- Perm.powerString(ab)
    output$powersab <- renderUI(HTML(pab))
    
    pba <- Perm.powerString(ba)
    output$powersba <- renderUI(HTML(pba))
    
    pinva <- Perm.inverse(input$atext)
    output$inva <- renderUI({
      withMathJax(paste0("$$a^{-1} = ", pinva,"$$"))
    })
    
    pinvb <- Perm.inverse(input$btext)
    output$invb <- renderUI({
      withMathJax(paste0("$$b^{-1} = ", pinvb,"$$"))
    })
    
    pconja <- Perm.conjugate(input$atext, input$btext)
    output$conja <- renderUI({
      withMathJax(paste0("$$aba^{-1} = ", pconja,"$$"))
    })
    
    pconjb <- Perm.conjugate(input$btext, input$atext)
    output$conjb <- renderUI({
      withMathJax(paste0("$$bab^{-1} = ", pconjb,"$$"))
    })
    
  })

}

# Run the application 
shinyApp(ui = ui, server = server)
