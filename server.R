library(shiny)
library(tidyverse)

function(input, output, session) {
  
  dataUpload <- reactive({
    
    inFile <- input$file1
    print(inFile)
    
    if(is.null(inFile))
      return(NULL)
    
    dt_frame = read.csv(inFile$datapath, header=input$header, sep=input$sep)
    
    updateSelectInput(session, "column", choices = names(dt_frame))
    updateSelectInput(session, "column2", choices = names(dt_frame))
    updateSelectInput(session, "facet_x", choices = c(".", names(dt_frame)), selected = ".")
    updateSelectInput(session, "facet2", choices = c(".", names(dt_frame)), selected = ".")
    
    return(dt_frame)
  })
  
  ranges <- reactiveValues(x = NULL, y = NULL)
  
  output$plot <- renderPlot({
    
    if(is.null(input$file1))
      return(NULL)
    
    dataset <- dataUpload()
    
    if (input$plot == "Histogram") {
      
      p <- ggplot(dataset, aes_string(x = input$column)) +
        geom_histogram(bins = 30) +
        coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
    }
    
    if (input$plot == "Point") {
      
      p <- ggplot(dataset,aes_string(x = input$column, y = input$column2)) +
        geom_point() +
        coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
    }
    
    if (input$plot == "Bar") {
      
      p <- ggplot(dataset, aes_string(x = input$column)) +
        geom_bar() +
        coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE) 
    }
    
    if (input$plot == "BoxPlot") {
      
      p <- ggplot(dataset,aes_string(x = input$column, y = input$column2)) +
        geom_boxplot() +
        coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
    }
    
    if (input$plot == "Density") {
      p <- ggplot(dataset, aes_string(x = input$column)) +
        geom_density() +
        coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
    }
    
    if (input$plot == "Violin") {
      p <- ggplot(dataset, aes_string(x = input$column, y = input$column2)) +
        geom_violin() +
        coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
    }
    
    if (input$plot == "Piechart") {
      p <- ggplot(dataset, aes(x=input$column, y=input$column2)) +
        geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0)
    }
    
    if (input$facet_x != '.')
      p <- p + facet_wrap(input$facet_x)
    
    if (input$facet2 != '.')
      p <- p + aes_string(color = input$facet2)
    
    if (input$fill_plot)
      p <- p + aes_string(fill = input$facet2)
    
    if ("Point" %in% input$addplot)
      p <- p + geom_point()
    
    if ("Smooth" %in% input$addplot)
      p <- p + geom_smooth()
    
    if ("Dotplot" %in% input$addplot) 
      p <- p + geom_dotplot()
    
    if ("Point" %in% input$addplot & "Smooth" %in% input$addplot)
      p <- p + geom_point() + geom_smooth()
    
    switch (input$theme,
            "Siyah Beyaz" = {p <- p + theme_bw()},
            "Minimal" = {p <- p + theme_minimal()},
            "Sade" = {p <- p + theme_light()},
            "Karanlık" = {p <- p + theme_dark()},
            "Klasik" = {p <- p + theme_classic()},
            "Boşluk" = {p <- p + theme_void()},
            {"Gri"}
    )
    
    switch (input$size,
            "1" = {p <- p + aes_string(size = 1)},
            "2" = {p <- p + aes_string(size = 2)},
            "3" = {p <- p + aes_string(size = 3)},
            "4" = {p <- p + aes_string(size = 4)},
            {"0"}
    )
    
    if (input$flipcoord)
      p <- p + coord_flip()
    
    p
    
  }, height=reactive(ifelse(!is.null(input$innerWidth),input$innerWidth*3/8,0)))
  
  output$zoom_info <- renderText({ 
    "Yakınlaştırmak için alan içine, uzaklaştırmak için alan dışına çift tıklayın."
  })
  
  observeEvent(input$plot_dblclick, {
    brush <- input$plot_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
}
