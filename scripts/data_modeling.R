library(tidyverse)
library(plm)

dfm <- read_rds("data/dfm_2013_2025.rds")

pdatam <- pdata.frame(dfm, index = c("bank", "year"))
pdim(pdatam)
f <- roa_w ~ npl_ratio_pct_w + car_crar_pct_w + size_ln_assets_w + ldr_w
pooled <- plm(f, data = pdatam, model = "pooling")
fe     <- plm(f, data = pdatam, model = "within")
re     <- plm(f, data = pdatam, model = "random")

summary(pooled)
summary(fe)
summary(re)

pFtest(fe, pooled)
plmtest(pooled, type = "bp")
phtest(fe, re)

install.packages("modelsummary")    
library(modelsummary)

modelsummary(list("Pooled" = pooled, "FE" = fe, "RE" = re), stars = TRUE)
