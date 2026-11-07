# LEARNING LOG

### Oct 31, 2026: Project setup
- Set up the RStudio project `bank_fa` with folders data/, scripts/, output/
- Installed and loaded tidyverse and plm
- `<-` stores a result; `|>` means "and then"
- Project 1 plan: rebuild the thesis analysis in R (pooled OLS vs fixed vs random effects, Hausman test, diagnostics, Quarto report)

### Nov 3, 2026: load_inspect.R
- Dataset: "A comprehensive panel dataset of Bangladeshi banks (1997-2025)", Yeasmin, Mendeley Data, CC BY 4.0. 780 rows, 57 banks, 25 columns
- Used this public dataset instead of my original 22-bank thesis data; it has no GDP or inflation columns
- Reads the CSV and previews the columns with glimpse()
- Fixes data types: bank becomes a category (factor), year becomes a whole number
- Uses summary() for min, max and average, and colSums(is.na(df)) to count missing values
- Uses count(bank) and count(year) to see rows per bank and per year
- Checks for duplicate bank-year pairs
- Declares the panel with pdata.frame(): bank is the entity, year is the time
- Confirms with pdim(): unbalanced panel, 57 banks, 5 to 29 years each, 780 rows
- Panel data = the same entities (banks) observed over several years; plm handles balanced and unbalanced panels

### Nov 5, 2026: Exploring the data
- Checks that ROA = net income / total assets x 100, so net income is not used as a predictor (roe, zscore and ln_zscore also look profit-based; not yet verified)
- Uses arrange(roa) to sort ROA from lowest to highest and find unusual rows
- Finds two extreme outliers: Union Bank 2024 (ROA -87.2) and Citizens Bank 2020 (ROA -79.6); the next lowest is -14.8
- Drops Citizens Bank 2020: total assets are only 25.5, a probable data error (not verified against the original report)
- Keeps Union Bank 2024: its total assets are on a normal scale (a real but extreme loss), so it is winsorized instead
- Filters the sample to 2013-2025, because few banks report before that: 670 rows, 57 banks
- Winsorizes ROA, NPL, CAR, size and LDR at the 1st and 99th percentile (new columns end in _w, originals unchanged)
- Re-declares the panel and confirms with pdim(): unbalanced, 57 banks, 5 to 13 years each, 670 rows
- Typical values (median): ROA 0.69, NPL 4.59, CAR 12.80
- Correlations: ROA vs NPL -0.67, ROA vs CAR +0.56, NPL vs CAR -0.63
- Plots median ROA by year and ROA vs NPL, and saves them in output/

### Nov 7, 2026: explore_data.R
- Moved the exploration into scripts/explore_data.R, which runs load_inspect.R with source()
- Saves the 2013-2025 sample to data/dfm_2013_2025.rds so the models script loads cleaned data
- Work is split into three scripts: load_inspect.R, explore_data.R, models.R (next)

### Limitations so far
- Public dataset, not my original thesis data; no GDP or inflation variables (year effects will be used instead)
- Citizens Bank 2020 was dropped on judgment, not verified against the source
- ldr_w and car_crar_pct_w are still very wide after winsorizing
- Some values look copied between banks (Krishi Bank and Rajshahi Krishi Unnayan Bank have identical CAR values in 2015-2019)
- Plan: rerun the model without Union Bank 2024 as a robustness check

### Next
- models.R: pooled OLS, fixed effects, random effects, F-test, LM test, Hausman test
- Then diagnostics (VIF, heteroskedasticity, autocorrelation) and the Quarto report