library(shiny)
library(shinydashboard)
library(DT)
library(readxl)
library(dplyr)
require(reshape2)
library(rAmCharts)
library(rlang)
library(shinyjs)
source("DBUtils.R")

ui <- dashboardPage(
  
  dashboardHeader(disable = TRUE),
  
  dashboardSidebar(disable = TRUE),
  
  
  dashboardBody(shinyjs::useShinyjs(),
                tags$head(tags$style(".shiny-output-error { visibility: hidden; }")
                # tags$style(".sidebar{background-color: #dec4de;}")
                ),
                tabsetPanel(type = "tabs",
                            tabPanel("Species", 
                                     plotOutput("plot")),
                            tabPanel("Summary", 
                                     verbatimTextOutput("summary")),
                            tabPanel("Table", 
                                     tableOutput("table"))
                )
  ))