library(shiny)
library(shinythemes)
library(mgcv)

ui = fluidPage(
  theme = shinytheme("cosmo"),
  title = "Generalized Additive Mixed Model",
  tags$h3("Generalized Additive Mixed Model"),
  fluidRow(
    column(2,
      tags$small('1. Open a CSV file first:'),
      fileInput(
        "file1",
        "Choose CSV file",
        multiple = FALSE,
        accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
      )
    ),
    column(3,
      tags$small('2. Write GAMM formula as y ~ s(x1) + x2...:'),
      textInput("formula", "Formula", "")
    ),
    column(3,
      tags$small('3. Select a correlation structure:'),
      selectInput("correlation", "Correlation", multiple = FALSE, choices = c(
        "None" = "none",
        "AR1" = "corAR1"
      #  "ARMA" = "corARMA",
      #  "CAR1" = "corCAR1",
      #  "Exponential spatial" = "corExp",
      #  "Gaussian spatial" = "corGaus",
      #  "Linear spatial" = "corLin"
      ))
    ),
    column(3,
      tags$small('4. Select random effects (groups):'),
      uiOutput("reSelector")
    ),
    column(1,
      actionButton("run", "▸ Run", style = "margin-top: 35px; background-color: #69cd56; border: none;")
    ),
    style = "background-color: #EEE; margin-top: 20px; margin-bottom: 20px; padding-top: 20px; padding-bottom: 20px;"
  ),
  tableOutput("contents"),
  plotOutput("plots"),
  textOutput("infoLME", container = pre),
  textOutput("infoGAM", container = pre)
)

server = function(input, output) {
  getModel = eventReactive(
    input$run,
    {
      inFile <- input$file1
      if (is.null(inFile)) return(NULL)
      df = read.csv(inFile$datapath)
      print(input$random)
      random = list()
      for (re in input$random) {
        random[[re]] <- as.formula('~1')
      }
      print(random)

      correlation = input$correlation
      if (correlation == 'none') {
        correlation = NULL
      } else {
        correlation = do.call(correlation, list())
      }
      if (length(random) == 0) random = NULL

      return(mgcv::gamm(
        as.formula(input$formula),
        random = random,
        correlation = correlation,
        data = df
      ))
    }
  )
  output$contents = renderTable({
    inFile <- input$file1
    if (is.null(inFile)) return(NULL)
    df = read.csv(inFile$datapath)
    return(head(df))
  })
  output$infoLME = renderText({
    model = getModel()
    return(
      paste(capture.output(summary(model$lme)), collapse = '\n')
    )
  })
  output$infoGAM = renderText({
    model = getModel()
    return(
      paste(capture.output(summary(model$gam)), collapse = '\n')
    )
  })
  output$plots = renderPlot({
    model = getModel()
    return(plot(model$gam, pages = 1))
  })
  output$reSelector = renderUI({
    inFile <- input$file1
    if (is.null(inFile)) return(NULL)
    df = read.csv(inFile$datapath)
    selectInput("random", "Random Effects", multiple = TRUE, choices = as.character(colnames(df)))
  })
}

shinyApp(ui, server)
