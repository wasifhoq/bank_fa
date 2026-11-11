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

### Nov 8, 2026: data_modeling.R
- Stores one formula in f: ROA explained by NPL, CAR, size and LDR (_w columns)
- Runs Pooled OLS, Fixed Effects (own intercept per bank) and Random Effects
- F-test p < 2.2e-16, LM test p < 2.2e-16, Hausman p = 0.0007, so I use fixed effects
- NPL is negative and significant in all models (FE: -0.044), so more bad loans goes with lower ROA
- CAR and LDR are significant in pooled but not in FE: they separate profitable banks from others, but changes within a bank don't clearly move its ROA
- Size is not significant in any model (large standard error in FE)
- Random effects: 58% of ROA variance is between-bank differences
- FE R-squared (0.22) is the within R-squared, so it can't be compared with pooled (0.51)

### Nov 11, 2026: Step 4: diagnostics
- Loaded plm, car, lmtest and sandwich (the first errors happened because plm was not loaded in the session)
- Breusch-Pagan p < 2.2e-16: unequal variance
- Breusch-Godfrey/Wooldridge p = 2.8e-12: serial correlation within banks
- Because of both, I report FE with cluster-robust standard errors (clustered by bank)
- NPL stays significant: estimate -0.0443, robust SE 0.0105 (was 0.0036), p = 0.00003
- CAR, size and LDR are not significant in FE, before or after the correction
- Lesson: coefficients stay the same when standard errors are corrected; only SEs and p-values change
- Limits: 57 clusters is approximate; association, not cause; not yet tested without Union Bank 2024 or with year effects
- Then diagnostics (VIF, heteroskedasticity, autocorrelation) and the Quarto report

### What I'd Improve Next (Honest Self-Critique)
- **Dynamic Panel / System GMM**: In banking, past profits usually drive current profits (`lag(roa)`). Also, bad loans reduce profits, but low profits also make it harder for banks to recover loans (two-way causality). A static fixed-effects model can't fix that endogeneity, but a System GMM model (Arellano-Bover / Blundell-Bond) would.
- **Sensitivity test without Union Bank 2024**: Union Bank had an extreme loss in 2024 (ROA -87.2%). Even though winsorizing pulled it back to -5.78%, I should re-run the regression completely dropping Union Bank to verify that one failing bank isn't exaggerating the NPL coefficient.
- **External Macro Variables**: This Mendeley dataset only has balance sheet ratios. In reality, bank profits in Bangladesh are heavily hit by inflation, Bangladesh Bank interest rate caps (like the 9% lending cap), and GDP slowdowns. Merging World Bank or Bangladesh Bank data would be much more realistic than just using year dummies.
- **Separating Islamic vs Conventional banks**: Shariah-compliant banks in Bangladesh have different profit-loss sharing modes and deposit structures. Putting them all in the same bucket might hide different risk dynamics.
- **Cluster sample size caution**: 57 banks is okay for clustering, but since the panel is unbalanced (some banks only have 5 years), the asymptotic guarantees of cluster-robust standard errors might be slightly stretched.
