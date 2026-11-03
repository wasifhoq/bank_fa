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