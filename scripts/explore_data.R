
# Values below the 1st or above the 99th percentile are replaced by those limits
winsor <- function(x, p = 0.01) {
  q <- quantile(x, c(p, 1 - p), na.rm = TRUE)
  pmin(pmax(x, q[1]), q[2])
}

dfm <- dfm |>
  mutate(across(c(roa, npl_ratio_pct, car_crar_pct, size_ln_assets, ldr),
                winsor, .names = "{.col}_w"))    

summary(dfm[c("roa", "roa_w", "ldr", "ldr_w")])  


pdatam <- pdata.frame(dfm, index = c("bank", "year"))
pdim(pdatam)       # expect: Unbalanced Panel: n = 57, T = 5-13, N = 670


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