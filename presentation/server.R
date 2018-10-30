
library(shiny)
library(memisc)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  # Render video 
  output$video <- renderUI({
      HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/RauYoB0I9q4" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>')
    })
  
  # Raw data
  output$raw= renderUI(withMathJax(includeHTML("./html/raw.html")))
  
  output$raw_table = renderTable(raw_table)
  
  # Cleaning
  output$cleaning= renderUI(withMathJax(includeHTML("./html/cleaning.html")))
  output$init = renderTable(digits = 0, initial)
  output$clean = renderTable(digits = 0,clean)
  
  # Final df
  output$final = DT::renderDataTable(final,  options = list(scrollX=TRUE, scrollCollapse=TRUE,
                                                            autoWidth = FALSE,
                                                            columnDefs = list(list(width = '40px', targets = "_all")),
                                                            pageLength = 5,
                                                            lengthMenu = c(5, 10, 15, 20),
                                                            order = list(list(4, 'asc'), list(4, 'desc'))))
  
  # Word Clouds
  
  output$wordcloud = renderImage({
    # Selected performance
    perf = input$wordcloud
    
    file = paste0("./www/", perf)
    
    list(src = file,
         contentType = 'image/png',
         width = 800,
         height = 600,
         alt = "")
    
  }, deleteFile = FALSE)
  
  # Comments vs price
  
  output$comm = renderPlotly({
    ticker = input$ticker
    
    p = plotComment(ticker)
    
    p %>%
      layout(autosize = F, width = 1200, height = 600)
  })
  
  
  
  # Regressions
  output$log1 = renderPrint(summary(logit1))  
  output$log2 = renderPrint(summary(logit2))
  output$log3 = renderPrint(summary(logit3))  
  output$log4 = renderPrint(summary(logit4))
  
  #Specifications
  output$l1 = renderUI(withMathJax(includeHTML("./html/log1.html")))
  output$l2 = renderUI(withMathJax(includeHTML("./html/log2.html")))
  output$l3 = renderUI(withMathJax(includeHTML("./html/log3.html")))
  output$l4 = renderUI(withMathJax(includeHTML("./html/log4.html")))
  
})
