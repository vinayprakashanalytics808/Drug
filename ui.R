library(shiny)
library(shinydashboard)
library(DT)
library(readxl)
library(dplyr)
require(reshape2)
library(rAmCharts)
library(rlang)
library(shinyjs)
library(formattable)
library(kableExtra)
source("DBUtils.R")

ui <- dashboardPage(
  
  dashboardHeader(disable = TRUE),
  
  dashboardSidebar(disable = TRUE),
  
  
  dashboardBody(shinyjs::useShinyjs(),
                tags$head(tags$style(".shiny-output-error { visibility: hidden; }"),
                tags$style(".content-wrapper {
                                          background-color: white;
                                        }"),
                tags$style("body {
                                          font-family: Trebuchet MS;
                                        }"), 
                tags$style("#par {
                                          border-right: 2px solid grey;
                                          height:600px;
                                              }"),
                tags$style("#species_records td{
                                          line-height: 10px;
                                              }"),
                tags$style(
                  "body {overflow-y: hidden;}"
                )),
                tabsetPanel(type = "tabs",
                            tabPanel("Species", 
                                     br(),
                                     fluidRow(
                                       column(id = "par", width = 2,
                                              selectInput("View","Species",choices = c("All",species_sql) ,width = 300),
                                              selectInput("View1","Gender",choices = c("All", gender_sql) ,width = 300,
                                                             selected = "All"),
                                              selectInput("View2","Cross Breed",choices = c("All",breed_sql) ,width = 300)
                                       ),
                                       column(id = "rec", width = 10, 
                                              fluidRow(
                                                column(width = 2,htmlOutput("species_records",width = "200px")),
                                                column(width = 8,amChartsOutput("species_record_date",width = "500px"),offset = 1)
                                       ))
                                     )),
                            tabPanel("Summary", 
                                     verbatimTextOutput("summary")),
                            tabPanel("Table", 
                                     tableOutput("table"))
                )
  ))