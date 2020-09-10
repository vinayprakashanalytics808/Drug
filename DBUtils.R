library(RODBC)
myconn <- odbcDriverConnect(connection = "Driver={SQL Server Native client 11.0};
                            server=localhost;database=NewDatabase;trusted_connection=yes;")

##172.17.34.17




species_sql <- sqlQuery(myconn, "select species from dbo.fn_species_records ('') order by Records desc")

gender_sql <- sqlQuery(myconn, "select distinct results_animal_gender from [dbo].[main_final_2019] 
where results_animal_species is not null")
gender_sql$results_animal_gender <- as.character(gender_sql$results_animal_gender)


breed_sql <- sqlQuery(myconn, "select distinct results_animal_breed_is_crossbred as breed from [dbo].[main_final_2019] 
where results_animal_species is not null")
breed_sql$breed <- as.character(breed_sql$breed)

