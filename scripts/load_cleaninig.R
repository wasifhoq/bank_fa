# Exploring the data before feed to the model
source("scripts/load_inspect.R")
df |>
  mutate(check = net_income / total_assets * 100) |>
  select(bank, year, roa, check) |>
  head(8)

dfm <- df |>
  filter(year >= 2013) |>
  filter(!(bank == "Citizens Bank PLC" & year == 2020))

nrow(dfm)                
n_distinct(dfm$bank) 