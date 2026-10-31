library(tidyverse)
library(plm)
raw <- read_csv("data/processed_BD_Banks_features_final.csv")
glimpse(raw)

# Data type validity check
df <- raw |>
  mutate(bank_id = as.factor(bank),
         year    = as.integer(year)) 

summary(df)
colSums(is.na(df))                     
df |> count(bank) |> print(n = 57)       
df |> count(year) |> print(n = 29)       
sum(duplicated(df[c("bank", "year")]))

pdata <- pdata.frame(df, index = c("bank", "year"))
pdim(pdata)