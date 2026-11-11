
# Purpose: Pooled OLS, Fixed Effects, Random Effects, tests and diagnostics
library(tidyverse)
library(plm)
library(car)          
library(lmtest)         
library(sandwich)      
library(modelsummary)  


dfm <- read_rds("data/dfm_2013_2025.rds")

pdatam <- pdata.frame(dfm, index = c("bank", "year"))
pdim(pdatam)       


# ROA explained by NPL, CAR, size and LDR (one formula for all models)
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



modelsummary(list("Pooled" = pooled, "FE" = fe, "RE" = re), stars = TRUE)




#Diagonistic of model
car::vif(lm(f, data = pdatam))

bptest(f, data = pdatam, studentize = FALSE)


pbgtest(fe)

robust_cov <- vcovHC(fe, type = "HC1", cluster = "group")
coeftest(fe, vcov = robust_cov)

rob_fn <- function(x) vcovHC(x, type = "HC1", cluster = "group")

modelsummary(
  list(
    "Pooled" = pooled,
    "FE" = fe,
    "FE (Cluster-Robust)" = fe,
    "RE" = re
  ),
  vcov = list(NULL, NULL, rob_fn, NULL),
  stars = TRUE
)
