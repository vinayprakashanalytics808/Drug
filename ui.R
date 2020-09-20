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
library(sparkline)
library(plotly)
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
                                              }")
                # ,tags$style(
                #   "body {overflow-y: hidden;}"
                # )
                ),
                tabsetPanel(type = "tabs",
                            tabPanel("Species", 
                                     br(),
                                     fluidRow(
                                       column(id = "par", width = 2,
                                              selectInput("View","Species",choices = c("All", species_sql) ,width = 300),
                                              selectInput("View1","Gender",choices = c("All", gender_sql) ,width = 300,
                                                             selected = "All"),
                                              selectInput("View2","Cross Breed",choices = c("All",breed_sql) ,width = 300),
                                              fluidRow(
                                                column(width = 6, tags$h6(tags$a(HTML(paste("Min Age (Min) ", textOutput("min")))))),
                                                column(width = 6, tags$h6(tags$a(HTML(paste("Min Age (Max) ", textOutput("max"))))))
                                                ),
                                              fluidRow(
                                                column(width = 6, tags$h6(tags$a(HTML(paste("Max Age (Min) ", textOutput("min1")))))),
                                                column(width = 6, tags$h6(tags$a(HTML(paste("Max Age (Max) ", textOutput("max1"))))))
                                              ),
                                              br(),br(),
                                              htmlOutput("outcome")
                                       ),
                                       column(id = "rec", width = 10, 
                                              fluidRow(
                                                # column(width = 2,htmlOutput("species_records",width = "20px")),
                                                # column(width = 8,amChartsOutput("species_record_date",width = "1000px"),offset = 1)
                                                # column(width = 8,htmlOutput("species_record_date",width = "1000px"),offset = 1)
                                                column(width = 10,div(DT::dataTableOutput("species_record_date", width='1100px'), style = "font-size: 80%"))
                                                # column(width = 3,htmlOutput("species_breed"),offset = 3)
                                                
                                       )),
                                       column(id = "info", width = 10, 
                                              fluidRow(
                                                column(width = 3,amChartsOutput("species_info",width = "340px")),
                                                column(width = 3,amChartsOutput("breed_info",width = "340px"),offset = 1),
                                                column(width = 3,amChartsOutput("gender_info",width = "340px"),offset = 1)
                                              )),
                                       column(id = "breed", width = 10, 
                                              fluidRow(
                                                column(width = 10,div(DT::dataTableOutput("breed_record_date", width='1100px'), style = "font-size: 80%"))
                                              ))
                                       
                                     )),
                            tabPanel("Summary", 
                                     verbatimTextOutput("Tab2")),
                            tabPanel("Table", 
                                     tableOutput("Tab3"))
                )
  ))