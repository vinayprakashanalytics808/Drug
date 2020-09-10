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
  # df_select <- sqlQuery(myconn, "select top 10 [Unique] from [dbo].[all_data_2019]")
  
  # renderAmCharts({  #   
  #   species_records_sql <- sqlQuery(myconn, "select * from dbo.fn_species_records ('') order by Records desc")
  #   species_records_sql  #   
  #   amBarplot(x = "Species", y = "Records", data = species_records_sql, horiz = TRUE)
  
  
  # }) 
    
    species_records_sql <- reactiveValues()

    
  
  
      output$species_records <-  renderText({
    # species_records_sql <- sqlQuery(myconn, "select * from dbo.fn_species_records ('') order by Records desc")
      species_records_sql <- sqlQuery(myconn, paste0("select Species, sum(Records) as Records from [dbo].[fn_species_records_onsetdate1] 
              ('",input$View,"','",input$View1,"','",input$View3,"') 
              group by Species order by Records desc"))
    
      # color.me <- which(species_records_sql$Species == input$View)
      species_records_sql %>% 
      kable(booktabs = T) %>%
      kable_styling() %>% 
      # row_spec(if(input$View == "All"){1:43} else {color.me} , bold = T, color = "white", background = "lightblue") %>%
      scroll_box(width = "250px", height = "350px")
      })
    
    #   output$species_record_date <-  renderAmCharts({
    #   species_records_date_sql <- sqlQuery(myconn, paste0("select datename(month, [Onset date]) as [Month], Species, sum(Records) as Records 
    #                                        from [dbo].[fn_species_records_onsetdate1] ('",input$View,"','",input$View1,"') 
    #                                        group by datename(month, [Onset date]), Species
    #                                        order by [Month]"))
    #   
    #   species_records_date_sql$Month <- as.character(species_records_date_sql$Month)
    #   colnames(species_records_date_sql)[colnames(species_records_date_sql) == 'Month'] <- 'label'
    #   colnames(species_records_date_sql)[colnames(species_records_date_sql) == 'Records'] <- 'value'
    #   
    #   # amBarplot(x = "Month", y = "Records", data = species_records_date_sql,
    #   #           labelRotation = -45)
    #   amPie(data = head(species_records_date_sql[c("label","value")],n = 12), inner_radius = 50, depth = 10, show_values = TRUE)
    #   # amBarplot(x = "Month", y = c("Records"), data = species_records_date_sql, stack_type = "regular")
    #   
    #   # amTimeSeries(species_records_date_sql, '`Onset Date`', c('Records'))
    # })
  
})