# LEARNING LOG

### Oct 31, 2026: Step 1: Load data and declare panel
- Set up the RStudio project `bank_fa` with folders data/, scripts/, output/.
- Installed and loaded tidyverse and plm.
- Panel data = the same entities (banks) observed over several years.
  plm needs the entity column (bank) and time column (year).
- A panel can be balanced or unbalanced; plm handles both.
- `<-` stores a result; `|>` means "and then".
- glimpse(), names(), colSums(is.na()), and pdim() are my first checks
  for any new dataset.
- roe, net_income, zscore and ln_zscore are tied to ROA, so they should
  not be used to explain ROA.

### Nov 3, 2026: Step2: Inspecting the data
- Loads tidyverse (data work and plots) and plm (panel models)
- Reads the bank CSV into R and previews the columns with glimpse()
- Fixes data types so that bank becomes a category, year becomes a whole number
- Uses summary() to see the min, max, and average of each column
- Uses colSums(is.na(df)) to count missing values
- Uses count(bank) and count(year) to see rows per bank and per year
- Checks for duplicates to confirm no bank appears twice in the same year
- Declares the panel with pdata.frame(): bank is the entity, year is the time
- Confirms the structure with pdim(): 57 banks, 5 to 29 years each, 780 rows (unbalanced panel)

### Nov 5, 2026: Step3: Exploring the data
- Checks that ROA = net income / total assets x 100, so net income is not used as a predictor
- Uses arrange(roa) to sort ROA from lowest to highest and find unusual rows
- Finds two extreme outliers: Union Bank 2024 (ROA -87.2) and Citizens Bank 2020 (ROA -79.6); the next lowest is -14.8
- Drops Citizens Bank 2020 because total assets are only 25.5 (a probable data error, not verified against the original report)
- Keeps Union Bank 2024 because its total assets are on a normal scale (a real but extreme loss), and winsorizes it instead
- Filters the sample to 2013-2025, because few banks report before that: 670 rows, 57 banks
- Winsorizes ROA, NPL, CAR, size and LDR at the 1st and 99th percentile, so new columns end in _w and the originals are unchanged
- Re-declares the panel with pdata.frame() and confirms with pdim(): unbalanced panel, 57 banks, 5 to 13 years each, 670 rows
- Uses summary() on the _w columns to see typical values: median ROA 0.69, NPL 4.59, CAR 12.80
- Plots median ROA by year, the ROA histogram, and ROA vs NPL, and saves them in the output folder

### Nov 7, 2026: Explore data script
- Sources load_inspect.R to get the cleaned data (df)
- Checks that ROA = net income / total assets x 100, so net income is not used as a predictor
- Sorts ROA with arrange() to find outliers: Union Bank 2024 (-87.2) and Citizens Bank 2020 (-79.6)
- Builds the sample: 2013-2025, drops Citizens Bank 2020 (probable data error) -> 670 rows, 57 banks
- Winsorizes ROA, NPL, CAR, size and LDR at the 1st/99th percentile (new columns end in _w)
- Declares the panel with pdata.frame(): unbalanced, n = 57, T = 5-13, N = 670
- Runs summary() and cor() on the _w variables
- Plots median ROA by year and ROA vs NPL, and saves them in output/
- Saves the sample to data/dfm_2013_2025.rds for the models script