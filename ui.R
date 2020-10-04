library(plotly)
library(arules)
library(arulesViz)
library(lubridate)
library(mongolite)
library(shinyWidgets)
library(tidyverse)
library(plyr)
library(dplyr)


shinyUI(fluidPage(
  titlePanel("Market basket analysis"),
  fluidRow(
    column(width = 2,
           uiOutput("d1pick1")
    ),
    column(width = 2,
           uiOutput("d1pick2")
    ),
    column(width = 2,
           uiOutput("d1pick3")
    ),
    column(width = 2,
           uiOutput("d1pick4")
    ),
    column(width = 2,
           uiOutput("d1pick5")
    ),
    column(width = 2,
           uiOutput("d1pick6")
    )
    
  ),
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  
  
  fluidRow(
    column(6,
           dataTableOutput("apriori")),
    verbatimTextOutput("aprioritxt")
  ),
  
  fluidRow(
    column(6,
           h3("Image of Transactions"),
           plotOutput("image")
           ),
    column(6,
           h3("Item Frequency Plot"),
           plotOutput("item")
           )
  ),
  fluidRow(
    column(6,
           h3("grouped relation plot"),
           plotOutput("group")
           ),
    column(6,
           h3("Item plot"),
           plotOutput("listitem"))
  ),
  fluidRow(
    
    column(6,
           plotOutput("rulestrail")
           ),
    column(6,
           plotOutput("individualrules")
           )
  ),
  fluidRow(
    column(8,
           plotlyOutput("interactive")
           )
    
  )
  
  
  
  ))#fluid row Picker input
  