# Purpose: choose the sample, handle outliers, explore, save the sample

source("scripts/load_inspect.R")    



df |>
  mutate(check = net_income / total_assets * 100) |>
  select(bank, year, roa, check) |>
  head(10)


df |>
  arrange(roa) |>
  select(bank, year, roa, total_assets, equity, net_income) |>
  head(10)

# Decision:
# - Citizens Bank 2020: DROPPED. Total assets are 25.5, far smaller than other
#   banks, so the extreme ROA comes from a tiny denominator (probable data
#   error, not verified against the original report).
# - Union Bank 2024: KEPT and windsorized. Total assets are on a normal scale,
#   so the extreme ROA comes from a very large loss.


# Window 2013-2025: few banks report before that
dfm <- df |>
  filter(year >= 2013) |>
  filter(!(bank == "Citizens Bank PLC" & year == 2020))

nrow(dfm)               
n_distinct(dfm$bank)   


# Values below the 1st or above the 99th percentile are replaced by those limits
windsor <- function(x, p = 0.01) {
  q <- quantile(x, c(p, 1 - p), na.rm = TRUE)
  pmin(pmax(x, q[1]), q[2])
}

dfm <- dfm |>
  mutate(across(c(roa, npl_ratio_pct, car_crar_pct, size_ln_assets, ldr),
                windsor, .names = "{.col}_w"))    

summary(dfm[c("roa", "roa_w", "ldr", "ldr_w")])  


pdatam <- pdata.frame(dfm, index = c("bank", "year"))
pdim(pdatam)      


dfm |>
  select(roa_w, npl_ratio_pct_w, car_crar_pct_w, size_ln_assets_w, ldr_w) |>
  summary()

dfm |>
  select(roa_w, npl_ratio_pct_w, car_crar_pct_w, size_ln_assets_w, ldr_w) |>
  cor() |>
  round(2)


dir.create("output", showWarnings = FALSE)

dfm |>
  group_by(year) |>
  summarise(median_roa = median(roa_w), n_banks = n()) |>
  ggplot(aes(year, median_roa)) +
  geom_line(color = "steelblue", linewidth = 1.2) +
  geom_point(aes(size = n_banks)) +
  labs(title = "Median ROA by year, 2013-2025",
       x = "Year", y = "Median ROA (%)", size = "Banks")
ggsave("output/median_roa_by_year.png", width = 7, height = 4)

ggplot(dfm, aes(npl_ratio_pct_w, roa_w)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "ROA vs NPL", x = "NPL (%)", y = "ROA (%)")
ggsave("output/roa_vs_npl.png", width = 6, height = 4)


write_rds(dfm, "data/dfm_2013_2025.rds")