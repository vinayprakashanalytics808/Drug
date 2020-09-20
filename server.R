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
    
      
  # execute update_summary_table
    
      output$outcome <-  renderText({
      outcome_sql <- sqlQuery(myconn, paste0("select Outcome, sum(Records) as Records
      from [dbo].[fn_species_records_onsetdate2]('",input$View,"','",input$View1,"','",input$View2,"')
                                                     group by Outcome 
                                                     order by Records desc"))
    
      # color.me <- which(species_records_sql$Species == input$View)
      outcome_sql %>% 
      kable(booktabs = T) %>%
      kable_styling(font_size = 11) %>%
      row_spec(1:nrow(outcome_sql), bold = T, color = "white", background = "#6495ED")
      # row_spec(if(input$View == "All"){1:43} else {color.me} , bold = T, color = "white", background = "lightblue") %>%
      # scroll_box(width = "200px", height = "278px")
      })
    
    #   output$species_record_date <-  renderAmCharts({
    #   species_records_date_sql <- sqlQuery(myconn, paste0("select datename(month, [Onset date])+ ' ' + '(' + Species + ')'  as [Month], Species, sum(Records) as Records 
    #                                                       from [dbo].[fn_species_records_onsetdate2] ('",input$View,"','",input$View1,"','",input$View2,"') 
    #                                                       group by datename(month, [Onset date]), Species
    #                                                       order by [Month]"))
    # 
    #   species_records_date_sql$Month <- as.character(species_records_date_sql$Month)
    #   colnames(species_records_date_sql)[colnames(species_records_date_sql) == 'Month'] <- 'label'
    #   colnames(species_records_date_sql)[colnames(species_records_date_sql) == 'Records'] <- 'value'
    #  
    #   # amBarplot(x = "Month", y = "Records", data = species_records_date_sql,
    #   #           labelRotation = -45)
    #   amPie(data = head(species_records_date_sql[c("label","value")],n = 12), inner_radius = 50, depth = 10,  show_values = TRUE
    #         # ,main = "Records by Month"
    #         )
    #   # amBarplot(x = "Month", y = c("Records"), data = species_records_date_sql, stack_type = "regular")
    # 
    #   # amTimeSeries(species_records_date_sql, '`Onset Date`', c('Records'))
    # })
      
      
      output$species_breed <-  renderText({
        species_breed_sql <- sqlQuery(myconn, paste0("select Breed_Name, sum(Records) as Records from [dbo].[fn_species_records_onsetdate2] 
              ('",input$View,"','",input$View1,"','",input$View2,"')
                                                     group by Species, Breed_Name			 
                                                     order by Records desc"))
        
        
          species_breed_sql %>% 
          kable(booktabs = T) %>%
          kable_styling(font_size = 11) %>% 
          scroll_box(width = "250px", height = "350px")
      })
      
      
      
        output$species_record_date <-  renderDataTable({
        species_records_date_sql <- sqlQuery(myconn, paste0("select * from (select datename(month, [Onset date])  as [Month], Species, sum(Records) as Records 
                                                                      from [dbo].[fn_species_records_onsetdate2] ('",input$View,"','",input$View1,"','",input$View2,"') 
                                                                      group by datename(month, [Onset date]), Species) t 
                                                                      pivot(sum(Records) for [Month] in ([January],[February],[March],[April],[May],[June],
                                                                      [July],[August],[September],[October],[November],[December]))
                                                                      as pt"))
        
        species_records_date_sql$Total <- rowSums(species_records_date_sql[,2:13])
        # species_records_date_sql$trend <- spk_chr(species_records_date_sql[2:13], type ="line",
        #   chartRangeMin = species_records_date_sql[2], chartRangeMax = species_records_date_sql[13]
        # )
        
        datatable(species_records_date_sql, escape = FALSE, rownames = FALSE, class = "compact nowrap hover row-border",
                  options = list(dom = 'ft', searching = FALSE
#                                  ,fnDrawCallback = htmlwidgets::JS(
#                     '
# function(){
#   HTMLWidgets.staticRender();
# }
# '
#                   )
                  ,columnDefs = list(list(className = 'dt-center', targets = "_all"))
                  )) 
        # %>%
        #   spk_add_deps()
        
          # species_records_date_sql  %>% 
          # kable(booktabs = T) %>%
          # kable_styling(font_size = 11) %>% 
          # scroll_box(width = "800px", height = "350px")
      })
        
          output$species_info <-  renderAmCharts({
          species_info_sql <- sqlQuery(myconn, paste0("select Species, sum(Records) as Records from [dbo].[fn_species_records_onsetdate2]
          ('",input$View,"','",input$View1,"','",input$View2,"')
	        group by Species order by Records desc"))

          species_info_sql$Species <- as.character(species_info_sql$Species)
          colnames(species_info_sql)[colnames(species_info_sql) == 'Species'] <- 'label'
          colnames(species_info_sql)[colnames(species_info_sql) == 'Records'] <- 'value'

          amPie(data = species_info_sql, inner_radius = 20, depth = 10,  show_values = FALSE)
        })
          
            output$breed_info <-  renderAmCharts({
            breed_info_sql <- sqlQuery(myconn, paste0("select breed, sum(Records) as Records from [dbo].[fn_species_records_onsetdate2]
                                                        ('",input$View,"','",input$View1,"','",input$View2,"')
                                                        group by breed order by Records desc"))
            
            breed_info_sql$breed <- as.character(breed_info_sql$breed)
            colnames(breed_info_sql)[colnames(breed_info_sql) == 'breed'] <- 'label'
            colnames(breed_info_sql)[colnames(breed_info_sql) == 'Records'] <- 'value'
            
            amPie(data = breed_info_sql, inner_radius = 20, depth = 10,  show_values = FALSE)
          })
            
            
            output$gender_info <-  renderAmCharts({
              gender_info_sql <- sqlQuery(myconn, paste0("select gender, sum(Records) as Records from [dbo].[fn_species_records_onsetdate2]
                                                        ('",input$View,"','",input$View1,"','",input$View2,"')
                                                        group by gender order by Records desc"))
              
              gender_info_sql$gender <- as.character(gender_info_sql$gender)
              colnames(gender_info_sql)[colnames(gender_info_sql) == 'gender'] <- 'label'
              colnames(gender_info_sql)[colnames(gender_info_sql) == 'Records'] <- 'value'
              
              amPie(data = gender_info_sql, inner_radius = 20, depth = 10,  show_values = FALSE)
            })
            
            
            
            output$breed_record_date <-  renderDataTable({
              breed_record_date_sql <- sqlQuery(myconn, paste0(" select * from(
                                      	 select Breed_Name, datename(month, [Onset date]) as [Month], 
                                         sum(Records) as Records from [dbo].[fn_species_records_onsetdate2]('",input$View,"','",input$View1,"','",input$View2,"')
                                      	 group by Breed_Name, datename(month, [Onset date])) t
                                      	 pivot(sum(Records) for [Month] in ([January],[February],[March],[April],[May],[June],[July],[August],[September],[October],[November],[December]))
                                      	 as pt"))
              # breed_record_date_sql$Total <- rowSums(breed_record_date_sql[,2:13]) 
              if(input$View != "All"){
                datatable(breed_record_date_sql, escape = FALSE, rownames = FALSE, extensions = c('FixedColumns',"FixedHeader"),
                          class = "compact nowrap hover row-border",
                          options = list(fixedHeader=TRUE,autowitdth=FALSE, dom = 'ft', searching = FALSE, pageLength = 1000, scrollY = "200px",
                                         columnDefs = list(list(className = 'dt-center', targets = "_all")))) 
              }
              else {
                NULL
              }
          
              
})
            
            output$min <- renderText({
              min_sql <- sqlQuery(myconn, paste0("select min([Min]) as min_age from [dbo].[fn_min_age]('",input$View,"','",input$View1,"','",input$View2,"')"))
              
              paste(min_sql) 
            })
            
            
            output$max <- renderText({
              max_sql <- sqlQuery(myconn, paste0("select max([Max]) as max_age from [dbo].[fn_min_age]('",input$View,"','",input$View1,"','",input$View2,"')"))
              
              paste(max_sql) 
            })
  
})