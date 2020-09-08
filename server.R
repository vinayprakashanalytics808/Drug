library(shiny)
# library(shinydashboard)
# library(DT)
# library(readxl)
# library(dplyr)
# require(reshape2)
# library(rAmCharts)

# source("Data_wrangling.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  shinyjs::hide(selector = ".navbar > .sidebar-toggle")
  
  # df <- sqlFetch(myconn, "2019_123_main")
  df_select <- sqlQuery(myconn, "select top 10 [Unique] from [dbo].[all_data_2019]")
  
  output$summary <- renderPrint({
    df_select
  }) 
  
})