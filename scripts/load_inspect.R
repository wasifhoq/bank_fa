library(tidyverse)
library(plm)
library(lmtest)
library(sandwich)
library(car)
library(modelsummary)

raw <- read_csv("data/processed_BD_Banks_features_final.csv")
glimpse(raw)

# Fix data types
df <- raw |>
  mutate(bank = as.factor(bank),    
         year = as.integer(year))   

# Basic checks
summary(df)
colSums(is.na(df))                         
df |> count(bank) |> print(n = 57)          
df |> count(year) |> print(n = 29)          
sum(duplicated(df[c("bank", "year")]))      

# Declare panel (full data)
pdata <- pdata.frame(df, index = c("bank", "year"))
pdim(pdata)    # Unbalanced Panel: n = 57, T = 5-29, N = 780