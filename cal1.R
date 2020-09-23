library(jsonlite)
library(qpcR)
library("stringr")
library(readxl)
library(dplyr)
library(tidyr)
library(purrr)
library(rlang)
# myList = rjson::fromJSON(file = "food001.json")

setwd(paste0(getwd(), "/animal"))

# ANimal
rm()
dat <- data.frame()
df2 <- data.frame()
for (i in 1){
  dat <- as.data.frame(fromJSON(paste0(getwd(), "/animal/animalandveterinary-event-0001-of-0001.json ","(",i,")/animalandveterinary-event-0001-of-0001.json"), flatten = TRUE))
  df2 <- bind_rows(dat, df2,.id = "col")
  # df <- qpcR:::rbind.na(dat, as.data.frame(do.call("rbind", dat)))
  # df <- rbind(dat, as.data.frame(do.call("cbind", dat)))
}
df2$Index <- 1:nrow(df2)
df1_final <- as.data.frame(apply(df2,2,as.character))
writexl::write_xlsx(df1_final, "df_sam1.xlsx")

#Results reaction
df1_final$results.reaction <- as.character(df1_final$results.reaction)
df2_animal <- df1_final[c("Index", "results.reaction")]
df2_animal$results.reaction <- as.character(df2_animal$results.reaction)
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
writexl::write_xlsx(df_reaction, "df_reaction_2019_rest.xlsx")

#Results drug
# rm(df2_animal)
# df1_final$results.outcome <- as.character(df1_final$results.outcome)
# df2_animal <- df1_final[c("Index", "results.outcome")]
# # df2_animal$results.drug <- as.character(df2_animal$results.drug)
# df2_animal$outcome <- purrr::map(df2_animal$results.outcome, ~eval(parse_expr(.)))
# dfs <- mapply(merge, df2_animal$Index, df2_animal$outcome)
# combine_dfs <- function(dfs) {
#   cols <- Reduce(union, sapply(dfs, names))
#   dfs <- lapply(dfs, function(x) {
#     x[setdiff(cols, names(x))] <- NA
#     x
#   })
#   Reduce(rbind, dfs)
# }
# df_outcome <- combine_dfs(dfs)





