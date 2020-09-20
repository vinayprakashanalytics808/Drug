USE [NewDatabase]
GO

/****** Object:  View [dbo].[summary_stat]    Script Date: 18-09-2020 23:49:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


alter view [dbo].[summary_stat] as
with summary_table as (
select results_onset_date, results_animal_species, results_animal_gender
, results_animal_breed_is_crossbred, results_unique_aer_id_number, results_animal_age_min
from [dbo].[main_final_2019]
where results_animal_species is not null and results_onset_date is not null ) 

select st.*, b.Name, o.result from summary_table st
inner join [dbo].[breed_final_2019] b on st.results_unique_aer_id_number = b.results_unique_aer_id_number
inner join [dbo].[outcome_final_altered1_2019] o on b.results_unique_aer_id_number = o.results_unique_aer_id_number

GO


select results_unique_aer_id_number, count(results_animal_age_min) as age from [dbo].[summary_table]
group by results_unique_aer_id_number order by age desc

select * from [dbo].[summary_table] where results_unique_aer_id_number = 'USA-USFDACVM-2019-US-046509'

select 
results_animal_species as Species, results_animal_gender as Gender, results_animal_breed_is_crossbred as Breed,
count(distinct results_unique_aer_id_number) as Records, min(results_animal_age_min) as age_min,
max(results_animal_age_min) as age_max
from summary_table1
where results_animal_species is not null and results_onset_date is not null  
--and results_animal_species = 'Dog' and
--results_animal_gender = 'Unknown' and results_animal_breed_is_crossbred = 'false'
group by 
results_animal_gender, 
results_animal_species, 
results_animal_breed_is_crossbred 
order by Records desc


select * from [dbo].[fn_species_records_onsetdate2]('Human', 'All', 'All')

select results_unique_aer_id_number, Breed, Name from [dbo].[breed_raw_2019]
unpivot (
Name for Breed in ([Breed 1],[Breed 2],[Breed 3],[Breed 4],[Breed 5],[Breed 6],[Breed 7],[Breed 8])
) as asd


