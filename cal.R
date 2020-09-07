library(jsonlite)
library(qpcR)
library("stringr")
library(readxl)
library(dplyr)
library(tidyr)
myList = rjson::fromJSON(file = "food001.json")

setwd(paste0(getwd(), "/animal"))

# json_data <- c()
# for (i in 1:46){
#   json_data <- c(json_data, list.files(path = paste0(getwd(), "/animalandveterinary-event-0001-of-0001.json ","(",i,")")
#                            ,pattern="*.json",full.names = TRUE))
#   json_data
# }

# ANimal
  rm()
  dat <- data.frame()
  df2 <- data.frame()
  for (i in 1:1){
    dat <- as.data.frame(fromJSON(paste0(getwd(), "/animal/animalandveterinary-event-0001-of-0001.json ","(",i,")/animalandveterinary-event-0001-of-0001.json"), flatten = TRUE))
    df2 <- bind_rows(dat, df2,.id = "col")
    # df <- qpcR:::rbind.na(dat, as.data.frame(do.call("rbind", dat)))
    # df <- rbind(dat, as.data.frame(do.call("cbind", dat)))
  }
  df2$Index <- 1:nrow(df2)
  
# Drug  
  
  rm()
  dat <- data.frame()
  df2 <- data.frame()
  for (i in 1:1){
    dat <- as.data.frame(fromJSON(paste0(getwd(), "/Device/animalandveterinary-event-0001-of-0001.json ","(",i,")/device-510k-0001-of-0001.json"), flatten = TRUE))
    df2 <- bind_rows(dat, df2,.id = "col")
    # df <- qpcR:::rbind.na(dat, as.data.frame(do.call("rbind", dat)))
    # df <- rbind(dat, as.data.frame(do.call("cbind", dat)))
  }
  df2$Index <- 1:nrow(df2)
df1_final <- as.data.frame(apply(df2,2,as.character))
df1_final$results.reaction <- as.character(df1_final$results.reaction)


df2_animal <- df1_final[c("Index", "results.reaction")]
df2_animal$reaction <- purrr::map(df2_animal$results.reaction, ~eval(parse_expr(.)))
dfs <- mapply(merge, df2_animal$Index, df2_animal$reaction)
combine_dfs <- function(dfs) {
  cols <- Reduce(union, sapply(dfs, names))
  dfs <- lapply(dfs, function(x) {
    x[setdiff(cols, names(x))] <- NA
    x
  })
  Reduce(rbind, dfs)
}
df_reaction <- combine_dfs(dfs)

# df1_final$Index <- 1:nrow(df1_final)
# df1_final$uni_column <- as.numeric(paste(df1_final$col, df1_final$Index, sep = ""))
# writexl::write_xlsx(df1_final , "df1_31_40.xlsx")
# df1_final <- read_excel("df1_31_40.xlsx")
# df1_final_reactions <- df1_final[c("uni_column", "results.reaction", "results.drug", "results.outcome")]
# writexl::write_xlsx(df1_final_reactions, "reactions.xlsx")
# reactions <- read_excel("reactions.xlsx")
# reactions <- as.data.frame(reactions)
# # reactions <- head(reactions, n = 10)
# # sub_list <- gsub(paste0(")",",","list","("), ",", paste("list(",reactions$results.reaction,")", collapse = ","), fixed = TRUE)
# 
# sub_list_reactions <- paste0('list( ',paste0(reactions$results.reaction,collapse = ', '),' )')
# sub_list_reactions_list <- as.list(sub_list_reactions)
# results_reactions <- tibble(ID = c(reactions$uni_column), ColB = eval(parse(text = sub_list_reactions_list[[1]])))
# reactions_1 <- results_reactions %>% unnest_auto(ColB) %>% unnest(cols = c(veddra_term_code, veddra_term_name, veddra_version))
# reactions_1 <- as.data.frame(reactions_1)
# writexl::write_xlsx(reactions_1, "reactions_31_40.xlsx")
# 
# sub_list_drug <- paste0('list( ',paste0(reactions$results.drug,collapse = ', '),' )')
# sub_list_drug_list <- as.list(sub_list_drug)
# results_drug <- tibble(ID = c(reactions$uni_column), ColB = eval(parse(text = sub_list_drug_list[[1]])))
# drug_1 <- results_drug %>% unnest_auto(ColB) %>% unnest(cols = c(lot_number, off_label_use, route, brand_name, active_ingredients,
#                                                                  used_according_to_label,
#                                                                  dosage_form, atc_vet_code, manufacturer.name, 
#                                                                  manufacturer.registration_number))
# drug_1 <- as.data.frame(drug_1)
# writexl::write_xlsx(drug_1, "drug_31_40.xlsx")
# 
# # sub_list_outcome <- paste0('list( ',paste0(reactions$results.outcome,collapse = ', '),' )')
# # sub_list_outcome_list <- as.list(sub_list_outcome)
# # results_outcome <- tibble(ID = c(reactions$uni_column), ColB = eval(parse(text = sub_list_outcome_list[[1]])))
# # outcome_1 <- results_outcome %>% unnest_auto(ColB) %>% unnest(cols = c(medical_status, number_of_animals_affected))
# # outcome_1 <- as.data.frame(outcome_1)
# # writexl::write_xlsx(outcome_1, "outcome_1_10.xlsx")



















write.table(sub_list_reactions,"df.txt")
asd <- paste0(readLines("list1.txt"),collapse=" ")
# asd <- paste0(readLines("df_Copy.txt"),collapse=" ")

df_1_4 <- tibble(ID = 1:2,
                 ColB = list(list(ved = "19", ved_name = "No", vedd = "11") ,
                             list(ved = c("65", "83", "2"), ved_name = c("At", "Re", "Rum"),
                                  vedd = c("11", "11", "11"))))


df %>% unnest_auto(ColB) %>% unnest(cols = c(ved, ved_name, vedd))


df2_sam <- df2[c("Index", "results.reaction")]
df2_sam$results.reaction <- as.character(df2_sam$results.reaction)
df2_sam_reactions <- df2_sam %>%
  transform(results.reaction = strsplit(results.reaction, ",")) %>% unnest(results.reaction)