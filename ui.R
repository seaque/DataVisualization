library(shiny)
library(tidyverse)

dataset <- reactive({
  dataset <- dataUpload()
})

fluidPage(
  
  titlePanel("Veri G�rselle�tirme"),
  
  fluidRow(
    
    column(2,
           
           fileInput('file1', 
                     'CSV dosyası seçiniz.',
                     accept=c('text/csv')),
           
           checkboxInput('header',
                         'İlk Satır Sütun Adları',
                         TRUE),
           
           radioButtons('sep',
                        'Ayırıcı',
                        c("Virgül"=',',
                          "Tab"='\t', 
                          "Noktalı Virgül"=';')),
           
           tags$hr(),
           
           selectInput("theme",  
                       "Tema: ",
                       c("Gri", "Siyah Beyaz", "Minimal",
                         "Sade", "Karanlık", "Klasik", "Boşluk"))
    ),
    
    column(2,
           
           selectInput("column", 
                       "X: ",""),
           
           selectInput("column2", 
                       "Y: ",""),
           
           checkboxInput("flipcoord", "Koordinatları Çevir", value = FALSE),
           
           selectInput("plot",  
                       "Grafik: ",
                       c("Point", "Histogram", "Bar",
                         "BoxPlot", "Density", "Violin")),
           
           uiOutput("slider"),
           
           selectInput("facet_x",  
                       "Grupla: ",
                       ""),
     
           selectInput("facet2",  "Renklendir: ", ""),
           
           checkboxInput("fill_plot", "Doldur", value = FALSE),
           
           numericInput("size", "Boyut", value = 0, min = 0, max = 4),
           
           checkboxGroupInput(
             "addplot",
             
             "Grafik Ekle",
             choices = c("Point", "Smooth", "Dotplot"),
             selected = NULL,
             width = '100%',
             inline = TRUE)
    ),
    
    column(8, textOutput("zoom_info"), 
          
           tags$head(tags$script('$(document).on("shiny:connected", function(e) {
                            Shiny.onInputChange("innerWidth", window.innerWidth);
                            });
                            $(window).resize(function(e) {
                            Shiny.onInputChange("innerWidth", window.innerWidth);
                            });
                            ')),
           plotOutput("plot",
                         dblclick = "plot_dblclick",
                         brush = brushOpts(
                           id = "plot_brush",
                           resetOnNew = TRUE)),
    )
  )
)
